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
    
    private lazy var textField: UITextField = {
        return UITextField().then {
            $0.layer.cornerRadius = 15
            $0.textColor = .main
            $0.keyboardType = .numberPad
            $0.font = UIFont.pretendard(size: 24, weight: .semiBold)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
            $0.rightViewMode = .always
            $0.leftViewMode = .always
            $0.textAlignment = .center
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: placeholderTextColor,
                    .font: UIFont.pretendard(size: 24, weight: .medium)
                ]
            )
            $0.layer.backgroundColor = textFieldBackgroundColor
        }
    }()
    
    private let placeholder: String
    private let placeholderTextColor: UIColor
    private let textFieldBackgroundColor: CGColor
    
    private let priceUnitLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
    }
    
    var text: String? {
        get { textField.text }
        set {
            if let newValue = newValue, !newValue.isEmpty {
                textField.attributedPlaceholder = nil
            }
            textField.text = newValue
        }
    }
    
    weak var delegate: UITextFieldDelegate? {
        get { textField.delegate ?? nil  }
        set { textField.delegate = newValue }
    }
    
    init(unitType: MeasurementUnit,
         placeholder: String,
         placeholderTextColor: UIColor = .gray300,
         backgroundColor: UIColor = .gray200) {
        self.placeholder = placeholder
        self.placeholderTextColor = placeholderTextColor
        self.textFieldBackgroundColor = backgroundColor.cgColor
        super.init(frame: .zero)
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
                        string: self.placeholder,
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
