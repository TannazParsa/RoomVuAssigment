//
//  UIViewExtenstions.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit

extension UIView {

  /// Adds inspectable properties for corner radius, border color, and border width to UIViews.

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
  }
  @IBInspectable var borderColor: UIColor? {
    set {
      layer.borderColor = newValue?.cgColor
    }
    get {
      guard let color = layer.borderColor else {
        return nil
      }
      return UIColor(cgColor: color)
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return self.layer.borderWidth
    }
    set {
      self.layer.borderWidth = newValue
    }
  }
}
