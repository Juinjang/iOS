//
//  DeleteImjangTableHeaderView.swift
//  juinjang
//
//  Created by 조유진 on 1/31/24.
//

import UIKit

final class DeleteImjangTableHeaderView: UITableViewHeaderFooterView {
    let selectedCountLabel = UILabel()
    let removeAllCheckButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @objc func setEmpty() {
        removeAllCheckButton.isSelected = false
        removeAllCheckButton.setImage(ImageStyle.off, for: .normal)
    }
    
    private func configureHierarchy() {
        contentView.addSubview(selectedCountLabel)
        contentView.addSubview(removeAllCheckButton)
    }
    
    private func configureLayout() {
        selectedCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        
        removeAllCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        selectedCountLabel.design(text: "0개 선택됨",
                                  textColor: .gray400,
                                  font: .pretendard(size: 14, weight: .medium))
        
        removeAllCheckButton.design(image: ImageStyle.off, backgroundColor: .mainWhite)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
