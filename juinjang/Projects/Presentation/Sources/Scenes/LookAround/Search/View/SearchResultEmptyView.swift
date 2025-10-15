//
//  SearchResultEmptyView.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import SnapKit

final class SearchResultEmptyView: BaseView {
    private let imageView = UIImageView().then {
        $0.design(image: .ImjangList.searchEmpty, contentMode: .scaleAspectFit)
    }
    
    private let messageLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.setAttribute(text: "일치하는 노트가 없어요!\n다른 근처 지역을 검색해볼까요?", color: .gray400, font: .pretendard(size: 16, weight: .medium), lineHeight: 23, alignment: .center)
    }
    
    override func configureHierarchy() {
        add(imageView, messageLabel)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(0.6)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
