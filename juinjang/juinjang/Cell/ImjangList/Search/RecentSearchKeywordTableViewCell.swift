//
//  RecentSearchKeywordTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit

class RecentSearchKeywordTableViewCell: UITableViewCell {
    let clockIcon = UIImageView()
    let searchKeywordLabel = UILabel()
    let deleteButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        setupConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(keyword: String) {
        searchKeywordLabel.text = keyword
    }
    
    func configureHierarchy() {
        [clockIcon, searchKeywordLabel, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .white
        clockIcon.design(image: ImageStyle.clock, contentMode: .scaleAspectFit)
        searchKeywordLabel.design(text: "", font: .pretendard(size: 16, weight: .medium))
        deleteButton.design(image: ImageStyle.x, backgroundColor: .white)
    }
    
    func setupConstraints() {
        clockIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView).offset(24)
            $0.size.equalTo(16)
        }
        
        searchKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(clockIcon)
            $0.leading.equalTo(clockIcon.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualTo(deleteButton.snp.leading).inset(12)
            $0.height.equalTo(23)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(clockIcon)
            $0.trailing.equalTo(contentView).inset(24)
            $0.size.equalTo(20)
        }
    }

}
