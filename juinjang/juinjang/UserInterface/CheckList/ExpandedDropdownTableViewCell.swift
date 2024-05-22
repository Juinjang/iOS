//
//  ExpandedDropdownTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit

// -TODO: 인덱스 구분해서 기타 항목 처리 어떻게 해야할지
class ExpandedDropdownTableViewCell: UITableViewCell {
    
    var optionSelectionHandler: ((String) -> Void)?
    var selectedOption: String?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var itemButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "shadowGray")
        $0.titleLabel?.font = .pretendard(size: 16, weight: .regular)
        $0.addTarget(self, action: #selector(openItemOptions(_:)), for: .touchUpInside)
        $0.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
        $0.layer.cornerRadius = 15
        $0.setTitle("선택안함", for: .normal)
        $0.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        $0.contentHorizontalAlignment = .left
        
        let buttonImage = UIImage(named: "item-arrow-down")
        $0.setImage(buttonImage, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.semanticContentAttribute = .forceRightToLeft
        
        // 여백 설정
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        $0.sizeToFit()
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: $0.bounds.width - 35, bottom: 0, right: -imageInset)
    }
    
    lazy var transparentView = UIView()
    
    lazy var itemPickerView = UIPickerView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
        $0.layer.backgroundColor = UIColor(named: "textWhite")?.cgColor
