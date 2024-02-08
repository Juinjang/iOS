//
//  UITableView+Extenstion.swift
//  juinjang
//
//  Created by 임수진 on 2/8/24.
//

import Foundation
import UIKit

extension UITableView {
    
    public override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
    
    public override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
}
