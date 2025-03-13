//
//  ShareGuideHeaderCell.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit

final class ShareGuideHeaderCell: UICollectionReusableView {
    private let descriptionLabel1: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.design(
            text: "임장노트 한 개를 선택해주세요!",
            textColor: .gray600,
            font: .pretendard(size: 20, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    private let descriptionLabel2: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.design(
            text: "임장노트는 \"임장 둘러보기\"를 통해\n다른 임장러에게 공유돼요.",
            textColor: .gray400,
            font: .pretendard(size: 14, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return label
    }()
    
    private let pencilContentView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let pencilImageView: UIImageView = {
        let emptyView: UIImageView = .init()
        emptyView.design(
            image: UIImage.DivideImjangNote.pencilCircle,
            contentMode: .scaleAspectFit
        )
        return emptyView
    }()
    
    private let pencilDescriptionLabel: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.textAlignment = .center
        emptyLabel.design(
            text: "임장노트를 공유하면 받을 수 있는 연필",
            textColor: .gray500,
            font: .pretendard(size: 14, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    private let pencilCountLabel: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.textAlignment = .right
        emptyLabel.design(
            text: "0개",
            textColor: .main,
            font: .pretendard(size: 16, weight: .semiBold),
            textAlignment: .center,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        addSubview(descriptionLabel1)
        addSubview(descriptionLabel2)
        addSubview(pencilContentView)
        [pencilImageView, pencilDescriptionLabel, pencilCountLabel].forEach {
            pencilContentView.addSubview($0)
        }
        
        descriptionLabel1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel2.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel1.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        pencilContentView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel2.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        pencilImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(28)
        }
        
        pencilDescriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pencilImageView.snp.trailing).offset(16)
        }
        
        pencilCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(pencilDescriptionLabel.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
