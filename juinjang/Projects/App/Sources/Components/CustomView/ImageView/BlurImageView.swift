//
//  BlurImageView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import SnapKit

final class BlurImageView: UIImageView {
    private let blurView = UIVisualEffectView()
    
    var blurStyle: UIBlurEffect.Style = .dark {
        didSet {
            blurView.effect = UIBlurEffect(style: blurStyle)
        }
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        contentMode = .scaleAspectFill
        clipsToBounds = true

        // Add blur view
        addSubview(blurView)
        blurView.effect = UIBlurEffect(style: blurStyle)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
