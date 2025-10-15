//
//  TopTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit

final class TopTableViewCell: UITableViewCell {
    static let id = "TopTableViewCell"
    
    private let greetLabel = UILabel().then {
        $0.text = "반가워요, \(UserDefaultManager.shared.nickname)님 \n오늘은 어떤 집으로 가볼까요?"
        $0.numberOfLines = 0
        $0.textColor = .gray600
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let range = ($0.text! as NSString).range(of: UserDefaultManager.shared.nickname)
        attrString.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
        $0.font = .pretendard(size: 24, weight: .bold)
        $0.alpha = 0.0
    }

    let myNoteButton = UIButton().then {
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 10
    }
    private let myNoteLabel = UILabel().then {
        $0.text = "나의 임장노트"
        $0.textColor = .mainWhite
        $0.font = .pretendard(size: 20, weight: .extraBold)
    }
    private let myNoteImageView = UIImageView().then {
        $0.image = UIImage.Main.threeLogo
    }
    
    let newPageButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.background.image = .Main.newPage.resize(newHeight: 136)
        config.background.imageContentMode = .scaleToFill
        config.background.cornerRadius = 10
        $0.configuration = config
    }
    private let newPageLabel = UILabel().then {
        $0.text = "새 페이지 펼치기"
        $0.textColor = .mainWhite
        $0.font = .pretendard(size: 20, weight: .extraBold)
    }
    
    //새 페이지 펼치기
    let lookAroundButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.background.image = .Main.lookAround.resize(newHeight: 136)
        config.background.imageContentMode = .scaleToFill
        config.background.cornerRadius = 10
        $0.configuration = config
    }
    private let lookAroundLabel = UILabel().then {
        $0.text = "임장노트 둘러보기"
        $0.textColor = .gray600
        $0.font = .pretendard(size: 20, weight: .extraBold)
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("TopTableViewCell init")
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNickname() {
        let message = "반가워요, \(UserDefaultManager.shared.nickname)님 \n오늘은 어떤 집으로 가볼까요?"
        greetLabel.text = message
        
        let attrString = NSMutableAttributedString(string: message)
        let range = (message as NSString).range(of: UserDefaultManager.shared.nickname)
        attrString.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        greetLabel.attributedText = attrString
        
        greetLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - 함수 구현
    private func addContentView() {
        contentView.addSubview(greetLabel)
        contentView.addSubview(myNoteButton)
        myNoteButton.addSubview(myNoteLabel)
        myNoteButton.addSubview(myNoteImageView)
        
        contentView.addSubview(newPageButton)
        newPageButton.addSubview(newPageLabel)
        contentView.addSubview(lookAroundButton)
        lookAroundButton.addSubview(lookAroundLabel)
    }
        
    private func autoLayout() {
        //환영멘트
        greetLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(60)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .curveEaseIn, animations: {
            self.greetLabel.alpha = 1.0
        }, completion: nil)
        
        //나의 임장노트
        myNoteButton.snp.makeConstraints{
            $0.top.equalTo(greetLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(99)
        }
        myNoteLabel.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.top).offset(36)
            $0.leading.equalTo(myNoteButton.snp.leading).offset(24)
            $0.width.equalTo(113)
        }
        myNoteImageView.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.top).offset(28)
            $0.trailing.equalTo(myNoteButton.snp.trailing).offset(-28)
        }
        
        
        //새 페이지 구현
        newPageButton.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(contentView.snp.centerX).offset(-4)
            $0.height.equalTo(136)
        }
    
        newPageLabel.snp.makeConstraints{
            $0.bottom.equalTo(newPageButton.snp.bottom).offset(-14)
            $0.centerX.equalToSuperview().offset(-4)
        }
        
        lookAroundButton.snp.makeConstraints { make in
            make.top.equalTo(newPageButton.snp.top)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(contentView.snp.centerX).offset(4)
            make.height.equalTo(136)
        }
        
        lookAroundLabel.snp.makeConstraints{
            $0.bottom.equalTo(lookAroundButton.snp.bottom).offset(-14)
            $0.centerX.equalToSuperview().offset(-4)
        }
    }
}
