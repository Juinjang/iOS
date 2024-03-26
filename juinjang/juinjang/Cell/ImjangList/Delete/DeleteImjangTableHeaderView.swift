//
//  DeleteImjangTableHeaderView.swift
//  juinjang
//
//  Created by 조유진 on 1/31/24.
//

import UIKit

class DeleteImjangTableHeaderView: UITableViewHeaderFooterView {
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
    
    func configureHierarchy() {
        contentView.addSubview(selectedCountLabel)
        contentView.addSubview(removeAllCheckButton)
    }
    
    func configureLayout() {
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
    
    func configureView() {
        contentView.backgroundColor = .white
        selectedCountLabel.design(text: "0개 선택됨",
                                  textColor: ColorStyle.textGray,
                                  font: .pretendard(size: 14, weight: .medium))
        
        removeAllCheckButton.design(image: ImageStyle.off, backgroundColor: ColorStyle.textWhite)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
