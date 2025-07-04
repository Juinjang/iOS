//
//  SettingEditableFieldView.swift
//  juinjang
//
//  Created by KimDongWoo on 7/4/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

final class SettingEditableFieldView: BaseView {
    enum State {
        case beforeEdit
        case editing
        case editCompleted
        case validationFailed
        case cancel
    }
    
    fileprivate var state: State = .beforeEdit {
        didSet {
            switch self.state {
            case .beforeEdit:
                configureAsBeforeEditMode()
            case .editing:
                configureAsEditingMode()
            case .editCompleted:
                configureAsCompletedMode()
            case .validationFailed:
                configureAsValidationFailed()
            case .cancel:
                configureAsCancelMode()
            }
        }
    }
    
    var text: String = "" {
        didSet {
            self.textField.text = self.text
        }
    }
    
    var saveButtonDidTapRelay = PublishRelay<String>()
    
    private var disposeBag = DisposeBag()
    
    private let titleLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
        $0.fontSize = 14
    }
    
    private let textField = UITextField().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray500
        $0.isEnabled = false
    }
    
    private let editButton = UIButton().then {
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.backgroundColor = .gray450
        $0.setTitle("변경", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.titleLabel?.font = .pretendard(size: 14, weight: .semiBold)
    }
    
    private let bottomLine = UIView().then {
        $0.backgroundColor = .stroke
        $0.isHidden = true
    }
    
    private let warnningIcon = UIImageView().then {
        $0.image = .Setting.warn
        $0.isHidden = true
    }
    
    private let warnningLabel = DSLabel(.body2).then {
        $0.fontSize = 12
        $0.fontColor = .main
        $0.isHidden = true
    }
    
    private let defaultPlaceholder: String
    
    private let editingPlaceholder: String
    
    private let maxTextCount: Int
    
    init(title: String,
         defaultPlaceholder: String,
         editingPlaceholder: String,
         warnningText: String,
         maxTextCount: Int) {
        self.defaultPlaceholder = defaultPlaceholder
        self.editingPlaceholder = editingPlaceholder
        self.maxTextCount = maxTextCount
        super.init(frame: .zero)
        bind()
        titleLabel.text = title
        textField.attributedPlaceholder = NSAttributedString(
            string: defaultPlaceholder,
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont.pretendard(size: 14, weight: .medium)
            ]
        )
        textField.delegate = self
        warnningLabel.text = warnningText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(
            titleLabel,
            textField,
            editButton,
            bottomLine,
            warnningIcon,
            warnningLabel
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.5)
            $0.left.equalToSuperview()
            $0.right.equalTo(editButton.snp.left).offset(-34)
            $0.height.equalTo(20)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.width.equalTo(64)
            $0.height.equalTo(29)
            $0.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(4.5)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalTo(editButton.snp.left).offset(-17)
        }
        
        warnningIcon.snp.makeConstraints {
            $0.top.equalTo(bottomLine.snp.bottom)
            $0.left.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        warnningLabel.snp.makeConstraints {
            $0.centerY.equalTo(warnningIcon.snp.centerY)
            $0.left.equalTo(warnningIcon.snp.right).offset(3)
        }
    }
    
    private func bind() {
        editButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                switch self.state {
                case .beforeEdit:
                    self.state = .editing
                case .editCompleted:
                    self.state = .beforeEdit
                    self.saveButtonDidTapRelay.accept(self.textField.text ?? "")
                default:
                    self.state = .cancel
                }
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - Private Methods
extension SettingEditableFieldView {
    private func configureAsBeforeEditMode() {
        textField.isEnabled = false
        editButton.setTitle("변경", for: .normal)
        editButton.backgroundColor = .gray450
        bottomLine.isHidden = true
        bottomLine.backgroundColor = .stroke
        warnningIcon.isHidden = true
        warnningLabel.isHidden = true
    }
    
    private func configureAsEditingMode() {
        textField.isEnabled = true
        
        if !textField.isEditing {
            textField.becomeFirstResponder()
        }
        
        textField.attributedPlaceholder = NSAttributedString(
            string: editingPlaceholder,
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont.pretendard(size: 14, weight: .medium)
            ]
        )
        editButton.setTitle("취소", for: .normal)
        editButton.backgroundColor = .gray450
        bottomLine.isHidden = false
        bottomLine.backgroundColor = .stroke
        warnningIcon.isHidden = true
        warnningLabel.isHidden = true
    }
    
    private func configureAsCompletedMode() {
        textField.isEnabled = true
        editButton.setTitle("저장", for: .normal)
        editButton.backgroundColor = .main
        bottomLine.isHidden = false
        bottomLine.backgroundColor = .stroke
        warnningIcon.isHidden = true
        warnningLabel.isHidden = true
    }
    
    private func configureAsValidationFailed() {
        textField.isEnabled = true
        editButton.setTitle("취소", for: .normal)
        editButton.backgroundColor = .gray450
        bottomLine.isHidden = false
        bottomLine.backgroundColor = .main
        warnningIcon.isHidden = false
        warnningLabel.isHidden = false
    }
    
    private func configureAsCancelMode() {
        if textField.isEditing {
            textField.resignFirstResponder()
        }
        textField.text = self.text
        textField.attributedPlaceholder = NSAttributedString(
            string: defaultPlaceholder,
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont.pretendard(size: 14, weight: .medium)
            ]
        )
        state = .beforeEdit
    }
}


// MARK: - TextField Delegate Methods
extension SettingEditableFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        state = text == "" ? .editing : .editCompleted
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= (maxTextCount-1)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let updatedText = textField.text ?? ""
        
        switch updatedText.count {
        case 0:
            state = .editing
        case 1..<maxTextCount:
            state = updatedText == text ? .editing : .editCompleted
        default:
            state = .validationFailed
        }
    }
}
