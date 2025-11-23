//
//  ShareWriteBuildingCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//


import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class ShareWriteBuildingCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.text = "건물명"
        $0.fontAlignment = .left
    }
    
    private let subTitleLabel = DSLabel(.reguler).then {
        $0.fontSize = 12
        $0.fontColor = .main
        $0.text = "*공유할 임장노트 제목으로 쓰여요!"
    }
    
    private let contentTextFieldBaseView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.layer.borderWidth = 1.5
    }
    
    private let contentTextField = UITextField().then {
        $0.textColor = .gray500
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.placeholder = "건물명을 18자 이내로 작성해주세요 *예시: 주인장A 1차"
        $0.textAlignment = .left
        $0.inputAccessoryView = UIView()
        $0.returnKeyType = .done
    }
    
    private var disposeBag = DisposeBag()
    
    func bind(relay: PublishRelay<String>) {
        contentTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        contentTextField.rx.text.orEmpty
            .map { String($0.prefix(18)) }
            .bind(to: contentTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(titleLabel,
                        subTitleLabel,
                        contentTextFieldBaseView.with(contentTextField))
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalTo(titleLabel.snp.right).offset(4)
        }
        
        contentTextFieldBaseView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(47)
        }
        
        contentTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}
