//
//  BaseViewController.swift
//  juinjang
//
//  Created by 조유진 on 5/29/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginVC), name: .refreshTokenExpired, object: nil)
        setSwipe()
    }
    
    private func setSwipe() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeRecognizer.direction = .right
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func showLoginVC(notification: Notification) {
        showAlert(title: "세션이 만료되었습니다", message: "다시 로그인해주세요") { [weak self] in
            guard let self else { return }
            UserDefaultManager.shared.removeUserInfo()
            changeRootView(to: SignUpViewController(), isNav: true)
        }
    }
    
    func showAlert(title: String?, message: String?, actionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            actionHandler?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
