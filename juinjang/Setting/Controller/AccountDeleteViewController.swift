//
//  AccountDeleteViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/11/24.
//

import UIKit
import Then
import SnapKit

class AccountDeleteViewController : DimmedViewController {
    var accountDeleteView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    
    var logoImageView = UIImageView().then {
        $0.image = UIImage(named:"로고")
    }
    
    var qLabel = UILabel().then {
        $0.text = "땡땡님, \n정말 계정을 삭제하시겠어요?"
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "600")
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    var label0 = UILabel().then {
        $0.text = "계정을 없애면 임장노트의 내용은 복구할 수 없게 돼요. \n지금 취소하면 아래의 혜택을 계속 누릴 수 있어요."
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    
    let list1 = ["입력한 정보를 기반으로 계산된 점수 확인하기","내 매물 정보 리포트로 한눈에 보기", "리포트 비교하고 공유하기"]
    let list2 = ["대화 녹음하고 매물별로 저장하기", "중요한 녹음파일 텍스트로 보기"]
    let list3 = ["내 매물 맞춤형 체크리스트 이용하기"]
    
    let dotLine1 = UIImageView().then {
        $0.image = UIImage(named: "dotLine")
    }
    let dotLine2 = UIImageView().then {
        $0.image = UIImage(named: "dotLine")
    }

    var noButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("취소하고 돌아갈래요", for: .normal)
        $0.backgroundColor = UIColor(named: "600")
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(no), for: .touchUpInside)
    }
    @objc
    func no(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    var yesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(named: "juinjang")
        $0.setTitle("네,계정을 삭제할게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(tapYesButton), for: .touchUpInside)
    }
    @objc
    func tapYesButton(_ sender: Any) {
        
        switch yesButton.titleLabel?.text {
        case "네,계정을 삭제할게요":
            yesButton.setTitle("계정 삭제하기", for: .normal)
            yesButton.backgroundColor = UIColor(named: "juinjang")
            let vc = AccountDeleteFinalViewController()
            view.insertSubview(vc.view, at: 1)
        default:
            return
        }
    }
    
    func list(listName: [String], num: Int, from: UIImageView, offset: Int) {
        for i in 0...(num-1) {
            var label = UILabel().then {
                let text1 = NSTextAttachment()
                text1.image = UIImage(named: "check")
                let text2 = "    " + listName[i]
                let text3 = NSMutableAttributedString(string: "")
                text3.append(NSAttributedString(attachment: text1))
                text3.append(NSAttributedString(string: text2))
                $0.attributedText = text3
                $0.textColor = UIColor(named: "500")
                $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            accountDeleteView.addSubview(label)
            label.snp.makeConstraints{
                $0.top.equalTo(from.snp.bottom).offset(offset+39*i)
                $0.left.equalToSuperview().offset(24)
            }
        }
    }

    func setConstraint() {
        accountDeleteView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        logoImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(33)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(49)
            $0.height.equalTo(51)
        }
        qLabel.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(31)
            $0.left.equalToSuperview().offset(24)
        }
        
        label0.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(114)
            $0.left.equalToSuperview().offset(24)
        }
        
        dotLine1.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(318)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        dotLine2.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(414)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        noButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(93)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        yesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountDeleteView)
        accountDeleteView.addSubview(logoImageView)
        accountDeleteView.addSubview(qLabel)
        accountDeleteView.addSubview(label0)
        list(listName: list1, num: 3, from: logoImageView, offset: 201)
        accountDeleteView.addSubview(dotLine1)
        list(listName: list2, num: 2, from: dotLine1, offset: 16)
        accountDeleteView.addSubview(dotLine2)
        list(listName: list3, num: 1, from: dotLine2, offset: 16)
        accountDeleteView.addSubview(noButton)
        view.insertSubview(noButton, at: 2)
        accountDeleteView.addSubview(yesButton)
        view.insertSubview(yesButton, at: 2)
        setConstraint()
    }
}

