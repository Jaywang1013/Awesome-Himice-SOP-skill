import Foundation
import Vision
import AppKit

let path = CommandLine.arguments[1]
guard let img = NSImage(contentsOfFile: path),
      let tiff = img.tiffRepresentation,
      let bmp = NSBitmapImageRep(data: tiff),
      let cg = bmp.cgImage else { FileHandle.standardError.write("load fail\n".data(using:.utf8)!); exit(1) }
let w = CGFloat(cg.width), h = CGFloat(cg.height)
let req = VNRecognizeTextRequest()
req.recognitionLevel = .accurate
req.recognitionLanguages = ["zh-Hans", "en-US"]
req.usesLanguageCorrection = false
let handler = VNImageRequestHandler(cgImage: cg, options: [:])
try handler.perform([req])
for obs in (req.results ?? []) {
    guard let c = obs.topCandidates(1).first else { continue }
    let bb = obs.boundingBox
    let x = bb.origin.x * w
    let y = (1 - bb.origin.y - bb.size.height) * h
    print(String(format: "%.0f\t%.0f\t%.0f\t%.0f\t%@", x, y, bb.size.width * w, bb.size.height * h, c.string))
}
