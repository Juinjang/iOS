//
//  ExpandedScoreTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit

class ExpandedScoreTableViewCell: UITableViewCell {

    static let identifier = "ExpandedScoreTableViewCell"
    
    var score: String? // 선택된 버튼의 값을 저장할 변수
    var indexPath: IndexPath?
    var item: Item?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var answerButton1 = UIButton().then {
        $0.setImage(UIImage(named: "answer1"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 1
    }
    
    lazy var answerButton2 = UIButton().then {
        $0.setImage(UIImage(named: "answer2"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 2
    }
    
    lazy var answerButton3 = UIButton().then {
        $0.setImage(UIImage(named: "answer3"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 3
    }
    
    lazy var answerButton4 = UIButton().then {
        $0.setImage(UIImage(named: "answer4"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 4
    }
    
    lazy var answerButton5 = UIButton().then {
        $0.setImage(UIImage(named: "answer5"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [questionImage, contentLabel].forEach { contentView.addSubview($0) }
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
        
        // 점수 버튼 Stack View
        let scoreButtonStackView = UIStackView(arrangedSubviews: [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5])
        
        scoreButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreButtonStackView.axis = .horizontal
        scoreButtonStackView.spacing = 20
        
        addSubview(scoreButtonStackView)
        
        scoreButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(51)
//            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // 선택한 버튼이 아닌 경우 선택 해제
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if button != sender {
                button.isSelected = false
                button.setImage(UIImage(named: "answer\(button.tag)"), for: .normal)
            }
        }

        if sender.isSelected {
            // 현재 눌린 버튼을 선택된 상태로 변경
            sender.setImage(UIImage(named: "checked-button"), for: .normal)
            // 셀의 배경색을 변경
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
                if button != sender {
                    button.isSelected = false
                    button.setImage(UIImage(named: "checklist-completed-button"), for: .normal)
                }
            }
        } else {
            sender.setImage(UIImage(named: "answer\(sender.tag)"), for: .normal)
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
        }
        
        // 선택된 버튼의 정보를 저장
        score = String(sender.tag)
        
        if let score = score {
            print("Button Pressed: \(score)")
        } else {
            print("Button Pressed: No answer")
        }
    }
}
