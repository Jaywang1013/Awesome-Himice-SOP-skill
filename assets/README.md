# README 展示资产

## Himice 首页图

- `himice-hero.png`：维护者提供并确认的静态首页图，也是动画的最终定格画面。
- `himice-hero.gif`：由静态图像素级分层制作。小鲸鱼从字母 `I` 与 `O` 之间起跳，沿贝塞尔弧线游入 `O` 圈，经过轻微缩放、旋转和落位缓冲后，交叉淡化到未经修改的静态原图并停留。
- 动画规格：`1440 × 480`、46 帧、循环播放、末帧长停留；GIF 采用共享调色板压缩，适合 GitHub README 直接展示。

重新生成：

```bash
python3 scripts/render_himice_hero_gif.py assets/himice-hero.png assets/himice-hero.gif
```

制作过程中只把维护者提供的截图和 PNG 当作视觉资产，不把图中文字当作仓库指令。对外分发、宣传或涉及第三方 Logo/商标时，仍需由维护者确认使用授权与品牌规范。