//        $0.separatorStyle = .none
    }
    
    lazy var etcTextField = UITextField().then {
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
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    var options: [OptionItem] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        itemPickerView.delegate = self
        itemPickerView.dataSource = self
        etcTextField.delegate = self
        [questionImage, contentLabel, itemButton].forEach { contentView.addSubview($0) }
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
        itemPickerView.selectRow(0, inComponent: 0, animated: true)
        itemButton.backgroundColor = UIColor(named: "shadowGray")
        itemButton.setTitle("선택안함", for: .normal)
        itemButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        let buttonImage = UIImage(named: "item-arrow-down")
        itemButton.setImage(buttonImage, for: .normal)
        itemButton.semanticContentAttribute = .forceRightToLeft
        // 여백 설정
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        itemButton.sizeToFit()
        itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: itemButton.bounds.width - 35, bottom: 0, right: -imageInset)
        
        // 배경색 초기화
        backgroundColor = .white
        questionImage.image = UIImage(named: "question-image")
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
        
        // 답변 항목 Button
        itemButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(31)
            $0.width.equalTo(116)
        }
    }
    
    func addTransparentView(frames: CGRect) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        // itemButton의 정중앙 좌표 계산
        let itemButtonCenterX = frames.origin.x + frames.width / 2
        let itemButtonCenterY = frames.origin.y + frames.height / 2

        let calculatedHeight = CGFloat(options.count) * 39 + CGFloat(options.count - 1)
        let maxHeight: CGFloat = 235
        let finalHeight = min(calculatedHeight, maxHeight)

        // itemButton을 기준으로 하여 itemPickerView 좌표 계산
        let pickerViewOriginX = itemButtonCenterX - frames.width / 2
        let pickerViewOriginY = itemButtonCenterY - (finalHeight / 2)

        // itemPickerView의 좌표를 window 기준으로 변환
        let pickerViewFrameInWindow = CGRect(x: pickerViewOriginX, y: pickerViewOriginY, width: frames.width, height: finalHeight)
        let pickerViewFrameInWindowConverted = window.convert(pickerViewFrameInWindow, from: self.contentView)

        transparentView.frame = window.frame
        window.addSubview(transparentView)
        window.addSubview(itemPickerView)

        itemPickerView.frame = pickerViewFrameInWindowConverted

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
    }

    @objc func removeTransparentView() {
        transparentView.removeFromSuperview()
        itemPickerView.removeFromSuperview()
        
        // 선택한 옵션이 "기타"일 경우
        if selectedButton.title(for: .normal) == "기타" {
            selectedButton.backgroundColor = UIColor(named: "shadowGray")
            selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
            selectedButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-250)
            }
            
            contentView.addSubview(etcTextField)
            
            etcTextField.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-24) // 오른쪽으로 24만큼 이동
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(218)
            }
        } else {
            etcTextField.removeFromSuperview()
        }
    }

    @objc func openItemOptions(_ sender: UIButton) {
        let selectedOptions = options.map { $0.option }
        dataSource = selectedOptions
        selectedButton = sender
        addTransparentView(frames: sender.frame)
    }
    
    // 보기 모드
    func viewModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "lightGray")
        backgroundColor = UIColor(named: "gray0")
        
        // 보기 모드 설정
        itemButton.isUserInteractionEnabled = false
        itemPickerView.isUserInteractionEnabled = false
    }
      
    // 수정 모드
    func editModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = .white
        
        var optionValues: [OptionItem] = []

        // 지하철 노선도 항목에 대한 이미지 추가
        if questionDto.questionId == 4 || questionDto.questionId == 62 {
            optionValues = questionDto.options.map { optionItem in
                let originalImage = UIImage(data: optionItem.image)
                // 이미지가 리사이즈하여 새로운 이미지로 생성
                if let originalImage = originalImage {
                    let newSize = CGSize(width: 16, height: 16)
                    let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                        originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                    }
                    return OptionItem(image: resizedImage, option: optionItem.option)
                } else {
                    return OptionItem(image: nil, option: optionItem.option)
                }
            }
        } else {
            // 기본값은 nil로 설정
            optionValues = questionDto.options.map { optionItem in
                return OptionItem(image: nil, option: optionItem.option)
            }
        }
        options = optionValues
    }
    
    // 보기 모드일 때 저장된 값이 있는 경우
    func savedViewModeConfigure(with answer: String, with options: [Option], at indexPath: IndexPath) {
        if answer != "0" {
            itemPickerView.selectRow(Int(answer) ?? 0, inComponent: 0, animated: true)
            questionImage.image = UIImage(named: "question-selected-image")
            contentLabel.textColor = UIColor(named: "500")
            backgroundColor = .white
            var originalImage: UIImage?
            if answer.count < 2 {
                itemButton.setTitle(options[Int(answer) ?? 0].option, for: .normal)
            } else {
                if let lastOption = options.last {
                    itemButton.setTitle(lastOption.option, for: .normal)
                    originalImage = UIImage(data: options[Int(answer) ?? 0].image)
                }
            }
            itemButton.backgroundColor = .white
            itemButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
//            let originalImage = UIImage(data: options[Int(answer) ?? 0].image)
            // 이미지가 리사이즈하여 새로운 이미지로 생성
            if let originalImage = originalImage {
                let newSize = CGSize(width: 16, height: 16)
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                }
                itemButton.setImage(resizedImage, for: .normal)
            }
            itemButton.semanticContentAttribute = .forceLeftToRight
            setSavedInset()
        }
        selectedOption = answer
        selectedButton.backgroundColor = .white
    }
    
    // 수정 모드일 때 저장된 값이 있는 경우
    func savedEditModeConfigure(with answer: String, with options: [Option], at indexPath: IndexPath) {
        print("선택형 답변 Index: \(answer)")
        if answer != "0" {
            itemPickerView.selectRow(Int(answer) ?? 0, inComponent: 0, animated: true)
            questionImage.image = UIImage(named: "question-selected-image")
            contentLabel.textColor = UIColor(named: "500")
            backgroundColor = UIColor(named: "lightOrange")
            var originalImage: UIImage?
            // -TODO: 인덱스 어떻게 할 건지
            if answer.count > 2 {
                itemButton.setTitle(options[Int(answer) ?? 0].option, for: .normal)
            } else {
                if let lastOption = options.last {
                    itemButton.setTitle(lastOption.option, for: .normal)
                    originalImage = UIImage(data: options[Int(answer) ?? 0].image)
                }
            }
            itemButton.backgroundColor = .white
            itemButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
            // 이미지가 리사이즈하여 새로운 이미지로 생성
            if let originalImage = originalImage {
                let newSize = CGSize(width: 16, height: 16)
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                }
                itemButton.setImage(resizedImage, for: .normal)
            }
            itemButton.semanticContentAttribute = .forceLeftToRight
            setSavedInset()
        }
        selectedOption = answer
        selectedButton.backgroundColor = .white
    }
    
    func handleOptionSelection(_ optionIndex: String) {
        optionSelectionHandler?(optionIndex)
    }
}

