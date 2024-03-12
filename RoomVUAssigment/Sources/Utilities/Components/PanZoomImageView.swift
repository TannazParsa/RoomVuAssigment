//
//  PanZoomImageView.swift
//  RoomVUAssigment
//
//  Created by tanaz on 21/12/1402 AP.
//

import Foundation
import UIKit

class PanZoomImageView: UIScrollView {

  // MARK: - Inspectable Property

    @IBInspectable
     var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
  // MARK: - Private Subviews

    private let imageView = UIImageView()

  // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    convenience init(img: UIImage) {
        self.init(frame: .zero)
        self.image = img
    }

  // MARK: - Private Setup

    private func commonInit() {
        // Setup image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
      imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Setup scroll view
        minimumZoomScale = 1
        maximumZoomScale = 5
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self

      let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }

  // MARK: - Gesture Handling

  @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
    if zoomScale == 1 {
      setZoomScale(2, animated: true)
    } else {
      setZoomScale(1, animated: true)
    }
  }

}
// MARK: - UIScrollViewDelegate

extension PanZoomImageView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
