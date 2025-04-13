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

final class ExpandableImageView: BaseView {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    fileprivate let expandButton = ImageButton().then {
        $0.image = .ImjangNote.maximize
        $0.tintColor = .mainWhite
    }
    
    var isHiddenExpandButton: Bool = false {
        didSet {
            expandButton.isHidden = isHiddenExpandButton
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(imageView, expandButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        expandButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.right.bottom.equalToSuperview().inset(12)
        }
    }
}

extension ExpandableImageView {
    func setImage(urlString: String?,
                  placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.imageView.image = placeholder
            return
        }

        self.imageView.kf.setImage(
            with: url,
            placeholder: placeholder
        )
    }
}


extension Reactive where Base: ExpandableImageView {
    var expandTap: ControlEvent<Void> {
        let source = base.expandButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        
        return ControlEvent(events: source)
    }
}
