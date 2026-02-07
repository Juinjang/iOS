//
//  UIScreen+Extension.swift
//  juinjang
//
//  Created by 조유진 on 7/14/24.
//

import UIKit

extension UIScreen {
  /// - Mini, SE: 375.0
  /// - pro: 390.0
  /// - pro max: 428.0
    var isWiderThan375pt: Bool { self.bounds.size.width > 375 }
    var isWiderThan428pt: Bool { self.bounds.size.width >= 428}
}
