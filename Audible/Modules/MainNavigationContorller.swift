//
//  MainNavigationContorller.swift
//  Audible
//
//  Created by Dennis Vera on 12/6/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class MainNavigationController: UINavigationController {

  // MARK: - Properties

  let isLoggedIn = true

  // MARK: - View Life Cycle 

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }

  // MARK: - Helper Methods

  private func setupView() {
    view.backgroundColor = .white

    if isLoggedIn {
      let homeViewController = HomeViewController()
      viewControllers = [homeViewController]
    } else {
      perform(#selector(showLogging), with: nil, afterDelay: 0.01)
      showLogging()
    }
  }

  @objc private func showLogging() {
    let logginViewController = LogginViewController()
    logginViewController.modalPresentationStyle = .fullScreen

    present(logginViewController, animated: true)
  }
}
