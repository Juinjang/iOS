//
//  DeletePopupViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/17/24.
//

import UIKit
import Then
import SnapKit

class DeletePopupViewController: UIViewController {
    lazy var popupView = UIView().then { // 팝업창 뷰
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var confirmButton = UIButton()
    
    lazy var cancelButton = UIButton()
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    lazy var messageLabel = UILabel().then {
        $0.text = "\n녹음 파일을 정말 삭제할까요?"
        $0.textColor = UIColor(named: "nomalText")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    var fileIndexPath: IndexPath? = nil
    var fileName: String? = nil
    var completionHandler: ((IndexPath) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        addSubview()
        setConstraints()
        designViews()
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
    
    func addSubview() {
        view.addSubview(popupView)
        popupView.addSubview(stackView)
        [cancelButton, confirmButton].forEach {
            stackView.addArrangedSubview($0)
        }
        popupView.addSubview(messageLabel)
    }
    
    func designViews() {
        designButton(cancelButton, title: "아니요", backgroundColor: .white)
        designButton(confirmButton, title: "예", backgroundColor: .black, textColor: .white)
        if let fileName {
            messageLabel.text = "\(fileName).mp3\n녹음 파일을 정말 삭제할까요?"
            messageLabel.font = .pretendard(size: 16, weight: .regular)
            messageLabel.setLineSpacing(spacing: 4)
            messageLabel.textAlignment = .center
            messageLabel.changeFont(targetString: "\(fileName).mp3", font: .pretendard(size: 16, weight: .bold))
        } else {
            messageLabel.text = "녹음 파일을 정말 삭제할까요?"
        }
    }
    
    func setConstraints() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        // 팝업창 위치 설정
        popupView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.height.equalTo(popupView.snp.width).multipliedBy(234.0 / 342.0)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.top.equalTo(popupView.snp.top).offset(65)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
            $0.height.equalTo(52)
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        self.completionHandler?(fileIndexPath!)
        dismiss(animated: false, completion: nil)
    }
    
    func designButton(_ button: UIButton, title: String = "확인", backgroundColor: UIColor = .white, textColor: UIColor = .black) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        
        button.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.lineBreakMode = .byTruncatingTail
    }

}
