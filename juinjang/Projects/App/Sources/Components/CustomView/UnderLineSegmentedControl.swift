//
//  UnderLineSegmentedView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/12/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class UnderLineSegmentedView: BaseView {
    private let disposeBag = DisposeBag()
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray100
    }
    private let underLineView = UIView().then {
        $0.backgroundColor = .gray500
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private var titles: [String]
    private var buttons: [UIButton] = []
    private var horizontalInset: CGFloat
    
    var buttonTapRelay = PublishRelay<Int>()
    
    init(titles: [String],
         horizontalInset: CGFloat = 39,
         initialIndex: Int = 0) {
        self.titles = titles
        self.horizontalInset = horizontalInset
        super.init(frame: .zero)
        self.selectItem(at: initialIndex, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.add([
            self.stackView,
            self.bottomLineView,
            self.underLineView
        ])
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        self.snp.makeConstraints {
            $0.height.equalTo(47)
        }
        
        self.stackView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.bottom.equalToSuperview()
        }
        
        self.bottomLineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        self.setupButtons()
        self.setupInitialUnderlineConstraints()
    }
    
    private func setupInitialUnderlineConstraints() {
        guard let button = self.buttons.first,
              let titleLabel = button.titleLabel else { return }

        self.underLineView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        self.titles.enumerated().forEach { index, title in
            let button = UIButton().then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(.gray300, for: .normal)
                $0.setTitleColor(.gray500, for: .selected)
                $0.titleLabel?.font = .pretendard(size: 14, weight: .semiBold)
                $0.tag = index
                $0.rx.tap
                    .withUnretained(self)
                    .do { (self, _) in
                        self.selectItem(at: index)
                    }
                    .map { _ in index }
                    .bind(to: self.buttonTapRelay)
                    .disposed(by: disposeBag)
            }
            
            self.buttons.append(button)
            self.stackView.addArrangedSubview(button)
            
            button.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.height.equalTo(34)
            }
        }
    }
    
    func selectItem(at index: Int,
                    animated: Bool = true) {
        guard index < buttons.count else { return }
        
        self.updateSelectedButtonState(index: index)
        self.updateUnderlineConstraints(index: index)
        self.applyLayoutUpdate(animated: animated)
    }
    
    private func updateSelectedButtonState(index: Int) {
        self.buttons.enumerated().forEach { idx, button in
            button.isSelected = (idx == index)
        }
    }
    
    private func updateUnderlineConstraints(index: Int) {
        let selectedButton = buttons[index]
        guard let titleLabel = selectedButton.titleLabel else { return }
        
        self.underLineView.snp.remakeConstraints {
            $0.horizontalEdges.equalTo(titleLabel.snp.horizontalEdges)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func applyLayoutUpdate(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}
