//
//  SelectMaemullHeader.swift
//  juinjang
//
//  Created by 조유진 on 6/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class SelectMaemullHeader: BaseCollectionReusableView {
    let noteFilterDropDownView = DropDownView(filterList: MyNoteFilter.allCases)
    
    var disposeBag = DisposeBag()
    let filterActionRelay = PublishRelay<MyNoteAction>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindAction() {
        noteFilterDropDownView.filterActionRelay
            .bind(with: self) { owner, action in
                owner.filterActionRelay.accept(action as! MyNoteAction)
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(noteFilterDropDownView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        noteFilterDropDownView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != nil {
            return view
        }
        
        let convertedPoint = noteFilterDropDownView.convert(point, from: self)
        if let hitView = noteFilterDropDownView.hitTest(convertedPoint, with: event) {
            return hitView
        }

        return nil
    }
}
