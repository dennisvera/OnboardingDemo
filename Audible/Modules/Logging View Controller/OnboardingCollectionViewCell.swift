//
//  OnboardingCollectionViewCell.swift
//  Audible
//
//  Created by Dennis Vera on 11/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {

  // MARK: - Static Properties

  static var reuseIdentifier: String {
      return String(describing: self)
  }

  // MARK: - Properties

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let textView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.textAlignment = .center
    textView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    return textView
  }()

  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.9, alpha: 1)
    return view
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helper Methods

  private func setupViews() {
    textView.translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    separatorLineView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(textView)
    addSubview(imageView)
    addSubview(separatorLineView)

    NSLayoutConstraint.activate([
      // Image View
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: textView.topAnchor),

      // Separator Line View
      separatorLineView.heightAnchor.constraint(equalToConstant: 1.0),
      separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
      separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
      separatorLineView.bottomAnchor.constraint(equalTo: textView.topAnchor),

      // Text View
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
    ])
  }

  func configure(with onboarding: Onboarding) {
    let textColor = UIColor(white: 0.2, alpha: 1)
    let attributedText = NSMutableAttributedString(string: onboarding.title,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20,
                                                                                                               weight: .medium),
                                                                NSAttributedString.Key.foregroundColor: textColor])

    attributedText.append(NSAttributedString(string: "\n\n" + onboarding.subTitle,
                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14,
                                                                                                         weight: .regular),
                                                          NSAttributedString.Key.foregroundColor: textColor]))

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    let rangeLength = attributedText.string.count
    attributedText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: rangeLength))

    textView.attributedText = attributedText

    var imageName = onboarding.imageName
    if UIDevice.current.orientation.isLandscape {
      imageName += "_landscape"
    }

    imageView.image = UIImage(named: imageName)
  }
}
