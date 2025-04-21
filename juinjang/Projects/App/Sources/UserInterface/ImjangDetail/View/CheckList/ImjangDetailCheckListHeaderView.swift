//
//  ImjangDetailCheckListHeaderView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/16/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxSwift

final class ImjangDetailCheckListHeaderView: BaseCollectionReusableView {
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "체크리스트"
    }
    
    private let oneRoomNoticeLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .mainStroke
        $0.text = "원룸용 체크리스트로 작성됨"
    }
    
    private let segmentedView = UnderLineSegmentedView(titles: [
        "입지여건",
        "공용공간",
        "실내"
    ], horizontalInset: 0)
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private var disposeBag = DisposeBag()
    
    func bind(for relay: PublishRelay<Int>,
              isOneRoom: Bool,
              isBuyer: Bool) {
        disposeBag = DisposeBag()
        segmentedView.buttonTapSelectedRelay
            .bind(to: relay)
            .disposed(by: disposeBag)
        oneRoomNoticeLabel.isHidden = !isOneRoom
        segmentedView.isHidden = !isBuyer
        separatorView.isHidden = !isBuyer
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(titleLabel,
            oneRoomNoticeLabel,
            separatorView,
            segmentedView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        oneRoomNoticeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalTo(titleLabel.snp.left).offset(82)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(segmentedView.snp.bottom).offset(-1)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.left.equalToSuperview().offset(70)
            $0.right.equalToSuperview().inset(92)
            $0.height.equalTo(47)
        }
    }
}
