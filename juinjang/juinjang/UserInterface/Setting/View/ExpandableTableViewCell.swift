//
//  ExpandableTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 1/15/24.
//

import UIKit

final class ExpandableTableViewCell: UITableViewCell {
    
    static let id = "ExpandableTableViewCell"
    
    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private let mainStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 8
    }

    private let iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    private let questionLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray500
        $0.setContentHuggingPriority(.init(rawValue: 200), for: .horizontal)
    }

    private let chevronImageView = UIImageView().then {
        $0.image = UIImage.Setting.expandDown.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray450
    }

    private let expandableView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.backgroundColor = .gray100
    }

    private let answerLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.textColor = .gray500
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentView.addSubview(stackView)
        [mainStackView, expandableView].forEach { stackView.addArrangedSubview($0) }
        [iconImageView, questionLabel, chevronImageView].forEach { mainStackView.addArrangedSubview($0) }
        expandableView.addSubview(answerLabel)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 24),
            questionLabel.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 22),
            chevronImageView.widthAnchor.constraint(equalToConstant: 22),
            chevronImageView.heightAnchor.constraint(equalToConstant: 22),
            chevronImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),
            answerLabel.topAnchor.constraint(equalTo: expandableView.topAnchor, constant: 16),
            answerLabel.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 25),
            answerLabel.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -14),
            answerLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -23)
        ])
    }
    
    func set(_ model: Sections) {
        iconImageView.image = UIImage.Setting.questionLogo
            questionLabel.text = model.question
        questionLabel.asColor(targetString: model.highlight, color: .main)
            answerLabel.text = model.answer
            let attrString = NSMutableAttributedString(string: answerLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            answerLabel.attributedText = attrString
            expandableView.isHidden = !model.isOpened
        chevronImageView.image = (model.isOpened ? UIImage.Setting.expandUp : UIImage.Setting.expandDown).withRenderingMode(.alwaysTemplate)
        }
}
