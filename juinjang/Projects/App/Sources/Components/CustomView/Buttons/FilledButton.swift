//
//  FilledButton.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit

final class FilledButton: PaddingButton {
    private let padding = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0)
    init(title: String) {
        super.init(padding: padding)
        layout(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(title: String) {
        configurationUpdateHandler = { button in
            var config = UIButton.Configuration.filled()
            config.title = title
            config.titleAlignment = .center
            config.baseForegroundColor = .mainWhite
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = button.state.contains(.disabled) ? .mainWhite : .mainWhite
                return outgoing
            }
            
            config.baseBackgroundColor = .gray500
            config.background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
                return button.state.contains(.disabled) ? .null : .gray500
            }
            config.background.cornerRadius = 10
            
            var container = AttributeContainer()
            container.font = .pretendard(size: 16, weight: .semiBold)
            config.attributedTitle = AttributedString(title, attributes: container)
            
            button.configuration = config
        }
    }
}
