//
//  BaseController.swift
//  RoomVUAssigment
//
//  Created by tanaz on 22/12/1402 AP.
//

import Foundation
import UIKit
/**
 A base class for view controllers in your application. It provides a common methods.

 This class serves as a foundation for building more specific view controllers in your project. By inheriting from `BaseController`, you can leverage the function such as  `showAlertview` method to simplify displaying alert messages to the user.
 */

class BaseController: UIViewController {


  func showAlertview(message: String) {
    // create the alert
    let alert = UIAlertController(title: message, message: "" , preferredStyle: UIAlertController.Style.alert)

    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
    }))
    // show the alert
    self.present(alert, animated: true, completion: nil)

  }

}
