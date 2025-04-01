//
//  SeeMoreReusableCell.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MoreButtonReusableCell: BaseCollectionReusableView {
    fileprivate let moreButton: PaddingButton = {
        let button: PaddingButton = .init(
            padding: UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        )
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .gray100
        configuration.title = "더보기"
        configuration.baseForegroundColor = .gray450
        configuration.image = .ImjangList.arrowDown
        configuration.imagePlacement = .trailing
        button.configuration = configuration
        return button
    }()

    override func configureHierarchy() {
        addSubview(moreButton)
    }
    
    override func configureLayout() {
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
    }
}
