//
//  UICollectionView+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass?) {
        guard let cellClass = cellClass as? UICollectionViewCell.Type else { return }
        self.register(
            cellClass,
            forCellWithReuseIdentifier: cellClass.reuseId
        )
    }
    
    func register<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        forSupplementaryViewOfKind kind: String
    ) {
        self.register(
            viewClass,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: viewClass.reuseId
        )
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellClass.reuseId,
            for: indexPath
        )
        
        guard let typedCell = cell as? T else {
            fatalError("❌ Failed to dequeue cell of type \(T.self) with identifier \(cellClass.reuseId)")
        }
        
        return typedCell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> T {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewClass.reuseId,
            for: indexPath
        )
        
        guard let typedView = view as? T else {
            fatalError("❌ Failed to dequeue supplementary view of type \(T.self) with identifier \(viewClass.reuseId)")
        }
        
        return typedView
    }
}

extension NSObject {
    static var reuseId: String {
        return NSStringFromClass(self)
    }
}
