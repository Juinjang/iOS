//
//  SearchKeywordHeader.swift
//  juinjang
//
//  Created by 조유진 on 3/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class SearchKeywordHeader: BaseCollectionReusableView {
    private let recentKeywordLabel = UILabel().then {
        $0.setAttribute(text: "최근 검색어", color: .gray600, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 16)
    }
    private let removeAllButton = UIButton().then {
        $0.design(title: "전체 삭제", font: .pretendard(size: 14, weight: .medium), titleColor: .gray400, backgroundColor: .mainWhite)
    }
    
    var disposeBag = DisposeBag()
    
    let removeAllButtonTappedRelay = PublishRelay<Void>()
    
    func configure() {
        removeAllButton.rx.tap
            .bind(to: removeAllButtonTappedRelay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        add(recentKeywordLabel, removeAllButton)
    }
    
    override func configureLayout() {
        recentKeywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(24)
        }
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
