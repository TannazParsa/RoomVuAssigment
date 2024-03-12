//
//  Storyboards.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit

/**
 * This class provides a convenient way to access storyboards in your project.
 * It defines a static property named `main` that returns a reference to the
 * storyboard named "Main" from the main bundle.
 */

struct Storyboards {

  /// A static property that returns a reference to the storyboard named "Main"
    /// from the main bundle.
  static var main: UIStoryboard {
    return UIStoryboard(name: Constants.MAIN_STORYBOARD_ID,
                        bundle: Bundle.main)
  }
}
