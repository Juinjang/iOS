//
//  ImjangImageView.swift
//  juinjang
//
//  Created by 조유진 on 6/3/24.
//

import UIKit

final class ImjangImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
    }
}

