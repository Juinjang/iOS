//
//  ScrapCellBackground.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit

final class ScrapCellBackground: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
