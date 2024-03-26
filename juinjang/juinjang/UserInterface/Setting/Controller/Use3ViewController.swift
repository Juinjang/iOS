//
//  UseMarketingViewController.swift
//  juinjang
//
//  Created by 박도연 on 3/23/24.
//
import UIKit
import Then
import SnapKit

class Use3ViewController : UIViewController {
    
    var textView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var textLabel = UILabel().then {
        $0.text = "약관에 동의하시면 주인장 관련 정보 및 이벤트 혜택 정보를 알림으로 받으실 수 있습니다. 정보를 받지 않기를 원하신다면, 동의 철회 또는 회원 탈퇴로 가능합니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .left
    }
    
    var useImageView = UIImageView().then {
        $0.image = UIImage(named:"이용약관")
    }
    var arrowImageView = UIImageView().then {
        $0.image = UIImage(named:"Vector")
    }
    var useButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var useLabel = UILabel().then {
        $0.text = "이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    
    var line1 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    var line2 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "마케팅 동의 및 이벤트 수신"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapBackButton))
        closeButtonItem.tintColor = UIColor(named: "300")
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    func setConstraint() {
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(22)
            $0.left.right.equalToSuperview().inset(45)
        }
        
        useImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(24)
        }
        arrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26.25)
            $0.right.equalToSuperview().inset(30)
        }
        useButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }
        useLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(useImageView.snp.right).offset(8)
        }
        line1.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(useButton.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    
    func addTarget(){
        useButton.addTarget(self, action: #selector(use1), for: .touchUpInside)
    }
    
    @objc func tapBackButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    @objc func use1() {
        let vc = Use1ViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(textView)
        textView.addSubview(textLabel)
        
        view.addSubview(useButton)
        useButton.addSubview(useImageView)
        useButton.addSubview(arrowImageView)
        useButton.addSubview(useLabel)
        
        view.addSubview(line1)
        view.addSubview(line2)
        
        setConstraint()
        addTarget()
        designNavigationBar()
    }
}
