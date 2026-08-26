#!/usr/bin/env python3
"""Render the animated Himice README hero from the approved static PNG.

The script preserves the supplied wordmark exactly in the final frame. During
the entrance it extracts the whale from the raster source, moves it along a
cubic path, then crossfades into the untouched source image.
"""

from __future__ import annotations

import argparse
import math
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter


SOURCE_SIZE = (2172, 724)
OUTPUT_SIZE = (1440, 480)

# Hand-authored around the whale silhouette in the approved 2172 x 724 source.
# The outer O remains in the static base; only the inner whale and tail travel.
WHALE_POLYGON = [
    (1318, 296),
    (1388, 296),
    (1440, 312),
    (1483, 344),
    (1512, 386),
    (1527, 438),
    (1534, 472),
    (1547, 480),
    (1561, 469),
    (1576, 452),
    (1596, 442),
    (1625, 440),
    (1641, 446),
    (1622, 460),
    (1607, 477),
    (1600, 491),
    (1608, 509),
    (1621, 532),
    (1649, 558),
    (1625, 562),
    (1593, 551),
    (1572, 532),
    (1553, 507),
    (1535, 494),
    (1495, 483),
    (1452, 465),
    (1412, 441),
    (1376, 408),
    (1345, 370),
    (1323, 344),
]


def smoothstep(value: float) -> float:
    value = max(0.0, min(1.0, value))
    return value * value * (3.0 - 2.0 * value)


def cubic_point(
    t: float,
    p0: tuple[float, float],
    p1: tuple[float, float],
    p2: tuple[float, float],
    p3: tuple[float, float],
) -> tuple[float, float]:
    omt = 1.0 - t
    x = omt**3 * p0[0] + 3 * omt**2 * t * p1[0] + 3 * omt * t**2 * p2[0] + t**3 * p3[0]
    y = omt**3 * p0[1] + 3 * omt**2 * t * p1[1] + 3 * omt * t**2 * p2[1] + t**3 * p3[1]
    return x, y


def build_background_fill(source: Image.Image) -> Image.Image:
    """Reconstruct the dark backdrop from clean top and bottom scanlines."""
    width, height = source.size
    top_y, bottom_y = 42, height - 42
    top = [source.getpixel((x, top_y)) for x in range(width)]
    bottom = [source.getpixel((x, bottom_y)) for x in range(width)]
    fill = Image.new("RGB", source.size)
    px = fill.load()
    for y in range(height):
        t = max(0.0, min(1.0, (y - top_y) / (bottom_y - top_y)))
        for x in range(width):
            px[x, y] = tuple(round(top[x][c] * (1.0 - t) + bottom[x][c] * t) for c in range(3))
    return fill


def separate_layers(source: Image.Image) -> tuple[Image.Image, Image.Image, tuple[int, int, int, int]]:
    region = Image.new("L", source.size, 0)
    ImageDraw.Draw(region).polygon(WHALE_POLYGON, fill=255)

    foreground = Image.new("L", source.size, 0)
    src_px = source.load()
    fg_px = foreground.load()
    region_px = region.load()
    for y in range(source.height):
        for x in range(source.width):
            if not region_px[x, y]:
                continue
            red, green, blue = src_px[x, y]
            is_blue = blue > 72 and blue > red * 1.22 and blue > green * 0.92
            is_eye = red > 145 and green > 145 and blue > 145
            if is_blue or is_eye:
                fg_px[x, y] = 255

    alpha = foreground.filter(ImageFilter.GaussianBlur(0.7))
    bbox = alpha.getbbox()
    if bbox is None:
        raise RuntimeError("Could not isolate whale from source image")

    whale = source.convert("RGBA").crop(bbox)
    whale.putalpha(alpha.crop(bbox))

    # Rebuild a clean empty O instead of leaving a ghost of the integrated
    # whale. This temporary O is intentionally simple; the untouched approved
    # mark replaces it during the terminal crossfade.
    background = build_background_fill(source)
    clear = Image.new("L", source.size, 0)
    clear_draw = ImageDraw.Draw(clear)
    clear_draw.ellipse((1182, 142, 1644, 582), fill=255)
    clear_draw.polygon([(1510, 410), (1662, 410), (1662, 585), (1510, 585)], fill=255)
    clear = clear.filter(ImageFilter.GaussianBlur(1.0))
    base = source.copy()
    base.paste(background, (0, 0), clear)

    ring_mask = Image.new("L", source.size, 0)
    ring_draw = ImageDraw.Draw(ring_mask)
    ring_draw.ellipse((1202, 168, 1608, 550), fill=255)
    ring_draw.ellipse((1284, 248, 1528, 476), fill=0)
    ring_mask = ring_mask.filter(ImageFilter.GaussianBlur(0.75))
    ring_gradient = Image.new("RGB", source.size)
    gradient_px = ring_gradient.load()
    for y in range(source.height):
        t = max(0.0, min(1.0, (y - 168) / (550 - 168)))
        color = (
            round(70 * (1.0 - t) + 10 * t),
            round(146 * (1.0 - t) + 91 * t),
            round(255 * (1.0 - t) + 244 * t),
        )
        for x in range(1188, 1620):
            gradient_px[x, y] = color
    base.paste(ring_gradient, (0, 0), ring_mask)
    return base, whale, bbox


