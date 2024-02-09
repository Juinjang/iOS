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

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKShare
import SafariServices

class ReportViewController : UIViewController {
    let templateId = 103560
    var safariViewController : SFSafariViewController?
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
        attrString.addAttribute(.foregroundColor, value: UIColor(named: "juinjang")!, range: range)
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
        totalGradeLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
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
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 리포트"
        
        //let shareButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareBtnTap))
        let backButtonItem = UIBarButtonItem(image: UIImage(named:"leftArrow"), style: .plain, target: self, action: #selector(backBtnTap))
        backButtonItem.tintColor = UIColor(named: "300")
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 네비게이션 아이템에 백 버튼 아이템 설정
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButtonItem
        //self.navigationItem.rightBarButtonItem = shareButtonItem
    }
    func changeItem() {
        self.navigationItem.rightBarButtonItem = .none
    }
    @objc func backBtnTap() {
        navigationController?.popViewController(animated: true)
    }
    @objc func shareBtnTap() {
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        else {
            // 카카오톡 미설치: 웹 공유 사용 권장
            // Custom WebView 또는 디폴트 브라우져 사용 가능
            // 웹 공유 예시 코드
            if let url = ShareApi.shared.makeCustomUrl(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {
                self.safariViewController = SFSafariViewController(url: url)
                self.safariViewController?.modalTransitionStyle = .crossDissolve
                self.safariViewController?.modalPresentationStyle = .overCurrentContext
                self.present(self.safariViewController!, animated: true) {
                    print("웹 present success")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        
        view.backgroundColor = .white
        
        view.addSubview(totalGradeLabel)
        view.addSubview(priceLabel)
        view.addSubview(addressLabel)
        
        addChild(tabViewController)
        view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
        
        setConstraint()
    }
}
