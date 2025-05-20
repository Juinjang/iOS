//
//  RoundedPriceTextField.swift
//  juinjang
//
//  Created by KimDongWoo on 5/20/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

enum MeasurementUnit: String {
    case manwon = "만원"
    case eokwon = "억"
    case floor = "층"
    case pyung = "평"
}

final class RoundedPriceTextField: BaseView {
    private let disposeBag = DisposeBag()
    
    private let textField = UITextField().then {
        $0.layer.cornerRadius = 15
        $0.textColor = .main
        $0.keyboardType = .numberPad
        $0.font = UIFont.pretendard(size: 24, weight: .semiBold)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.rightViewMode = .always
        $0.leftViewMode = .always
    }
    
    private var placeholderText: String = ""
    private var placeholderTextColor: UIColor = .gray300
    
    private let priceUnitLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    init(unitType: MeasurementUnit,
         placeHolder: String,
         placeHolderTextColor: UIColor = .gray300,
         backgroundColor: UIColor = .gray200) {
        super.init(frame: .zero)
        self.placeholderText = placeHolder
        self.placeholderTextColor = placeHolderTextColor
        textField.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [
                .foregroundColor: placeHolderTextColor,
                .font: UIFont.pretendard(size: 24, weight: .medium)
            ]
        )
        textField.layer.backgroundColor = backgroundColor.cgColor
        priceUnitLabel.text = unitType.rawValue
        
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(textField, priceUnitLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        textField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        priceUnitLabel.snp.makeConstraints {
            $0.left.equalTo(textField.snp.right).offset(5)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    
    private func bindEvents() {
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.textField.attributedPlaceholder = nil
            })
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if (self.textField.text ?? "").isEmpty {
                    self.textField.attributedPlaceholder = NSAttributedString(
                        string: self.placeholderText,
                        attributes: [
                            .foregroundColor: self.placeholderTextColor,
                            .font: UIFont.pretendard(size: 24, weight: .medium)
                        ]
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}