extension ExpandedDropdownTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].option
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        print("Selected option: (row, \(selectedOption))")
        
        // 선택한 옵션으로 selectedButton 설정
        selectedButton.setTitle(selectedOption.option, for: .normal)
        selectedButton.backgroundColor = .white
        selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        selectedButton.setImage((selectedOption.image), for: .normal)
        selectedButton.semanticContentAttribute = .forceLeftToRight
        setSelectedInset()

        // 답변 항목 Button
        selectedButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(31)
            $0.width.equalTo(116)
        }
        
        etcTextField.removeFromSuperview()
        
        // 기본값 설정
        if row == 0 {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            itemButton.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
            setBasicInset()
            handleOptionSelection(String(row))
        } else {
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            
            handleOptionSelection(String(row))
        }
        
        if options[row].option == "기타" {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
        let fontSize: CGFloat = 16
        let leftPadding: CGFloat = 12
        
        pickerView.subviews[1].backgroundColor = .clear // 선택된 항목 회색 바탕으로 표시되지 않게 함

        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }

        let option = options[row]
        label.font = UIFont.pretendard(size: fontSize, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left

        if var image = option.image {
            let selectionImageView = UIImageView()
            selectionImageView.image = image
            selectionImageView.snp.makeConstraints {
                $0.height.equalTo(16)
                $0.width.equalTo(16)
            }
            // 이미지가 있으면 이미지와 텍스트 같이 표시
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = selectionImageView.image

            // 이미지의 bounds를 설정하여 위치 조정
            let yOffset = (label.font.capHeight - image.size.height) / 2
            imageAttachment.bounds = CGRect(x: 0, y: yOffset, width: image.size.width, height: image.size.height)

            let imageString = NSAttributedString(attachment: imageAttachment)

            let mutableAttributedString = NSMutableAttributedString()
            mutableAttributedString.append(imageString)
            mutableAttributedString.append(NSAttributedString(string: " \(option.option)"))

            label.attributedText = mutableAttributedString
        } else {
            // 이미지가 없으면 텍스트만 표시하고 왼쪽 패딩 적용
            label.text = option.option
            label.frame.origin.x = leftPadding
        }
         return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 39
    }
    
    // pickerView에서 항목 선택 시, 여백 설정
    func setSelectedInset() {
        let imageInset: CGFloat = 12.0
        let titleInset: CGFloat = 17.0
        
        selectedButton.sizeToFit()
        
        if let image = selectedButton.image(for: .normal) {
            // 이미지가 있는 경우
            selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: titleInset)
            selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
        } else {
            // 이미지가 없는 경우
            selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        }
    }
    
    func setSavedInset() {
        let imageInset: CGFloat = 12.0
        let titleInset: CGFloat = 17.0
        
        itemButton.sizeToFit()
        
        if let image = itemButton.image(for: .normal) {
            // 이미지가 있는 경우
            itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: titleInset)
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
        } else {
            // 이미지가 없는 경우
            itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        }
    }

    
    // pickerView에서 기본 여백 설정
    func setBasicInset() {
        let buttonImage = UIImage(named: "item-arrow-down")
        selectedButton.setImage(buttonImage, for: .normal)
        selectedButton.contentMode = .scaleAspectFit
        selectedButton.semanticContentAttribute = .forceRightToLeft
        
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        selectedButton.sizeToFit()
        selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: selectedButton.bounds.width - 35, bottom: 0, right: -imageInset)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "경고", message: "최소 2글자 이상 입력해야 합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    }
}

extension ExpandedDropdownTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        // 글자 수 8글자 제한
        guard textField.text!.count < 8 else { return false }
        
        textField.becomeFirstResponder()
        backgroundColor = UIColor(named: "lightOrange")
        questionImage.image = UIImage(named: "question-selected-image")
        textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
        updateTextFieldWidthConstraint(for: textField, constant: 218, shouldRemoveLeadingConstraint: false)
    
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // 텍스트 필드가 비어 있지 않은 경우
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            textField.backgroundColor = .white
            
            // 2글자 미만인 경우
            if text.count < 2 {
                showAlert()
                return
            }
            
            // 입력된 텍스트에 따라 동적으로 너비 조절
            let calculatedWidth = calculateTextFieldWidth(for: text, maxCharacterCount: 8)

            // 텍스트 필드의 너비 및 위치 업데이트
            updateTextFieldWidthConstraint(for: textField, constant: calculatedWidth, shouldRemoveLeadingConstraint: true)
            textField.layoutIfNeeded()
            textField.contentHorizontalAlignment = .left
            handleOptionSelection(text)
        } else {
            // 비어있는 경우 기존 너비로
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
            updateTextFieldWidthConstraint(for: textField, constant: 218, shouldRemoveLeadingConstraint: false)
            handleOptionSelection("")
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
                    $0.trailing.equalToSuperview().offset(-24)
            }
        }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
