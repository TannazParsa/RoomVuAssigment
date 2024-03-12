//
//  EditHeadshotController.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit
import Vision
import CoreML
// MARK: - Header

// This class allows users to edit and prepare a headshot for upload.

class EditHeadshotController: BaseController {

  // MARK: - IBOutlets

  @IBOutlet weak var zoomSlider: UISlider!
  @IBOutlet weak var selectedPhotoView: PanZoomImageView!
  @IBOutlet weak var cancleButton: UIButton!
  @IBOutlet weak var uploadHeadshotButton: UIButton!
  @IBOutlet weak var removeBgSwitch: UISwitch!
  @IBOutlet weak var rotateButton: UIButton!
  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var minusButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!

  // MARK: - Properties

  var selectedImage: UIImage?
  var currentRotationAngle: CGFloat = 0.0

  // MARK: - Lifecycle Methods

  override func viewDidLoad() {
    guard let selectedImg = self.selectedImage else {return}
    selectedPhotoView.image = selectedImg
    zoomSlider.value = 0.0
    zoomSlider.maximumValue = 5
    zoomSlider.minimumValue = 1
    zoomSlider.addTarget(self, action: #selector(zoomSliderValueChanged), for: .valueChanged)
    removeBgSwitch.addTarget(self, action: #selector(removeBgSwitchValueChanged), for: .valueChanged)
  }

  // MARK: - Actions

  // Closes the editing screen without saving changes
  @IBAction func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }

  // Zooms in on the headshot image
  @IBAction func plusButtonTapped(_ sender: Any) {
    zoomSlider.value = zoomSlider.value + 0.1
    selectedPhotoView.zoomScale = selectedPhotoView.zoomScale + 0.1

  }
  // Zooms out on the headshot image
  @IBAction func minusButtonTapped(_ sender: Any) {
    zoomSlider.value = zoomSlider.value - 0.1
    selectedPhotoView.zoomScale = selectedPhotoView.zoomScale - 0.1
  }

  // Navigates to the upload process screen, passing the edited image
  @IBAction func uploadButtonTapped(_ sender: Any) {
    let uploadProcessVC = Storyboards.main.instantiateViewController(withIdentifier: "UploadProcessController") as! UploadProcessController
    uploadProcessVC.modalPresentationStyle = .fullScreen
    uploadProcessVC.selectedImage = self.selectedImage
    present(uploadProcessVC, animated: true)
  }

  // Cancels editing and returns to the previous screen
  @IBAction func cancleButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }

  // Rotates the headshot image by 90 degrees clockwise
  @IBAction func rotateButtonnTapped(_ sender: Any) {
    currentRotationAngle += CGFloat(Double.pi / 2) // Rotate by 90 degrees (pi/2 radians)
      UIView.animate(withDuration: 0.3, animations: {
        self.selectedPhotoView.transform = CGAffineTransform(rotationAngle: self.currentRotationAngle)
      })
  }
  // Handles changes in the zoom slider value
  @objc func zoomSliderValueChanged() {
    selectedPhotoView.zoomScale = CGFloat(zoomSlider.value)
  }

  // Toggles background removal on/off
  @objc func removeBgSwitchValueChanged() {
    guard let selectedImg = selectedImage else {return}
    selectedPhotoView.image = removeBgSwitch.isOn ? selectedImg.removeBackground(returnResult: .finalImage) : selectedImg
    self.selectedImage = selectedPhotoView.image
  }
}
