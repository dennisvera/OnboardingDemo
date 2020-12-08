//
//  UserDefaults+Helpers.swift
//  Audible
//
//  Created by Dennis Vera on 12/8/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

extension UserDefaults {

  enum UserDefaultsKeys: String {
    case isLoggedIn
  }

  func setIsLoggedIn(value: Bool) {
    set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    synchronize()
  }

  func isLoggedIn() -> Bool {
    return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
  }
}
