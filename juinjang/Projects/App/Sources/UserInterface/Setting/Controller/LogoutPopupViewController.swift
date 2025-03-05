//
//  LogoutPopupViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

final class LogoutPopupViewController: BaseViewController {
    
    private let popupView: LogoutPopupView
    weak var logoutDelegate: LogoutDelegate?
    
    
    @objc func no(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func yes(_ sender: UIButton) {
        logoutDelegate?.logout()
    }
    
    init(name: String, email: String, ment: String) {
        self.popupView = LogoutPopupView(name: name, email: email, ment: ment)
        super.init()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

