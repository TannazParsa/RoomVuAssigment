//
//  ImageUploadService.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
/// A protocol defining the contract for uploading images.
protocol ImageUploadService {
  func uploadImage(_ imageData: UploadImageModel,params: [String:String], completion: @escaping (Result<String, Error>) -> Void, uploadProgress: @escaping UploadProgress)
}
