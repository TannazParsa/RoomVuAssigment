//
//  UploadImageModel.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit

struct UploadImageModel {
  let image: UIImage
  let fileName: String? 
  let mimeType: String

  init(image: UIImage, fileName: String? = nil, mimeType: String = "image/jpeg") {
    self.image = image
    self.fileName = fileName
    self.mimeType = mimeType
  }
}
