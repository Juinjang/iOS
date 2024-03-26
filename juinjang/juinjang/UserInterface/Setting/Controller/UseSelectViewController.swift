//
//  UseSelectViewController.swift
//  juinjang
//
//  Created by 박도연 on 3/22/24.
//
import UIKit
import Then
import SnapKit

class UseSelectViewController : UIViewController {
    //요소
    var use1ImageView = UIImageView().then {
        $0.image = UIImage(named:"이용약관")
    }
    var arrow1ImageView = UIImageView().then {
        $0.image = UIImage(named:"Vector")
    }
    var use2ImageView = UIImageView().then {
        $0.image = UIImage(named:"이용약관")
    }
    var arrow2ImageView = UIImageView().then {
        $0.image = UIImage(named:"Vector")
    }
    var use3ImageView = UIImageView().then {
        $0.image = UIImage(named:"이용약관")
    }
    var arrow3ImageView = UIImageView().then {
        $0.image = UIImage(named:"Vector")
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
        $0.textColor = UIColor(named: "500")
    }
    var use2Label = UILabel().then {
        $0.text = "주인장 개인정보처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    var use3Label = UILabel().then {
        $0.text = "마케팅 동의 및 이벤트 수신"
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
    var line3 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    //함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "이용 및 약관"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"X"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = UIColor(named: "300")
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    func setConstraint() {
        use1ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(24)
        }
        arrow1ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26.25)
            $0.right.equalToSuperview().inset(30)
        }
        use2ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(24)
        }
        arrow2ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26.25)
            $0.right.equalToSuperview().inset(30)
        }
        use3ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(24)
        }
        arrow3ImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26.25)
            $0.right.equalToSuperview().inset(30)
        }
        
        use1Button.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(3)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }
        use1Label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(use1ImageView.snp.right).offset(8)
        }
        use2Button.snp.makeConstraints {
            $0.top.equalTo(use1Button.snp.bottom).offset(3)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }
        use2Label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(use1ImageView.snp.right).offset(8)
        }
        use3Button.snp.makeConstraints {
            $0.top.equalTo(use2Button.snp.bottom).offset(3)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }
        use3Label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(use1ImageView.snp.right).offset(8)
        }
        line1.snp.makeConstraints {
            $0.top.equalTo(use1Button.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(use2Button.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        line3.snp.makeConstraints {
            $0.top.equalTo(use3Button.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
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
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func use2() {
        let vc = Use1ViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func use3() {
        let vc = Use3ViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
        addTarget()
        setConstraint()
        designNavigationBar()
    }
}
