//
//  LoginCollectionViewCell.swift
//  Audible
//
//  Created by Dennis Vera on 12/1/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class LoginCollectionViewCell: UICollectionViewCell {

    // MARK: - Static Properties

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    // MARK: - Properties

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
      backgroundColor = .brown
    }

    func configure(with onboarding: Onboarding) {
    }
}
