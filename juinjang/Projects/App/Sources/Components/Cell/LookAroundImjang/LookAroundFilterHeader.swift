//
//  LookAroundFilterHeader.swift
//  juinjang
//
//  Created by 조유진 on 3/9/25.
//

import UIKit
import RxSwift

final class LookAroundFilterHeader: BaseCollectionReusableView {
    private let lookAroundDropDownView = LookAroundDropDownView()
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        addSubview(lookAroundDropDownView)
    }
    
    override func configureLayout() {
        lookAroundDropDownView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        let convertedPoint = lookAroundDropDownView.convert(point, from: self)
        if let hitView = lookAroundDropDownView.hitTest(convertedPoint, with: event) {
            return hitView
        }
    
        return nil
    }
}
