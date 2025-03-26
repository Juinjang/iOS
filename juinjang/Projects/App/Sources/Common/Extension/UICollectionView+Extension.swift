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
            forCellWithReuseIdentifier: cellClass.identifier
        )
    }
    
    func register<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        forSupplementaryViewOfKind kind: String
    ) {
        self.register(
            viewClass,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: viewClass.identifier
        )
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellClass.identifier,
            for: indexPath
        )
        
        guard let typedCell = cell as? T else {
            fatalError("❌ Failed to dequeue cell of type \(T.self) with identifier \(cellClass.identifier)")
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
            withReuseIdentifier: viewClass.identifier,
            for: indexPath
        )
        
        guard let typedView = view as? T else {
            fatalError("❌ Failed to dequeue supplementary view of type \(T.self) with identifier \(viewClass.identifier)")
        }
        
        return typedView
    }
}
