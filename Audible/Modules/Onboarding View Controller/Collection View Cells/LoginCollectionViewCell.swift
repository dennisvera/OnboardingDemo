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

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "logo")
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let emailTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderWidth = 1
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()

  private let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderWidth = 1
    textField.isSecureTextEntry = true
    textField.placeholder = "Enter password"
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()

  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Log In", for: .normal)
    button.backgroundColor = .orange
    return button
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
    backgroundColor = .white

    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 14

    stackView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
//    passwordTextField.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stackView)
    addSubview(logoImageView)
//    addSubview(emailTextField)
//    addSubview(passwordTextField)

    NSLayoutConstraint.activate([
      // Logo Image View
      logoImageView.widthAnchor.constraint(equalToConstant: 160),
      logoImageView.heightAnchor.constraint(equalToConstant: 160),
      logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -200),

      emailTextField.heightAnchor.constraint(equalToConstant: 50),
//      passwordTextField.heightAnchor.constraint(equalToConstant: 50),

      // Stack View
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
      stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10)
    ])
  }

  func configure(with onboarding: Onboarding) {
  }
}
