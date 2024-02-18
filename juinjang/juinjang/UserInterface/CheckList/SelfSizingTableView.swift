//
//  SelfSizingTableView.swift
//  juinjang
//
//  Created by 임수진 on 2/18/24.
//

import Foundation
import UIKit

class SelfSizingTableView: UITableView {
  override var intrinsicContentSize: CGSize {
    contentSize
  }
  
  override func layoutSubviews() {
    invalidateIntrinsicContentSize()
    super.layoutSubviews()
  }
}
