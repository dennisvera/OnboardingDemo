//
//  OnboardingCollectionViewCell.swift
//  Audible
//
//  Created by Dennis Vera on 11/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleToFill
    return imageView
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
    backgroundColor = .red
  }
}
