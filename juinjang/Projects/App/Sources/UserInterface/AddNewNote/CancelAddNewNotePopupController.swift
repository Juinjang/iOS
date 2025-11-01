//
//  CancelAddNewNotePopupController.swift
//  App
//
//  Created by 조유진 on 10/18/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class CancelAddNewNotePopupController: BaseAlertViewController {
    private let titleLabel = DSLabel(.body).then {
        $0.fontColor = .gray600
        $0.text = "정말 그만두시겠어요?\n임장노트 생성까지 10초면 충분해요!"
        $0.numberOfLines = 2
        $0.fontAlignment = .center
    }
    
    var disposeBag = DisposeBag()
    
    init() {
        super.init(
            height: 234,
            contentViews: [titleLabel],
            buttons: [.confirm(title: "홈으로 가기", color: .gray500, backgroundColor: .gray3), .cancel(title: "계속하기", color: .mainWhite, backgroundColor: .gray500)]
        )
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(68)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
}
