//
//  ImjangNoteDetailInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/25/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class ImjangNoteDetailInfoView: BaseView {
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 22
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 22
    }
    
    private let baseLineView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let disposeBag = DisposeBag()
    
    func configure(model: NoteDetailModel,
                   relay: PublishRelay<Void>) {
        contentStackView.arrangedSubviews.forEach {
            contentStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        contentStackView.addArrangedSubview(
            createContentLabel(text: model.propertyTypeToKorean)
        )
        
        [makeValueView(
            value: model.floor,
            unit: "층",
            relay: relay
        ),
         makeValueView(
            value: String(model.pyong ?? 0),
            unit: "평",
            relay: relay
         )].forEach {
             contentStackView.addArrangedSubview($0)
         }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(titleStackView, contentStackView, baseLineView)
        
        [createTitleLabel(text: "매물유형"),
         createTitleLabel(text: "층수"),
         createTitleLabel(text: "평수")].forEach {
            titleStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(self.snp.centerX).offset(4.5)
        }
        
        baseLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
    }
}

extension ImjangNoteDetailInfoView {
    fileprivate func createTitleLabel(text: String) -> DSLabel {
        return .init(.body).then {
            $0.fontColor = .gray400
            $0.fontAlignment = .left
            $0.text = text
        }
    }
    
    fileprivate func createContentLabel(text: String) -> DSLabel {
        return .init(.body).then {
            $0.fontColor = .gray600
            $0.fontAlignment = .left
            $0.text = text
        }
    }
    
    fileprivate func createTextButton(text: String) -> UIButton {
        return .init().then {
            $0.titleLabel?.font = UIFont.pretendard(size: 16, weight: .medium)
            $0.setTitleColor(.gray300, for: .normal)
            $0.titleLabel?.textAlignment = .left
            $0.setTitle("눌러서 입력하러 가기", for: .normal)
        }
    }
    
    fileprivate func makeValueView(
        value: String?,
        unit: String,
        relay: PublishRelay<Void>
    ) -> UIView {
        if let value,
           !value.isEmpty,
           value != "0" {
            
            return createContentLabel(text: "\(value)\(unit)")
        } else {
            let button = createTextButton(text: "눌러서 입력하러 가기")
            
            button.rx.throttleTap
                .bind(to: relay)
                .disposed(by: disposeBag)
            
            button.snp.makeConstraints {
                $0.height.equalTo(23)
            }
            
            return button
        }
    }
}
