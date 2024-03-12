//
//  UIImageExtenstions.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import UIKit
import Vision
import CoreML

enum RemoveBackroundResult {
  /// Indicates the final image with the background removed.
  case background
  /// Indicates the extracted background image.
  case finalImage
}

extension UIImage {
  /**
     Removes the background from an image using DeepLabV3 and Core ML.

     - Parameter returnResult: Specifies whether to return the final image with the background removed (`finalImage`) or the extracted background itself (`background`).

     - Returns: A new `UIImage` instance with the background removed, or nil if an error occurs.
     */
  func removeBackground(returnResult: RemoveBackroundResult) -> UIImage? {
    guard let model = getDeepLabV3Model() else { return nil }
    // Image pre-processing
    let width: CGFloat = 513
    let height: CGFloat = 513
    let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)

    // Convert image to pixel buffer and perform prediction
    guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
          let outputPredictionImage = try? model.prediction(image: pixelBuffer),
          let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
          let outputCIImage = CIImage(image: outputImage),
          // Create and blur a mask image based on the prediction
          let maskImage = outputCIImage.removeWhitePixels(),
          let maskBlurImage = maskImage.applyBlurEffect() else { return nil }

    switch returnResult {
    case .finalImage:
      guard let resizedCIImage = CIImage(image: resizedImage),
            let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
      let finalImage = UIImage(ciImage: compositedImage)
        .resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    case .background:
      let finalImage = UIImage(
        ciImage: maskBlurImage,
        scale: scale,
        orientation: self.imageOrientation
      ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }
  }

  private func getDeepLabV3Model() -> DeepLabV3? {
    do {
      let config = MLModelConfiguration()
      return try DeepLabV3(configuration: config)
    } catch {
      print("Error loading model: \(error)")
      return nil
    }
  }

}

extension CIImage {
  /**
     Removes white pixels from a CIImage, effectively creating a mask.
     - Returns: A new CIImage with white pixels removed, or nil if an error occurs.
     */

  func removeWhitePixels() -> CIImage? {
    let chromaCIFilter = chromaKeyFilter()
    chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
    return chromaCIFilter?.outputImage
  }

  /**
     Composites an image with a mask using the "CISourceOutCompositing" filter.

     - Parameter mask: The CIImage to use as a mask.

     - Returns: A new CIImage representing the composite image, or nil if an error occurs.
     */

  func composite(with mask: CIImage) -> CIImage? {
    return CIFilter(
      name: "CISourceOutCompositing",
      parameters: [
        kCIInputImageKey: self,
        kCIInputBackgroundImageKey: mask
      ]
    )?.outputImage
  }
  /**
     Applies a Gaussian blur effect to a CIImage.

     - Returns: A new CIImage with the blur effect applied, or nil if an error occurs.
     */

  func applyBlurEffect() -> CIImage? {
    let context = CIContext(options: nil)
    let clampFilter = CIFilter(name: "CIAffineClamp")!
    clampFilter.setDefaults()
    clampFilter.setValue(self, forKey: kCIInputImageKey)

    guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
    currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
    currentFilter.setValue(2, forKey: "inputRadius")
    guard let output = currentFilter.outputImage,
          let cgimg = context.createCGImage(output, from: extent) else { return nil }

    return CIImage(cgImage: cgimg)
  }

  // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
  private func chromaKeyFilter() -> CIFilter? {
    let size = 64
    var cubeRGB = [Float]()

    for z in 0 ..< size {
      let blue = CGFloat(z) / CGFloat(size - 1)
      for y in 0 ..< size {
        let green = CGFloat(y) / CGFloat(size - 1)
        for x in 0 ..< size {
          let red = CGFloat(x) / CGFloat(size - 1)
          let brightness = getBrightness(red: red, green: green, blue: blue)
          let alpha: CGFloat = brightness == 1 ? 0 : 1
          cubeRGB.append(Float(red * alpha))
          cubeRGB.append(Float(green * alpha))
          cubeRGB.append(Float(blue * alpha))
          cubeRGB.append(Float(alpha))
        }
      }
    }

    let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

    let colorCubeFilter = CIFilter(
      name: "CIColorCube",
      parameters: [
        "inputCubeDimension": size,
        "inputCubeData": data
      ]
    )
    return colorCubeFilter
  }

  // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
  private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
    let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
    var brightness: CGFloat = 0
    color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
    return brightness
  }

}
