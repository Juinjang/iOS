//
//  ExpandedScoreTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit

protocol ExpandedScoreCellDelegate: AnyObject {
    func buttonTapped(at index: Int)
}

class ExpandedScoreTableViewCell: UITableViewCell {
    
    var score: String? // 선택된 버튼의 값을 저장할 변수
    var scoreItems: [String: (score: String?, isSelected: Bool)] = [:]
    weak var delegate: ExpandedScoreCellDelegate?
    var categories: [CheckListResponseDto]!
    
    // 선택된 점수를 외부로 전달하는 콜백 클로저
    var selectionHandler: ((String) -> Void)?
    
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
        
        // 외부로 선택된 점수 전달
        selectionHandler?(score ?? String())
        
        // 선택된 점수를 해당 ScoreItem에 저장
        updateScoreItem(withContent: contentLabel.text ?? "", score: String(sender.tag))
    }
    
    func saveSelectedScore() {
        print("score:", score)
        if let score = score {
            UserDefaults.standard.set(score, forKey: "SelectedScoreKey")
            print("저장 성공")
        } else {
            // 선택된 버튼이 nil인 경우 UserDefaults에서 해당 키의 값을 제거
            UserDefaults.standard.removeObject(forKey: "SelectedScoreKey")
            print("저장 실패")
        }
    }
    
    func loadSelectedScore() -> String? {
        print("loadSelectedScore 함수 호출")
        if let selectedScore = UserDefaults.standard.value(forKey: "SelectedScoreKey") as? String {
            print("값:", selectedScore)
            return selectedScore
        } else {
            return nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 버튼 초기화
        score = nil
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
                button.isSelected = false
                button.setImage(UIImage(named: "answer\(button.tag)"), for: .normal)
        }
        
        // 배경색 초기화
        backgroundColor = .white
    }
    
    private func updateScoreItem(withContent content: String, score: String) {
        // 찾으려는 content와 일치하는 ScoreItem을 찾음
        if let index = scoreItems.index(forKey: content) {
            scoreItems.updateValue((score, true), forKey: content)
            
            // 딕셔너리 확인
            for (content, score) in scoreItems {
                print("\(content): \(score)")
            }
            saveSelectedScore()
        }
    }
    
    func configure(with questionDto: QuestionDto, at indexPath: IndexPath) {
        let content = questionDto.question
        contentLabel.text = content
        
        // 선택된 날짜가 있으면 표시
        if let storedData = scoreItems[content] {
            score = storedData.score

            for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
                if String(button.tag) == score {
                    button.isSelected = true
                    button.setImage(UIImage(named: "checked-button"), for: .normal)
                } else {
                    button.isSelected = false
                    button.setImage(UIImage(named: "checklist-completed-button"), for: .normal)
                }
            }
        } else {
            // 선택된 날짜가 없으면 표시 초기화
            score = nil
        }
    }
}
