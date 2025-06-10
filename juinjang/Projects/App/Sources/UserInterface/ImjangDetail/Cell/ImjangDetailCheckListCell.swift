//
//  ImjangDetailCheckListCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

import UIKit
import Then
import SnapKit

final class ImjangDetailCheckListCell: BaseCollectionViewCell {
    private let questionLabel = DSLabel(.reguler).then {
        $0.fontSize = 16
        $0.fontColor = .gray500
    }
    
    private let checkAnswerView = CheckAnswerView()
    
    private let subwayAnswerView = SubwayAnswerView()
    
    private let textAnswerView = TextAnswerView()
    
    func bind(_ model: ImjangDetailCheckListModel,
              isOneRoom: Bool,
              isBuyer: Bool) {
        let dataSource = isBuyer ? (isOneRoom ? oneRoomItems : items) : items
        guard let item = dataSource.first(where: {
            $0.questionId == model.questionId &&
            $0.category == CheckListCategoryType.from(raw: model.category)
        }) else { return }
        
        questionLabel.text = item.question
        
        [subwayAnswerView,
         textAnswerView,
         checkAnswerView].forEach { $0.isHidden = true }

        switch model.answerType {
        case "SCORE":
            checkAnswerView.isHidden = false
            checkAnswerView.configure(for: model.answer)
        default:
            if let item = options1.first(where: { $0.option == model.answer }) {
                subwayAnswerView.isHidden = false
                subwayAnswerView.configure(for: item)
            } else {
                textAnswerView.isHidden = false
                textAnswerView.configure(for: model.answer)
            }
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(questionLabel,
                        checkAnswerView,
                        subwayAnswerView,
                        textAnswerView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        checkAnswerView.snp.makeConstraints {
            $0.height.equalTo(31)
            $0.width.equalTo(235)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        subwayAnswerView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(31)
            $0.width.equalTo(116)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        textAnswerView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(31)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
