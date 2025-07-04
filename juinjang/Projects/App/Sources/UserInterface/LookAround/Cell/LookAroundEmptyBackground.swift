//
//  LookAroundEmptyBackground.swift
//  juinjang
//
//  Created by 조유진 on 6/30/25.
//

import UIKit

final class LookAroundEmptyBackground: BaseCollectionReusableView {
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    
    private let emptyImageView = UIImageView().then {
        $0.image = .emptyCell
        $0.contentMode = .scaleAspectFit
    }
    
    private let messageLabel = DSLabel(.body).then {
        $0.fontColor = .gray400
        $0.text = "아직은 노트가 없어요!"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(stackView)
        [emptyImageView, messageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.width.equalTo(216)
            make.height.equalTo(154)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
