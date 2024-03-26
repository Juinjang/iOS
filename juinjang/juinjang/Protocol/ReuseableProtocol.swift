//
//  ReuseableProtocol.swift
//  juinjang
//
//  Created by 조유진 on 1/25/24.
//

import UIKit

protocol ReuseableProtocol {
    static var identifier: String { get }
}


extension UITableViewCell: ReuseableProtocol {
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionViewCell: ReuseableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReuseableProtocol {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ReuseableProtocol {
    static var identifier: String {
        String(describing: self)
    }
}

//extension UICollectionReusableView: ReuseableProtocol {
//    static var identifier: String {
//        String(describing: self)
//    }
//}
