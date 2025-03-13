//
//  DropDownView.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class DropDownView<T: LookAroundFilterType & RawRepresentable>: UIView where T.RawValue == String {
    private lazy var filterTitleButton = FilterTitleButton(title: filterList[0].title)
    
    // 펼칠 목록(필터 메뉴)을 쌓아둘 스택뷰
    private let filterSelectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private var filterStackViewContentHeight: CGFloat = 0
    
    private var disposeBag = DisposeBag()
    private var isExpanded = false  // 현재 펼쳐진 상태인지 여부
    let filterActionRelay = PublishRelay<LookAroundFilterActionType>()
    private var filterList: [T]
    
    init(filterList: [T]) {
        self.filterList = filterList
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView()
        setFilterView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind()  {
        filterTitleButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dropDownFilterView()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureHierarchy() {
        addSubview(filterTitleButton)
        addSubview(filterSelectStackView)
    }
    
    private func configureLayout() {
        filterTitleButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.trailing.equalToSuperview()
        }
        filterSelectStackView.snp.makeConstraints { make in
            make.top.equalTo(filterTitleButton.snp.bottom)
            make.horizontalEdges.equalTo(filterTitleButton)
            make.height.equalTo(0)
        }
    }
    
    private func configureView() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateStackViewHeight()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 우선, 기본 hitTest 결과를 확인
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        // DropDownView의 bounds 밖이라도 filterSelectStackView에 터치가 있는지 확인
        let convertedPoint = filterSelectStackView.convert(point, from: self)
        if let hitView = filterSelectStackView.hitTest(convertedPoint, with: event) {
            return hitView
        }
        return nil
    }
    
    func calculateStackViewHeight() {
        guard filterStackViewContentHeight == 0 else { return }
        var totalHeight: CGFloat = 0
        
        let maxIndex = filterList.indices.max { filterList[$0].title.count < filterList[$1].title.count }
        for (index,subview) in filterSelectStackView.arrangedSubviews.enumerated() {
            if index == maxIndex {
                let maxWidth = subview.intrinsicContentSize.width > filterTitleButton.intrinsicContentSize.width ? subview.intrinsicContentSize.width : filterTitleButton.intrinsicContentSize.width
                filterTitleButton.snp.updateConstraints { make in
                    make.width.equalTo(maxWidth)
                }
            }
            totalHeight += subview.intrinsicContentSize.height
        }
        
        filterStackViewContentHeight = totalHeight
    }
    
    private func dropDownFilterView() {
        isExpanded.toggle()
        isExpanded ? expandDropDown() : hideDropDown()
    }
    
    private func expandDropDown() {
        filterTitleButton.roundCorners(cornerRadius: 0, corner: .bottom)
        filterTitleButton.roundCorners(cornerRadius: 10, corner: .top)
        
        filterSelectStackView.snp.updateConstraints { make in
            make.height.equalTo(filterStackViewContentHeight)
        }
        
        self.filterSelectStackView.subviews.forEach {
            let button = $0 as! FilterButton
            button.titleLabel?.alpha = 1
        }

        // 화살표 아래 방향으로 회전
        UIView.animate(withDuration: 0.18) {
            self.filterTitleButton.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
            self.layoutIfNeeded()
        }
    }
    
    private func hideDropDown() {
        filterSelectStackView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        filterSelectStackView.subviews.forEach  {
            let button = $0 as! FilterButton
            button.titleLabel?.alpha = 0
        }
        
        UIView.animate(withDuration: 0.18) {
            self.filterTitleButton.imageView?.transform = .identity
            self.layoutIfNeeded()
        } completion: { _ in
            self.filterTitleButton.roundCorners(cornerRadius: 10, corner: .all)
            self.layoutIfNeeded()
        }
    }
    
    private func setFilterView() {
        // 필터 목록 생성
        filterSelectStackView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, filter) in filterList.enumerated() {
            let button = FilterButton(filterType: filter)
            
            if index == 0 {
                button.updateColor(isSelected: true)
            }
            
            // 마지막 버튼만 하단 모서리를 둥글게
            if index == filterList.count - 1 { button.roundCorners(cornerRadius: 10, corner: .bottom) }
            
            button.rx.tap
                .withUnretained(self)
                .subscribe { owner, _ in
                    owner.hideDropDown()
                    owner.clearButtonSelectedColor()
                    button.updateColor(isSelected: true)
                    owner.filterTitleButton.updateTitle(title: filter.title)
                    owner.filterActionRelay.accept(filter.action)
                }
                .disposed(by: disposeBag)
            filterSelectStackView.addArrangedSubview(button)
        }
    }
    
    private func clearButtonSelectedColor() {
        filterSelectStackView.subviews.forEach { button in
            let button = button as! FilterButton
            button.updateColor(isSelected: false)
        }
    }
}
