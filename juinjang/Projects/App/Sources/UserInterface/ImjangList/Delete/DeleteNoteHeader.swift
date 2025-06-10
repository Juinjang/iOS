//
//  DeleteNoteHeader.swift
//  juinjang
//
//  Created by 조유진 on 1/31/24.
//

import UIKit

final class DeleteNoteHeader: UICollectionReusableView {
    let selectedCountLabel = UILabel()
    let removeAllCheckButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @objc func setEmpty() {
        removeAllCheckButton.isSelected = false
        removeAllCheckButton.setImage(UIImage.ImjangList.off, for: .normal)
    }
    
    private func configureHierarchy() {
        addSubview(selectedCountLabel)
        addSubview(removeAllCheckButton)
    }
    
    private func configureLayout() {
        selectedCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        removeAllCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        selectedCountLabel.design(text: "0개 선택됨",
                                  textColor: .gray400,
                                  font: .pretendard(size: 14, weight: .medium))
        
        removeAllCheckButton.design(image: UIImage.ImjangList.off, backgroundColor: .mainWhite)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
