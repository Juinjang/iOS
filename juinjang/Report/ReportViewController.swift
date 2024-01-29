//
//  ReportViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/22/24.
//

import UIKit
import Then
import SnapKit



import Tabman
import Pageboy

class ReportViewController : UIViewController {
    //MARK: - 상단
    var backButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"leftArrow"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
    }
    @objc
    func backBtnTap() {
        let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var reportLabel = UILabel().then {
        $0.text = "주인장 리포트"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var shareButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"share"), for: .normal)
    }
    
    //MARK: - 총 평점 멘트, 가격, 주소
    var totalGradeLabel = UILabel().then {
        $0.textColor = UIColor(named: "600")
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        
        let star = NSTextAttachment()
        star.image = UIImage(named: "bigStar")
        let attrString = NSMutableAttributedString(string: "4.5점입니다")
        let range = ("4.5점입니다" as NSString).range(of: "4.5점")
        attrString.addAttribute(.foregroundColor, value: UIColor.juinjang, range: range)
        let text2 = attrString
        let text3 = NSMutableAttributedString(string: "판교푸르지오월드마크의\n총점은 ")
        text3.append(NSAttributedString(attachment: star))
        text3.append(NSAttributedString(attributedString: text2))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        text3.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text3.length))
        $0.attributedText = text3
    }
    var priceLabel = UILabel().then {
        $0.text = "30억 1천만원"
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
    }
    var addressLabel = UILabel().then {
        $0.text = "경기도 성남시 분당구 삼평동 741"
        $0.textColor = UIColor(named: "450")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    //MARK: - 그래프
    let tabViewController = TabViewController()
    
    func setConstraint() {
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }
        reportLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
        }
        shareButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.right.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }
        
        totalGradeLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(74.16)
            $0.left.equalToSuperview().offset(24)
        }
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(totalGradeLabel.snp.bottom).offset(13)
            $0.left.equalToSuperview().offset(24)
        }
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(24)
        }
       
        tabViewController.view.snp.makeConstraints{
            $0.top.equalTo(addressLabel.snp.bottom).offset(33)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(reportLabel)
        view.addSubview(shareButton)
        
        view.addSubview(totalGradeLabel)
        view.addSubview(priceLabel)
        view.addSubview(addressLabel)
        
        addChild(tabViewController)
        view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
        
        setConstraint()
    }
}
