//
//  UseSelectViewController.swift
//  juinjang
//
//  Created by 박도연 on 3/22/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class UseSelectViewController : BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.title = "이용 및 약관"
        $0.leftItem = [.close]
    }
    
    //요소
    var use1ImageView = UIImageView().then {
        $0.image = UIImage.Setting.documentText
    }
    var arrow1ImageView = UIImageView().then {
        $0.image = UIImage.Setting.arrowRight
    }
    var use2ImageView = UIImageView().then {
        $0.image = UIImage.Setting.documentText
    }
    var arrow2ImageView = UIImageView().then {
        $0.image = UIImage.Setting.arrowRight
    }
    var use3ImageView = UIImageView().then {
        $0.image = UIImage.Setting.documentText
    }
    var arrow3ImageView = UIImageView().then {
        $0.image = UIImage.Setting.arrowRight
    }
    
    var use1Button = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var use2Button = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var use3Button = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var use1Label = UILabel().then {
        $0.text = "주인장 이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
    }
    var use2Label = UILabel().then {
        $0.text = "주인장 개인정보 처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
    }
    var use3Label = UILabel().then {
        $0.text = "마케팅 동의 및 이벤트 수신"
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
    var line3 = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private var disposeBag = DisposeBag()
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(use1Button)
        view.addSubview(use2Button)
        view.addSubview(use3Button)
        use1Button.addSubview(use1ImageView)
        use1Button.addSubview(arrow1ImageView)
        use1Button.addSubview(use1Label)
        use2Button.addSubview(use2ImageView)
        use2Button.addSubview(arrow2ImageView)
        use2Button.addSubview(use2Label)
        use3Button.addSubview(use3ImageView)
        use3Button.addSubview(arrow3ImageView)
        use3Button.addSubview(use3Label)
        
        view.addSubview(line1)
        view.addSubview(line2)
        view.addSubview(line3)
    }
    
    private func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        use1ImageView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(24)
        }
        
        use1Button.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        use1Label.snp.makeConstraints {
            $0.centerY.equalTo(use1ImageView)
            $0.leading.equalTo(use1ImageView.snp.trailing).offset(8)
        }
        
        arrow1ImageView.snp.makeConstraints {
            $0.centerY.equalTo(use1ImageView)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        line1.snp.makeConstraints {
            $0.top.equalTo(use1Button.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        use2ImageView.snp.makeConstraints {
            $0.top.equalTo(use1Button.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(24)
        }
        
        arrow2ImageView.snp.makeConstraints {
            $0.centerY.equalTo(use2ImageView)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        use2Button.snp.makeConstraints {
            $0.top.equalTo(use1Button.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        use2Label.snp.makeConstraints {
            $0.centerY.equalTo(use2ImageView)
            $0.leading.equalTo(use2ImageView.snp.trailing).offset(8)
        }
        
        line2.snp.makeConstraints {
            $0.top.equalTo(use2Button.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        use3ImageView.snp.makeConstraints {
            $0.top.equalTo(use2Button.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(24)
        }
        
        arrow3ImageView.snp.makeConstraints {
            $0.centerY.equalTo(use3ImageView)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        use3Button.snp.makeConstraints {
            $0.top.equalTo(use2Button.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        use3Label.snp.makeConstraints {
            $0.centerY.equalTo(use3ImageView)
            $0.leading.equalTo(use3ImageView.snp.trailing).offset(8)
        }
    
        line3.snp.makeConstraints {
            $0.top.equalTo(use3Button.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    
    func addTarget(){
        use1Button.addTarget(self, action: #selector(use1), for: .touchUpInside)
        use2Button.addTarget(self, action: #selector(use2), for: .touchUpInside)
        use3Button.addTarget(self, action: #selector(use3), for: .touchUpInside)
    }
    
    @objc func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    @objc func use1() {
        let vc = Use1ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func use2() {
        let vc = Use2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func use3() {
        let vc = Use3ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        
        bindAction()
        addTarget()
        configureHierarchy()
        setConstraint()
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .closeButtonTap:
                    owner.tapCloseButton()
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
}
