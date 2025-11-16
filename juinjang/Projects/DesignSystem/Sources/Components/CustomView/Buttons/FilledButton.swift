//
//  FilledButton.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit
import Then
import SnapKit

public final class FilledButton: PaddingButton {
    private let padding = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0)
    private let contentLabel = DSLabel(.title).then {
        $0.fontColor = .mainWhite
    }
    
    public var isActivated: Bool = true {
        didSet {
            isActivated
            ? (backgroundColor = .gray500)
            : (backgroundColor = .null)
        }
    }
    
    public init(title: String) {
        super.init(padding: padding)
        contentLabel.text = title
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        roundCorners(cornerRadius: 10, corner: .all)
        backgroundColor = .gray500
    }
    
    private func configureHierarchy() {
        add(contentLabel)
    }
    
    private func configureLayout() {
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
