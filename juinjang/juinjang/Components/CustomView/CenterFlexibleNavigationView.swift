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
    var centerView: UIView
    
    init(centerView: UIView) {
        self.centerView = centerView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        self.isTitleHidden = true
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        self.addSubview(centerView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        centerView.snp.updateConstraints {
            $0.center.equalToSuperview()
        }
    }
}
