//
//  SceneDelegate.swift
//  Audible
//
//  Created by Dennis Vera on 11/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Initialize Window
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)

    // Configure Window
    window?.rootViewController = MainNavigationController()

    // Make Key and Visible
    window?.makeKeyAndVisible()
  }
}
