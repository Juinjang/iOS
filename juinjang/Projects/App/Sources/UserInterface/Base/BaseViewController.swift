//
//  BaseViewController.swift
//  juinjang
//
//  Created by 조유진 on 5/29/24.
//

import UIKit

class BaseViewController: UIViewController {
    private var loadingView: UIView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
    
    func setLoading(isShow: Bool,
                    isOverlay: Bool = false) {
        DispatchQueue.main.async {
            if isShow {
                guard self.loadingView == nil else { return } // 이미 있으면 중복 추가 방지
                
                let overlay = UIView(frame: self.view.bounds)
                overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                overlay.backgroundColor = isOverlay ? UIColor.black.withAlphaComponent(0.3) : .clear
                overlay.isUserInteractionEnabled = isOverlay
                
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.startAnimating()
                overlay.addSubview(spinner)
                
                NSLayoutConstraint.activate([
                    spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                    spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
                ])
                
                self.view.addSubview(overlay)
                self.view.bringSubviewToFront(overlay)
                
                self.loadingView = overlay
            } else {
                self.loadingView?.removeFromSuperview()
                self.loadingView = nil
            }
        }
    }
}
