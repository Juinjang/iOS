//
//  ExpandedScoreTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit

final class ExpandedScoreTableViewCell: UITableViewCell {
    
    var scoreSelectionHandler: ((String) -> Void)?
    var selectedScore: String?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.CheckList.questionDot
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = .gray500
    }
    
    var scoreButtonStackView = UIStackView()
    
    lazy var answerButton1 = UIButton().then {
        $0.setImage(UIImage.CheckList.answer1, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 1
    }
    
    lazy var answerButton2 = UIButton().then {
        $0.setImage(UIImage.CheckList.answer2, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 2
    }
    
    lazy var answerButton3 = UIButton().then {
        $0.setImage(UIImage.CheckList.answer3, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 3
    }
    
    lazy var answerButton4 = UIButton().then {
        $0.setImage(UIImage.CheckList.answer4, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 4
    }
    
    lazy var answerButton5 = UIButton().then {
        $0.setImage(UIImage.CheckList.answer5, for: .normal)
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
    
    private func setupLayout() {
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
        setupStackView()
    }
    
    private func handleScoreSelection(_ score: String) {
        scoreSelectionHandler?(score)
    }
    
    @objc private  func buttonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        let buttons = [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5]
    
        // 선택한 버튼이 아닌 경우 선택 해제
        for button in buttons {
            if button != sender {
                button.isSelected = false
                DispatchQueue.main.async {
                    button.setImage(UIImage(named: "CheckList/answer\(button.tag)"), for: .normal)
                }
            }
        }

        if sender.isSelected {
            sender.setImage(UIImage.CheckList.checkedButton, for: .normal)
            backgroundColor = .main150
            questionImage.image = UIImage.CheckList.questionSelected
            
            for button in buttons {
                if button != sender {
                    button.isSelected = false
                    DispatchQueue.main.async {
                        button.setImage(UIImage.CheckList.checklistCompletedButton, for: .normal)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "CheckList/answer\(sender.tag)"), for: .normal)
            backgroundColor = .mainWhite
            questionImage.image = UIImage.CheckList.questionDot
        }
        
        // 선택된 버튼의 정보를 저장
        selectedScore = sender.isSelected ? String(sender.tag) : nil
        handleScoreSelection(String(sender.tag))
        
        if let score = selectedScore {
            print("Button Pressed: \(score)")
        } else {
            print("Button Pressed: No answer")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 버튼 초기화
        selectedScore = nil
        
        // 기존 스택 뷰 제거
        scoreButtonStackView.removeFromSuperview()
        
        // 새로운 스택 뷰 생성 및 설정
        scoreButtonStackView = UIStackView()
        setupStackView()
        
        // 배경색 초기화
        backgroundColor = .mainWhite
        questionImage.image = UIImage.CheckList.questionDot
    }
    
    private func setupStackView() {
        scoreButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreButtonStackView.axis = .horizontal
        scoreButtonStackView.spacing = 20
        
        [answerButton1,
         answerButton2,
         answerButton3,
         answerButton4,
         answerButton5].forEach( { scoreButtonStackView.addArrangedSubview($0) } )
        
        addSubview(scoreButtonStackView)
        
        scoreButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(51)
//            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }

    // 보기 모드
    func viewModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = .null
        backgroundColor = .gray100
        
        // 보기 모드 설정
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            button.isEnabled = false
            button.setImage(UIImage.CheckList.savedButton2, for: .normal)
        }
    }
      
    // 수정 모드
    func editModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = .gray500
        backgroundColor = .mainWhite
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            button.isSelected = false
            DispatchQueue.main.async {
                button.setImage(UIImage(named: "CheckList/answer\(button.tag)"), for: .normal)
            }
            
        }
    }
    
    // 보기 모드일 때 저장된 값이 있는 경우
    func savedViewModeConfigure(with score: String, at indexPath: IndexPath) {
        questionImage.image = UIImage.CheckList.questionSelected
        contentLabel.textColor = .gray500
        backgroundColor = .mainWhite
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if String(button.tag) == score {
                button.setImage(UIImage.CheckList.checkedButton, for: .normal)
            } else {
                button.setImage(UIImage.CheckList.savedButton, for: .normal)
            }
        }
    }
    
    // 수정 모드일 때 저장된 값이 있는 경우
    func savedEditModeConfigure(with score: String, at indexPath: IndexPath) {
        questionImage.image = UIImage.CheckList.questionSelected
        contentLabel.textColor = .gray500
        backgroundColor = .main150
        
        let buttons = [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5]
        
        DispatchQueue.main.async {
            for button in buttons {
                if String(button.tag) == score {
                    button.isSelected = true
                    button.setImage(UIImage.CheckList.checkedButton, for: .normal)
                } else {
                    button.isSelected = false
                    button.setImage(UIImage.CheckList.checklistCompletedButton, for: .normal)
                }
            }
        }
    }
}
