//
//  NoteEnterPencilShopView.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import UIKit
import RxSwift
import RxRelay
import StoreKit

final class NoteEnterPencilShopView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.title = "연필상점"
        $0.leftItem = [.pop]
    }
    
    private let pencilShopGuideView = PencilShopGuideView(message: "연필이 부족해요:(\n연필을 구매해서 다른 임장노트를 구경해보세요!", spacing: 16)
    private let pencilInfoView = PencilInfoView(infoList: [.necessaryPencil: 0, .pencilYouHave: 0, .notEnoughPencil: 0])
    
    private let pencilItemStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    private let pencilUsageGuideView = PencilUsageGuideView()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    
    let priceTappedRelay = PublishRelay<Product>()
    private var disposeBag = DisposeBag()
    
    func setPencilCount(count: Int) {
        pencilInfoView.setNoteEnterMyPencilCount(pencilCount: count)
    }
    
    func setNeededPencilCount(count: Int) {
        pencilInfoView.setNeededPencilCount(neededPencilCount: count)
    }
    
    func setNotEnoughPencilCount(count: Int) {
        pencilInfoView.setNotEnoughPencilCount(notEnoughPencilCount: count)
    }
    
    func setProductList(_ products: [Product]) {
        pencilItemStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        for product in products {
            let pencilItemView = PencilItemView(product: product)
            pencilItemStackView.addArrangedSubview(pencilItemView)
            pencilItemView.priceTappedRelay
                .subscribe(with: self) { owner, product in
                    owner.priceTappedRelay.accept(product)
                }
                .disposed(by: disposeBag)
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(navigationView, scrollView)
        scrollView.add(contentView)
        
        contentView.add(
            pencilShopGuideView,
            pencilInfoView,
            pencilItemStackView,
            pencilUsageGuideView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        pencilShopGuideView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        pencilInfoView.snp.makeConstraints { make in
            make.top.equalTo(pencilShopGuideView.snp.bottom).offset(40)
            make.height.equalTo(87)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        pencilItemStackView.snp.makeConstraints { make in
            make.top.equalTo(pencilInfoView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        pencilUsageGuideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(pencilItemStackView.snp.bottom).offset(164)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
