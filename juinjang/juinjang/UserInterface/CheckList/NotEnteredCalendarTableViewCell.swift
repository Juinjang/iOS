//
//  NotEnteredCalendarTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 2/1/24.
//

import UIKit

final class NotEnteredCalendarTableViewCell: UITableViewCell {
    
    var date: String?
    var question: CheckListItem?
    
    lazy var moveInDateImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.CheckList.calendar
    }
    
    lazy var moveInDateLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semiBold)
        $0.textColor = .gray500
        $0.text = "입주 가능 날짜"
    }
    
    lazy var moveInDateContentLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
        $0.text = "입력 안함"
    }
    
    lazy var separationLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.CheckList.enabledSeparationLine
    }
    
    lazy var balanceDueImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.CheckList.wallet
    }
    
    lazy var balanceDueLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semiBold)
        $0.textColor = .gray500
        $0.text = "잔금 날짜"
    }
    
    lazy var balanceDueContentLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
        $0.text = "입력 안함"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .gray100
        
        [moveInDateImage,
         moveInDateLabel,
         moveInDateContentLabel,
         separationLine,
         balanceDueImage,
         balanceDueLabel,
         balanceDueContentLabel].forEach { contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // 입주 가능 날짜 imageView
        moveInDateImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }

        // 입주 가능 날짜 Label
        moveInDateLabel.snp.makeConstraints {
            $0.leading.equalTo(moveInDateImage.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }

        // 입주 가능 날짜 상세 Label
        moveInDateContentLabel.snp.makeConstraints {
            $0.leading.equalTo(moveInDateLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }

        // 구분선 imageView
        separationLine.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueImage.snp.leading).offset(-21)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }

        // 잔금 기한 imageView
        balanceDueImage.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }

        // 잔금 기한 날짜 Label
        balanceDueLabel.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueContentLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        // 잔금 기한 날짜 상세 Label
        balanceDueContentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-49)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    // 보기 모드
    func viewModeConfigure(at indexPath: IndexPath) {
        moveInDateLabel.textColor = .gray500
        moveInDateContentLabel.textColor = .gray400
        moveInDateImage.image = UIImage.CheckList.calendar
        moveInDateContentLabel.text = "입력 안함"
        
        balanceDueLabel.textColor = .gray500
        balanceDueContentLabel.textColor = .gray400
        balanceDueImage.image = UIImage.CheckList.wallet
        balanceDueContentLabel.text = "입력 안함"
        
        backgroundColor = .gray100
        separationLine.image = UIImage.CheckList.enabledSeparationLine
        separationLine.snp.updateConstraints {
            $0.trailing.equalTo(balanceDueImage.snp.leading).offset(-21)
        }
    }
    
    // 보기 모드일 때 저장된 값이 있는 경우
    func savedViewModeConfigure(with imjangId: Int, with answer: [(Int, String)], at indexPath: IndexPath) {
        if answer[0].1 != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            if let date = dateFormatter.date(from: answer[0].1) {
                dateFormatter.dateFormat = "yyyy.MM.dd"
                moveInDateContentLabel.text = dateFormatter.string(from: date)
            }
            moveInDateLabel.textColor = .main
            moveInDateContentLabel.textColor = .gray450
            moveInDateImage.image = UIImage.CheckList.deadlineItem
            backgroundColor = .main100
            separationLine.image = UIImage.CheckList.separationLine
            separationLine.snp.updateConstraints {
                $0.trailing.equalTo(balanceDueImage.snp.leading).offset(-10)
            }
        } else if answer[1].1 != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            if let date = dateFormatter.date(from: answer[1].1) {
                dateFormatter.dateFormat = "yyyy.MM.dd"
                balanceDueContentLabel.text = dateFormatter.string(from: date)
            }
            balanceDueLabel.textColor = .main
            balanceDueContentLabel.textColor = .gray450
            balanceDueImage.image = UIImage.CheckList.walletItem
            backgroundColor = .main100
            // 잔금 기한 날짜 상세 Label
            balanceDueContentLabel.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-24)
            }
            separationLine.image = UIImage.CheckList.separationLine
            separationLine.snp.updateConstraints {
                $0.trailing.equalTo(balanceDueImage.snp.leading).offset(-10)
            }
        }
    }
}
