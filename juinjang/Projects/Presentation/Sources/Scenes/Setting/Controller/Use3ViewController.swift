//
//  UseMarketingViewController.swift
//  juinjang
//
//  Created by 박도연 on 3/23/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class Use3ViewController : BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.title = "마케팅 동의 및 이벤트 수신"
        $0.leftItem = [.pop]
    }
    
    var textView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var textLabel = UILabel().then {
        $0.text = "약관에 동의하시면 주인장 관련 정보 및 이벤트 혜택 정보를 알림으로 받으실 수 있습니다. 정보를 받지 않기를 원하신다면, 동의 철회 또는 회원 탈퇴로 가능합니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .left
    }
    
    var useImageView = UIImageView().then {
        $0.image = UIImage.Setting.documentText
    }
    var arrowImageView = UIImageView().then {
        $0.image = UIImage.Setting.arrowRight
    }
    var useButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var useLabel = UILabel().then {
        $0.text = "이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
    }
    
    var line1 = UIView().then {
        $0.backgroundColor = .gray100
    }
    var line2 = UIView().then {
        $0.backgroundColor = .gray100
    }

    private var disposeBag = DisposeBag()
    
    private func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
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
    
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func use1() {
        let vc = MarketingUseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        
        view.backgroundColor = .mainWhite
        
        view.addSubview(navigationView)
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
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .popButtonTap:
                    owner.tapBackButton()
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
}
