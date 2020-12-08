//
//  HomeViewController.swift
//  Audible
//
//  Created by Dennis Vera on 12/6/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

  // MARK: - Properties

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.image = #imageLiteral(resourceName: "home")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }

  // MARK: - Helper Methods

  private func setupView() {
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(handleSignOut))

    title = "Library"

    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc private func handleSignOut() {
    UserDefaults.standard.setIsLoggedIn(value: false)

    let loginController = LogginViewController()
    loginController.modalPresentationStyle = .fullScreen
    present(loginController, animated: true)
  }
}
