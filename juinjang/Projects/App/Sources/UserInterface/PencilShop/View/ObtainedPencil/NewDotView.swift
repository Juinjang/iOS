//
//  NewDotView.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25/25.
//

import UIKit

final class NewDotView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .main
        frame = CGRect(x: 0, y: 0, width: 6, height: 6)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
    }
}
