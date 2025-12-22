//
//  ImjangShareConditionView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/25/25.
//

import UIKit
import SnapKit
import Then
import RxRelay
import RxSwift

enum ImjangNoteShareConditionViewEventType {
    case share
}

final class ImjangNoteShareConditionView: BaseView {
    private let mainTitleLabel = DSLabel(.title).then {
        $0.fontSize = 15
        $0.fontColor = .gray450
        $0.text = "임장노트 공유 조건"
    }
    
    private let secondTitleLabel = DSLabel(.title).then {
        $0.fontSize = 15
        $0.fontColor = .main
    }
    
    private let shareButton = RoundedShareButton()
    
    private let infoButton = UIButton().then {
        $0.setImage(UIImage.infoCircle.withRenderingMode(.alwaysTemplate)
            .withTintColor(.gray450).resized(toWidth: 20), for: .normal)
        $0.backgroundColor = .clear
    }
    
    private let conditionBaseView = UIView().then {
        $0.roundCorners(cornerRadius: 8, corner: .all)
    }
    
    private let conditionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private var disposeBag = DisposeBag()
    let infoButtonDidTapRelay = PublishRelay<Void>()
    
    func configure(model: ShareableConditionDTO,
                   relay: PublishRelay<ImjangNoteShareConditionViewEventType>) {
        disposeBag = DisposeBag()

        if !conditionStackView.subviews.isEmpty {
            conditionStackView.subviews.forEach {
                conditionStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        }
        
        backgroundColor = model.isTotalSatisfied ? .white : .gray200
        layer.borderColor = model.isTotalSatisfied ? UIColor.main.cgColor : UIColor.gray200.cgColor
        secondTitleLabel.text = model.isTotalSatisfied ? "달성" : "미충족"
        secondTitleLabel.fontColor = model.isTotalSatisfied ? .main : .gray500
        conditionBaseView.backgroundColor = model.isTotalSatisfied ? .gray100 : .mainWhite
        shareButton.isHidden = !model.isTotalSatisfied
        infoButton.isHidden = model.isTotalSatisfied
        
        model.conditions.forEach { item in
            conditionStackView.addArrangedSubview(
                ConditionItemView().then { view in
                    view.configure(model: item)
                }
            )
        }
        
        shareButton.rx.throttleTap
            .map { ImjangNoteShareConditionViewEventType.share }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        infoButton.rx.throttleTap
            .subscribe(with: self) { owner, _ in
                owner.infoButtonDidTapRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        super.configureView()
        roundCorners(cornerRadius: 8, corner: .all)
        layer.borderWidth = 1
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(mainTitleLabel,
            secondTitleLabel,
            shareButton,
            infoButton,
            conditionBaseView.with(
                conditionStackView
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(16)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(mainTitleLabel.snp.centerY)
            $0.left.equalTo(mainTitleLabel.snp.right).offset(4)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(68)
            $0.height.equalTo(32)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        conditionBaseView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        conditionStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
