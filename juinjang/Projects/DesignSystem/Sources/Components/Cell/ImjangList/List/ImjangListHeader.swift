//
//  ImjangListHeader.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import CoreCommon

public final class ImjangListHeader: UICollectionReusableView {
    let noteFilterDropDownView = DropDownView(filterList: MyNoteFilter.allCases)
    
    let deleteButton = UIButton()
    let shareButton = UIButton()
    let chatBubbleView = ChatBubbleView(text: "나의 임장을 공유할 수 있어요!")
    var menuChildren: [UIMenuElement] = []
    var disposeBag = DisposeBag()
    
    public let filterActionRelay = PublishRelay<MyNoteAction>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bindAction() {
        noteFilterDropDownView.filterActionRelay
            .bind(with: self) { owner, action in
                owner.filterActionRelay.accept(action as! MyNoteAction)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure UI
extension ImjangListHeader {
    
    private func configureHierarchy() {
        add(
            noteFilterDropDownView,
            deleteButton,
            shareButton,
            chatBubbleView
        )
    }
    private func configureLayout() {
        
        noteFilterDropDownView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(22)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-18)
            $0.size.equalTo(22)
        }
        
        chatBubbleView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(174)
            $0.trailing.equalTo(shareButton.snp.trailing)
            $0.bottom.equalTo(shareButton.snp.top).offset(-2)
        }
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        clipsToBounds = false
        deleteButton.design(image: UIImage.trash, backgroundColor: .clear)
        shareButton.design(image: UIImage.share, backgroundColor: .clear)
        chatBubbleView.isHidden = !(UserDefaultManager.shared.isShowShareAlert ?? true)
        chatBubbleView.onDismiss = { [weak chatBubbleView] in
            UserDefaultManager.shared.isShowShareAlert = false
            chatBubbleView?.isHidden = true
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != nil {
            return view
        }

        let convertedPoint = chatBubbleView.convert(point, from: self)
        if chatBubbleView.bounds.contains(convertedPoint) {
            return chatBubbleView.hitTest(convertedPoint, with: event)
        }
        
        let convertedPoint2 = noteFilterDropDownView.convert(point, from: self)
        if let hitView = noteFilterDropDownView.hitTest(convertedPoint2, with: event) {
            return hitView
        }

        return nil
    }
}
