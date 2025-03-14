//
//  UICollectionView+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass?) {
        if let cellClass = cellClass as? UICollectionViewCell.Type {
            self.register(
                cellClass,
                forCellWithReuseIdentifier: cellClass.reuseId
            )
        } else {
            self.register(
                cellClass,
                forCellWithReuseIdentifier: String(describing: cellClass)
            )
        }
    }
    
    func dequeueReusableCell<T>(_ cellClass: T.Type,
                                _ indexPath: IndexPath) -> T? {
        if let cellClass = cellClass as? UICollectionViewCell.Type {
            guard let cell = self.dequeueReusableCell(
                withReuseIdentifier: cellClass.reuseId,
                for: indexPath
            ) as? T else { return nil }
            return cell
        }
        return nil
    }
}

extension UICollectionViewCell {
    static var reuseId: String {
        return NSStringFromClass(self)
    }
}
