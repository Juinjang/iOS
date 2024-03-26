//
//  ExpandedTextFieldTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit

protocol TextFieldDelegate: AnyObject {
    func didEnterText(_ text: String)
}

class ExpandedTextFieldTableViewCell: UITableViewCell {
    
    var inputAnswer: String?
    var inputItems: [String: (inputAnswer: String?, isSelected: Bool)] = [:]
    weak var delegate: TextFieldDelegate?
    var categories: [CheckListResponseDto]!
    
    // 입력한 답변을 외부로 전달하는 콜백 클로저
    var inputHandler: ((String) -> Void)?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var answerTextField = UITextField().then {
        $0.layer.cornerRadius = 15
        $0.layer.backgroundColor = UIColor(named: "lightBackgroundOrange")?.cgColor
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "darkGray")
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        answerTextField.delegate = self
        
        [questionImage, contentLabel, answerTextField].forEach { contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // 셀 내용 초기화
        inputAnswer = nil
        answerTextField.text = ""
        
        // 배경색 초기화
        backgroundColor = .white
    }
    
    func setupLayout() {
        // 질문 구분 imageView
        questionImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        // 질문 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(23)
        }
        
        // 답변 TextField
        answerTextField.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(31)
        }
    }
    
    func saveInputAnswer() {
        if let inputAnswer = inputAnswer {
            UserDefaults.standard.set(inputAnswer, forKey: "AnswerKey")
        } else {
            // 선택된 버튼이 nil인 경우 UserDefaults에서 해당 키의 값을 제거
            UserDefaults.standard.removeObject(forKey: "AnswerKey")
        }
    }
    
    func loadInputAnswer() -> String? {
        return UserDefaults.standard.value(forKey: "AnswerKey") as? String
    }
    
    private func updateInputItem(withContent content: String, inputAnswer: String) {
        // 찾으려는 content와 일치하는 inputItem을 찾음
        if let index = inputItems.index(forKey: content) {
            inputItems.updateValue((inputAnswer, true), forKey: content)
            
            // 딕셔너리 확인
            for (content, inputAnswer) in inputItems {
                print("\(content): \(inputAnswer)")
            }
            saveInputAnswer()
        }
    }
    
    func configure(with questionDto: QuestionDto, at indexPath: IndexPath) {
        let content = questionDto.question
        contentLabel.text = content

        // 입력한 내용이 있으면 표시
        if let storedData = inputItems[content] {
            inputAnswer = storedData.inputAnswer
            
            answerTextField.text = inputAnswer

        } else {
            // 선택된 날짜가 없으면 표시 초기화
            inputAnswer = nil
        }
    }
}

extension ExpandedTextFieldTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        // 글자 수 20글자 제한
        guard textField.text!.count < 20 else { return false }
        
        textField.becomeFirstResponder()
        backgroundColor = UIColor(named: "lightOrange")
        questionImage.image = UIImage(named: "question-selected-image")
        textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
        updateTextFieldWidthConstraint(for: textField, constant: 342, shouldRemoveLeadingConstraint: false)
    
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // 텍스트 필드가 비어 있지 않은 경우
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            textField.backgroundColor = .white
            inputAnswer = textField.text ?? ""
            
            // 입력된 텍스트에 따라 동적으로 너비 조절
            let calculatedWidth = calculateTextFieldWidth(for: text, maxCharacterCount: 20)
            let leftPadding = (342 - calculatedWidth) / 2
            
            delegate?.didEnterText(textField.text ?? "")

            // 텍스트 필드의 너비 및 위치 업데이트
            updateTextFieldWidthConstraint(for: textField, constant: calculatedWidth, shouldRemoveLeadingConstraint: true)
            textField.layoutIfNeeded()
            textField.contentHorizontalAlignment = .left
        
            // 외부로 답변 전달
            inputHandler?(inputAnswer ?? String())
            
            // 답변 해당 InputItem에 저장
            updateInputItem(withContent: contentLabel.text ?? "", inputAnswer: inputAnswer ?? "")
        } else {
            // 비어있는 경우 기존 너비로
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
            updateTextFieldWidthConstraint(for: textField, constant: 342, shouldRemoveLeadingConstraint: false)
        }
    }

    func calculateTextFieldWidth(for text: String, maxCharacterCount: Int) -> CGFloat {
        let font = UIFont.pretendard(size: 16, weight: .regular)
        
        // 최대 글자 수에 따라 너비 계산
        let truncatedText = String(text.prefix(maxCharacterCount))
        let size = truncatedText.size(withAttributes: [.font: font])

        let calculatedWidth = size.width + 25
        return calculatedWidth
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat, shouldRemoveLeadingConstraint: Bool) {
        // 텍스트 필드 너비 업데이트
        for constraint in textField.constraints where constraint.firstAttribute == .width {
            constraint.constant = constant
        }
        
        // 좌측 여백 제약 추가하거나 제거하는 조건
        if shouldRemoveLeadingConstraint {
            textField.superview?.constraints.forEach { constraint in
                if constraint.firstAttribute == .leading && constraint.firstItem === textField {
                    constraint.isActive = false
                }
            }
        } else {
            textField.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(24)
            }
        }
    }
}
