//
//  CustomTextField+Helpers.swift
//  Audible
//
//  Created by Dennis Vera on 12/4/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class CustomTExtField: UITextField {

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
  }
}
