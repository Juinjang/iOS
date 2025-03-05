//
//  NoMaemullPopupViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//

import UIKit
import SnapKit
import Then

final class NoMaemullPopupViewController: BaseViewController {
    private let popupView: NoMaemullPopupView
    
    @objc func btnTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
  
    init(ment: String) {
        self.popupView = NoMaemullPopupView(ment: ment)
        super.init()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
