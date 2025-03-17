//
//  MyNoteNoticeCell.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import Then
import SnapKit

final class MyNoteNoticeCell: UICollectionViewCell {
    private let baseView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let iconImageView = UIImageView()
    
    private let noticeLabel = UILabel().then {
        $0.textColor = .gray400
        $0.font = .pretendard(size: 14, weight: .medium)
    }
    
    private let closeButton = ImageButton(normalImage: .x24).then {
        $0.tintColor = .gray300
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(category: MyNoteCategoryType) {
        switch category {
        case .share:
            noticeLabel.text = "여기서는 내가 공유한 노트를 볼 수 있어요."
            iconImageView.image = nil
            
            iconImageView.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(0) // 숨기기 (높이는 필요 없음)
                $0.height.equalTo(0)
            }
            
            noticeLabel.snp.remakeConstraints {
                $0.left.equalTo(iconImageView.snp.right)
                $0.centerY.equalToSuperview()
            }
            
        case .own:
            noticeLabel.text = "여기서는 내가 소장한 노트를 볼 수 있어요."
            iconImageView.image = .circlePencil
            
            iconImageView.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(28)
            }
            
        case .like:
            noticeLabel.text = "여기서는 좋아요를 누른 노트를 볼 수 있어요."
            iconImageView.image = .noticeHeart
            
            iconImageView.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(24)
                $0.height.equalTo(20)
            }
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .white
    }
    
    private func configureHierarchy() {
        contentView.add([
            baseView.with(
                iconImageView,
                noticeLabel,
                closeButton
            )
        ])
    }
    
    private func configureLayout() {
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-12)
            $0.size.equalTo(24)
        }
    }
}
