//
//  BaseCollectionReusableView.swift
//  juinjang
//
//  Created by 조유진 on 3/9/25.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() { }

    func configureLayout() { }

    func configureView() {
        backgroundColor = .mainWhite
    }
}
