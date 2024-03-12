//
//  ImageUploadViewModel.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit
import Combine

class UserImageViewModel {

  private let progressSubject = PassthroughSubject<Double, Never>()
  var uploadProgressPublisher: AnyPublisher<Double, Never> {
      return progressSubject.eraseToAnyPublisher()
    }

  private let networking: ImageUploadService
  var uploadProgress: Double?
  init(networking: ImageUploader) {
    self.networking = networking
  }

  func enhanceUserImage(image: UIImage,fileName: String, mimType: String , imageData: Data, completion: @escaping (Result<String, UserImageError>) -> Void) {

    networking.uploadImage(UploadImageModel(image: image, fileName: fileName, mimeType: mimType), params: [:]) { result in
      switch result {
      case let .success(response):
        completion(.success(response)) // Handle successful upload
      case let .failure(error):
        completion(.failure(.networkError(error))) // Handle network error
      }
    }uploadProgress: { [weak self] percent in
      self?.progressSubject.send(percent)
    }
  }
}
// Define UserImageError enum for your specific error handling
enum UserImageError: Error {
  case enhancementFailed(String)
  case networkError(Error)
}
