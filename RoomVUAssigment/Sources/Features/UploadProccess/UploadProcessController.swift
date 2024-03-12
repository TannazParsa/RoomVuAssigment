//
//  UploadProcessController.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit
import Combine

class UploadProcessController: BaseController {

  // MARK: -  Outlets

  @IBOutlet weak var uploadProgress: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!

  // MARK: - Variables
  var selectedImage: UIImage?

  private var viewModel: UserImageViewModel!
  private var cancellables = Set<AnyCancellable>()

  override func viewDidLoad() {
    let networkManager = ImageUploader()
    viewModel = UserImageViewModel(networking: networkManager) // Initialize ViewModel
    callUploadAPI()
  }
  // MARK: - Network Call
  // Initiates the image enhancement and upload process:
  private func callUploadAPI() {
    guard let img = self.selectedImage else {return}
    guard let image = img.jpegData(compressionQuality: 0.75) else {
      return
    }
    viewModel.enhanceUserImage(image: img, fileName: "File.jpg", mimType: "image/jpeg", imageData: image) { [weak self] result in
      switch result {
      case .success(_):
        self?.progressLabel.text = "Upload Completed"
      case let .failure(error):
        print(error.localizedDescription)
        self?.showAlertview(message: error.localizedDescription)


      }
    }
    viewModel.uploadProgressPublisher
        .sink { [weak self] progress in
          self?.updateProgress(progress: progress)
        }
        .store(in: &cancellables)
  }

  // Updates the progress bar and label based on received progress:
  private func updateProgress(progress: Double) {
    uploadProgress.progress = Float(progress / 100)  // Update progress bar
    progressLabel.text = "\(Int(progress ))% processed..." // Update label
  }
}
