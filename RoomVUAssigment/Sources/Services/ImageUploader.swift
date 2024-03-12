//
//  ImageUploader.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import Alamofire

typealias UploadProgress = (Double) -> Void

class ImageUploader: ImageUploadService {

  /// Uploads an image to a server using Alamofire's multipart form data upload functionality.

  func uploadImage(_ imageFileData: UploadImageModel, params: [String:String], completion: @escaping (Result<String, Error>) -> Void, uploadProgress: @escaping UploadProgress) {
    let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data",
        "token": Constants.API_TOKEN
    ]
    // Create multipart form data with image and additional parameters
    AF.upload(
        multipartFormData: { multipartFormData in
          multipartFormData.append(imageFileData.image.jpegData(
                compressionQuality: 0.75)!,
                withName: "image",
                                   fileName: "\(imageFileData.fileName).jpeg", mimeType: imageFileData.mimeType
            )
          for param in params {
              let value = param.value.data(using: String.Encoding.utf8)!
              multipartFormData.append(value, withName: param.key)
          }
        },
        to: Constants.Base_URL + Constants.USER_IMAGE_ENDPOINT,
        method: .post,
        headers: headers

    ).uploadProgress { progress in
      // Access progress information here
      let uploadPercent = progress.fractionCompleted * 100
      uploadProgress(uploadPercent)

    }
    .responseString { response in
        if let error = response.error {
          completion(.failure(error))
          print(error.localizedDescription)
          return
        }
        guard let responseString = response.value else {
          completion(.failure(NSError(domain: "Response Parsing Error", code: 2, userInfo: nil)))
          return
        }
        completion(.success(responseString))
      }
  }
}