def add_bubbles(frame: Image.Image, progress: float, path_center: tuple[float, float]) -> None:
    if progress < 0.08 or progress > 0.82:
        return
    layer = Image.new("RGBA", frame.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    cx, cy = path_center
    fade = math.sin(math.pi * min(1.0, (progress - 0.08) / 0.74))
    for index, (dx, dy, radius) in enumerate(((-52, 28, 5), (-78, 8, 3), (-102, 34, 2))):
        drift = 9 * math.sin(progress * math.pi * 3 + index)
        x = cx + dx - drift
        y = cy + dy - index * 7
        alpha = round(105 * fade * (1.0 - index * 0.18))
        draw.ellipse((x - radius, y - radius, x + radius, y + radius), outline=(63, 139, 255, alpha), width=2)
    glow = layer.filter(ImageFilter.GaussianBlur(2.0))
    frame.alpha_composite(glow)
    frame.alpha_composite(layer)


def transformed_sprite(sprite: Image.Image, scale: float, angle: float) -> Image.Image:
    width = max(1, round(sprite.width * scale))
    height = max(1, round(sprite.height * scale * (1.0 + 0.035 * math.sin(scale * math.pi))))
    resized = sprite.resize((width, height), Image.Resampling.LANCZOS)
    return resized.rotate(angle, resample=Image.Resampling.BICUBIC, expand=True)


def render(source_path: Path, output_path: Path) -> None:
    source = Image.open(source_path).convert("RGB")
    if source.size != SOURCE_SIZE:
        raise ValueError(f"Expected {SOURCE_SIZE[0]}x{SOURCE_SIZE[1]} source, got {source.size}")

    base_full, whale_full, bbox = separate_layers(source)
    sx = OUTPUT_SIZE[0] / SOURCE_SIZE[0]
    sy = OUTPUT_SIZE[1] / SOURCE_SIZE[1]
    base = base_full.resize(OUTPUT_SIZE, Image.Resampling.LANCZOS).convert("RGBA")
    final = source.resize(OUTPUT_SIZE, Image.Resampling.LANCZOS).convert("RGBA")
    whale = whale_full.resize(
        (round(whale_full.width * sx), round(whale_full.height * sy)),
        Image.Resampling.LANCZOS,
    )

    final_center = ((bbox[0] + bbox[2]) * 0.5 * sx, (bbox[1] + bbox[3]) * 0.5 * sy)
    path = (
        (727.0, 353.0),
        (742.0, 105.0),
        (914.0, 88.0),
        final_center,
    )

    frames: list[Image.Image] = []
    durations: list[int] = []

    frames.append(base.convert("RGB"))
    durations.append(420)

    motion_frames = 38
    for index in range(motion_frames):
        raw = index / (motion_frames - 1)
        progress = smoothstep(raw)
        center = cubic_point(progress, *path)

        # Scale-in with a small landing overshoot. Rotation follows the rise,
        # dive, and final settle without making the logo feel cartoon-rubbery.
        scale = 0.22 + 0.78 * progress
        if progress > 0.78:
            landing = (progress - 0.78) / 0.22
            scale += 0.065 * math.sin(math.pi * landing)
        angle = (
            -8.0 * (1.0 - progress)
            - 6.0 * math.sin(math.pi * min(1.0, progress / 0.58))
            + 10.0 * math.sin(math.pi * max(0.0, (progress - 0.52) / 0.48))
        )
        angle *= 1.0 - smoothstep(max(0.0, (progress - 0.84) / 0.16))

        frame = base.copy()
        add_bubbles(frame, progress, center)
        moving = transformed_sprite(whale, scale, angle)
        x = round(center[0] - moving.width / 2)
        y = round(center[1] - moving.height / 2)
        frame.alpha_composite(moving, (x, y))
        frames.append(frame.convert("RGB"))
        durations.append(50)

    # Crossfade into the untouched approved art so the terminal frame is exact.
    settled = frames[-1]
    for index in range(1, 8):
        mix = smoothstep(index / 7)
        frames.append(Image.blend(settled, final.convert("RGB"), mix))
        durations.append(55)

    frames.append(final.convert("RGB"))
    durations.append(1850)

    # One shared palette prevents color pumping and keeps the README asset small.
    palette = final.convert("RGB").quantize(colors=128, method=Image.Quantize.MEDIANCUT)
    indexed = [frame.quantize(palette=palette, dither=Image.Dither.FLOYDSTEINBERG) for frame in frames]
    output_path.parent.mkdir(parents=True, exist_ok=True)
    indexed[0].save(
        output_path,
        save_all=True,
        append_images=indexed[1:],
        duration=durations,
        loop=0,
        optimize=True,
        disposal=1,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    render(args.source, args.output)


if __name__ == "__main__":
    main()
