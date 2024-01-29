//
//  ExpandedDropdownTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit
import SwiftyMenu

class ExpandedDropdownTableViewCell: UITableViewCell {
    
    static let identifier = "ExpandedDropdownTableViewCell"
    
    var selectedOption: String?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }

//    private let dropDownOptionsDataSource = [
//        MealSize(id: 1, name: "Small"),
//        MealSize(id: 2, name: "Medium"),
//        MealSize(id: 3, name: "Large"),
//        MealSize(id: 4, name: "Combo Large")
//    ]
//    public enum ArrowStyle {
//        case customStyle(isEnabled: Bool, image: UIImage?)
//        // 나머지 코드...
//    }
//
//    
//    lazy var dropdown = SwiftyMenu().then {
//        $0.layer.cornerRadius = 20
//        $0.backgroundColor = UIColor(named: "lightGray")
//
//        // SwiftyMenu 속성(attributes) 설정
//        let attributes = SwiftyMenuAttributes(
//            arrowStyle: .customStyle(isEnabled: true, image: UIImage(named: "option-expand"))
//            // 다른 속성들을 설정하고,
//        )
//        $0.configure(with: attributes)
//
//        // SwiftyMenu에 데이터 소스(items) 설정
//        $0.items = dropDownOptionsDataSource
//    }
    
    lazy var pickerView = UIPickerView()
    
    var options: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        pickerView.delegate = self
        pickerView.dataSource = self
        [questionImage, contentLabel, pickerView].forEach { contentView.addSubview($0) }
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
        self.backgroundColor = .white
        // Configure the view for the selected state
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
        
        // 답변 PickerView
        pickerView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(50) // 31
            $0.width.equalTo(150) // 116
        }
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
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // 기본값 설정
            if row == 0 {
                backgroundColor = .white
                questionImage.image = UIImage(named: "question-image")
            } else {
                backgroundColor = UIColor(named: "lightOrange")
                questionImage.image = UIImage(named: "question-selected-image")
            }
            
            let selectedOption = options[row]
            print("Selected option: \(selectedOption)")
        }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = options[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 16, weight: .regular),
            .foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }

}

//extension ExpandedDropdownTableViewCell: SwiftyMenuDelegate {
//    
//    // Get selected option from SwiftyMenu
//    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
//        print("Selected item: \(item), at index: \(index)")
//    }
//    
//    // SwiftyMenu drop down menu will expand
//    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu willExpand.")
//    }
//
//    // SwiftyMenu drop down menu did expand
//    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu didExpand.")
//    }
//
//    // SwiftyMenu drop down menu will collapse
//    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu willCollapse.")
//    }
//
//    // SwiftyMenu drop down menu did collapse
//    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu didCollapse.")
//    }
//}
//
//struct MealSize {
//    let id: Int
//    let name: String
//}
//
//extension MealSize: SwiftyMenuDisplayable {
//    public var displayableValue: String {
//        return self.name
//    }
//
//    public var retrievableValue: Any {
//        return self.id
//    }
//}
//
//
//extension String: SwiftyMenuDisplayable {
//    public var retrievableValue: Any {
//        return self
//    }
//    
//    public var displayableValue: String {
//        return self
//    }
//    
//    public var retrivableValue: Any {
//        return self
//    }
//}

//public extension SwiftyMenuAttributes {
//    // 다른 속성들을 설정하는 코드...
//
//    public func configure(with attributes: SwiftyMenuAttributes) {
//        // 다른 속성 설정
//        // ...
//
//        // ArrowStyle 설정
//        let arrowStyleValues = attributes.arrowStyle.arrowStyleValues(defaultImage: defaultImage)
//        // 이후 arrowStyleValues를 사용하여 SwiftyMenu 내부에서 설정하도록 구현
//        // ...
//    }
//}
//
//public extension SwiftyMenuAttributes.ArrowStyle {
//    func arrowStyleValues(defaultImage: UIImage) -> (isEnabled: Bool, image: UIImage?) {
//        switch self {
//        case let .customStyle(isEnabled, image):
//            if isEnabled && image != nil {
//                return (isEnabled: isEnabled, image: image)
//            } else if isEnabled {
//                return (isEnabled: isEnabled, image: defaultImage)
//            } else {
//                return (isEnabled: isEnabled, image: nil)
//            }
//        case .default:
//            return (isEnabled: true, image: defaultImage)
//        }
//    }
//}
