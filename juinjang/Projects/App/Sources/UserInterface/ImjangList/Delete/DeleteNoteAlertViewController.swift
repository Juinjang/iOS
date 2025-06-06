//
//  DeleteNoteAlertViewController.swift
//  juinjang
//
//  Created by 조유진 on 6/6/25.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

final class DeleteNoteAlertViewController: BaseAlertViewController {
    private let roomNameLabel: UILabel = {
        let label = DSLabel(.body)
        label.fontColor = .gray600
        label.fontWeight = .bold
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = DSLabel(.body)
        label.fontColor = .gray600
        label.textAlignment = .center
        
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        
        let attributedString1 = NSMutableAttributedString(string: "  둘러보기에도 1일 이내로 반영돼요!", attributes: [.font: UIFont.pretendard(size: 13, weight: .medium)])
        
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage.ImjangList.warning
        imageAttachment1.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        attributedString1.insert(NSAttributedString(attachment: imageAttachment1), at: 0)
        
        label.attributedText = attributedString1
        label.textColor = .gray450
        label.textAlignment = .center
        
        return label
    }()
    
    private let selectedRoomName: String
    private let selectedCount: Int
    let confirmActionRelay = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    
    init(selectedRoomName: String, selectedCount: Int) {
        self.selectedRoomName = selectedRoomName
        self.selectedCount = selectedCount
        
        super.init(
            height: 218,
            isShowDismissButton: false,
            isBackgroundDismissEnabled: false,
            contentViews: [
                roomNameLabel,
                messageLabel,
                warningLabel
            ],
            buttons: [
                .cancel(title: "아니요"),
                .confirm(title: "삭제하기")
            ]
        )
        configureView()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindAction() {
        eventRelay
            .filter { $0 == .confirm }
            .subscribe(with: self) { owner, _ in
                owner.confirmActionRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        roomNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(23)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(roomNameLabel.snp.bottom)
            make.height.equalTo(23)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(24.5)
        }
    }
    
    private func configureView() {
        roomNameLabel.text = selectedRoomName
        if selectedCount == 1 {
            messageLabel.text = "를 정말 삭제할까요?"
        } else {
            messageLabel.text = "외 \(selectedCount - 1)건을 정말 삭제할까요?"
        }
        messageLabel.asColor(targetString: "외 \(selectedCount - 1)건", color: .main)
        messageLabel.textAlignment = .center
    }
}
