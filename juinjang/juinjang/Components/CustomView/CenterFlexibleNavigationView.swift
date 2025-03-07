//
//  CenterFlexibleNavigationView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/4/25.
//

import UIKit
import SnapKit
import Then

final class CenterFlexibleNavigationView: DefaultNavigationView {
    var centerView: UIView? {
        didSet {
            updateCenterView()
        }
    }
    
    override func configureView() {
        super.configureView()
        self.isTitleHidden = true
    }
    
    private func updateCenterView() {
        guard let centerView = self.centerView else {
            return
        }
        self.view.addSubview(centerView)
        self.updateCenterViewConstraints()
    }
    
    private func updateCenterViewConstraints() {
        guard let centerView = self.centerView else {
            return
        }
        
        centerView.snp.updateConstraints {
            $0.center.equalToSuperview()
        }
    }
}
