//
//  ChatBubbleView .swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import UIKit
import Then
import SnapKit

public final class ChatBubbleView: BaseView {
    public var onDismiss: (() -> Void)?
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light)).then {
        $0.contentView.backgroundColor = .gray500.withAlphaComponent(0.7)
    }
    
    private let baseView = UIView().then {
        $0.roundCorners(cornerRadius: 4, corner: .all)
    }
    
    private let contentLabel = DSLabel(.reguler).then {
        $0.fontColor = .mainWhite
        $0.fontSize = 12
    }
    
    private let dismissButton = UIButton().then {
        $0.setImage(.x14, for: .normal)
    }
    
    private let polygonView = UIImageView().then {
        $0.image = .polygon
    }
    
    public init(text: String) {
        super.init(frame: .zero)
        contentLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            baseView.with(
                blurView,
                contentLabel,
                dismissButton
            ),
            polygonView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        blurView.snp.makeConstraints {
            $0.edges.equalTo(baseView.snp.edges)
        }
        
        contentLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview().offset(-0.65)
            $0.left.equalToSuperview().offset(8)
        }
        
        dismissButton.snp.makeConstraints {
            $0.left.equalTo(contentLabel.snp.right).offset(8)
            $0.centerY.equalTo(baseView.snp.centerY)
            $0.size.equalTo(14)
        }
        
        polygonView.snp.makeConstraints {
            $0.top.equalTo(baseView.snp.bottom)
            $0.right.equalToSuperview().inset(7.87)
            $0.width.equalTo(8.12)
            $0.height.equalTo(6)
        }
    }
    
    @objc private func didTapDismiss() {
        onDismiss?()
    }
}
