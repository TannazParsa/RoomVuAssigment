import UIKit
import PhotosUI

// This view controller manages the user profile screen, allowing users to view and edit their profile information and profile picture.

class UserProfileViewController: UIViewController {

  // MARK: - IBOutlets

  @IBOutlet weak var editProfileButtton: UIButton!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var locationNameLabel: UILabel!
  @IBOutlet weak var getPremiumButton: UIButton!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  @IBOutlet weak var userProfileImageButton: UIButton!

  // MARK: - Lifecycle Methods

  override func viewDidLoad() {

  }
  // MARK: - IBActions

// Open EditHeadshotController for editing profile picture
  @IBAction func editProfileButtonTapped(_ sender: Any) {
    let headShotVC = Storyboards.main.instantiateViewController(withIdentifier: Constants.EDIT_HEADSHOT_VC_ID) as! EditHeadshotController
    headShotVC.modalPresentationStyle = .fullScreen
    present(headShotVC, animated: true)
  }

  @IBAction func profileAvatarButtonTapped(_ sender: Any) {
    openPhotosLibrary()
  }

  // MARK: - Helper Methods

// Configure and present the photo picker
  func openPhotosLibrary() {
    var config = PHPickerConfiguration() // Set selection limit (optional)
    config.filter = .images // Filter to only show images (optional)
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    present(picker, animated: true, completion: nil)
  }

// Open EditHeadshotController to potentially edit and save the selected image
  func openEditHeadShot(selectedImg: UIImage) {
    let headShotVC = Storyboards.main.instantiateViewController(withIdentifier: Constants.EDIT_HEADSHOT_VC_ID) as! EditHeadshotController
    headShotVC.selectedImage = selectedImg
    headShotVC.modalPresentationStyle = .fullScreen
    present(headShotVC, animated: true)
  }
}
// MARK: - PHPickerViewControllerDelegate

// Handle results from the photo picker
extension UserProfileViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    if let itemprovider = results.first?.itemProvider{

      if itemprovider.canLoadObject(ofClass: UIImage.self){
        itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
          if let error {
            print(error)
          }
          if let selectedImage = image as? UIImage {
            DispatchQueue.main.async {
              self.openEditHeadShot(selectedImg: selectedImage)
            }
          }
        }
      }
    }
  }
}
