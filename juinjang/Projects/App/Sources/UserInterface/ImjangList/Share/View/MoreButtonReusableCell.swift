//
//  MoreButtonReusableCell.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MoreButtonReusableCell: UICollectionReusableView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
        addSubview(moreButton)
        
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: MoreButtonReusableCell {
    var moreButtonTap: ControlEvent<Void> {
        let source = base.moreButton.rx.tap
        return ControlEvent(events: source)
    }
}
