//
//  SearchKeywordHeaderView.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import SnapKit

class SearchKeywordHeaderView: UITableViewHeaderFooterView {

    let recentKeywordLabel = UILabel()
    let removeAllButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [recentKeywordLabel, removeAllButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .white
        recentKeywordLabel.design(text: "최근 검색어", font: .pretendard(size: 16, weight: .semiBold))
        removeAllButton.design(title: "전체 삭제", font: .pretendard(size: 14, weight: .medium), titleColor: ColorStyle.textGray, backgroundColor: .white)
    }
    
    func setupConstraints() {
        recentKeywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(24)
        }
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
