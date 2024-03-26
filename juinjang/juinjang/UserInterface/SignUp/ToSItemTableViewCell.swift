//
//  ToSItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit

class ToSItemTableViewCell: UITableViewCell {
    
    var toSItem: ToSItem?
    var indexPath: IndexPath?
    
    lazy var checkButton = UIButton().then {
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "record-check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    lazy var itemLabel = UILabel().then {
        $0.textColor = UIColor(named: "textBlack")
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.isUserInteractionEnabled = true // 터치 이벤트 활성화
    }
    
    lazy var openContentButton = UIButton().then {
        $0.addTarget(self, action: #selector(openContentButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "document"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [checkButton, itemLabel, openContentButton].forEach { contentView.addSubview($0) }
        setupLayout()
        setItemButton()
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
        // 동의 Button
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(22)
        }
        
        // 동의 사항 항목 Label
        itemLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        // 파일 열기 Button
        openContentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(21)
        }
    }
    
    func setItemButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemLabelTapped))
        itemLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func itemLabelTapped(sender: UITapGestureRecognizer) {
        // 동의하기 버튼을 클릭한 것처럼 처리
        checkButton.sendActions(for: .touchUpInside)
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print("선택")
            sender.setImage(UIImage(named: "record-check-on"), for: .normal)
        } else {
            print("선택 해제")
            sender.setImage(UIImage(named: "record-check-off"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("CheckButtonUnchecked"), object: nil)
        }
        NotificationCenter.default.post(name: NSNotification.Name("CheckButtonChecked"), object: nil)
        
        if sender.isSelected {
            if let parentVC = parentViewController as? ToSViewController {
                parentVC.isEssentialTermsChecked()
            }
        }
    }
    
    @objc func openContentButtonPressed(_ sender: UIButton) {
        let tag = sender.tag
        let selectedDetail = termsOfServiceDetail[tag]
        
        let tosDetailVC = ToSDetailViewController()
        if let parentVC = parentViewController {
            parentVC.navigationController?.pushViewController(tosDetailVC, animated: true)
            tosDetailVC.tag = sender.tag
            tosDetailVC.contentLabel.text = selectedDetail.contentLabel
            tosDetailVC.contentDetailLabel.text = selectedDetail.contentDetailLabel
        }
    }

    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    func configure(with item: ToSItem?, isChecked: Bool) {
        // item이 nil인지 확인하고, nil이면 함수 종료
        guard let toSItem = item else {
            return
        }

        let cleanedContent = toSItem.content.replacingOccurrences(of: "\\", with: "")
        let attributedString = NSMutableAttributedString(string: cleanedContent)

        if let range = cleanedContent.range(of: "(필수)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "mainOrange")!, range: NSRange(range, in: cleanedContent))
        } else if let range = cleanedContent.range(of: "(선택)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "textGray")!, range: NSRange(range, in: cleanedContent))
        }

        itemLabel.attributedText = attributedString
        checkButton.isSelected = isChecked
        let imageName = isChecked ? "record-check-on" : "record-check-off"
        checkButton.setImage(UIImage(named: imageName), for: .normal)
        openContentButton.tag = toSItem.tag
    }
}
