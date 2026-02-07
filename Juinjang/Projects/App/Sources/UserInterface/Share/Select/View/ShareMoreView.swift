//
//  ShareMoreView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/28/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class ShareMoreView: BaseCollectionReusableView {
    private let moreButton = MoreButton()
    private var disposeBag = DisposeBag()
    
    func bind(relay: PublishRelay<Void>, isHidden: Bool) {
        disposeBag = DisposeBag()
        moreButton.rx.throttleTap
            .bind(to: relay)
            .disposed(by: disposeBag)
        self.isHidden = isHidden
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(moreButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
}
