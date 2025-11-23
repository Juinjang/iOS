//
//  ExpandableImageView .swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class ExpandableImageButton: ImageButton {
    fileprivate let expandButton = UIImageView().then {
        $0.image = .ImjangNote.maximize
        $0.tintColor = .mainWhite
    }
    
    var isHiddenExpandButton: Bool = false {
        didSet {
            expandButton.isHidden = isHiddenExpandButton
        }
    }
    
    init() {
        super.init()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentMode = .scaleAspectFill
    }
    
    private func configureHierarchy() {
        add(expandButton)
    }
    
    private func configureLayout() {
        expandButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.right.bottom.equalToSuperview().inset(12)
        }
    }
}
