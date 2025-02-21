//
//  ScrapCellEmptyBackground.swift
//  juinjang
//
//  Created by 조유진 on 11/18/24.
//

import UIKit
import SnapKit

final class ScrapCellEmptyBackground: UICollectionReusableView {
    private let backgroundView = UIView()
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        let attributedString1 = NSMutableAttributedString(string: "  버튼을 누르면 상단에 고정할 수 있어요", attributes: [.font: UIFont.pretendard(size: 16, weight: .medium)])
        
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = ImageStyle.bookmark
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 16, height: 18.4)
        
        attributedString1.insert(NSAttributedString(attachment: imageAttachment1), at: 0)
        
        label.attributedText = attributedString1
        label.textColor = .gray400
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("ScrapCellEmptyBackground")
        self.applyGradientBackground()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(messageLabel)
    }
    
    private func configureLayout() {
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
    }
}
