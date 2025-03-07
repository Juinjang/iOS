//
//  ContentWrappingTableView.swift
//  juinjang
//
//  Created by 임수진 on 2/8/24.
//

import Foundation
import UIKit

final class ContentWrappingTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
      }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
