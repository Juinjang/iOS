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

final class UnderLineSegmentedView: BaseView, PageUnderLineUpdatable {
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private var titles: [String]
    private var horizontalInset: CGFloat
    private var initialLayoutCount = 0
    
    let underLineView = UIView().then {
        $0.backgroundColor = .gray500
    }
    var buttons: [UIButton] = []
    var previousIndex: Int
    var disposeBag = DisposeBag()
    
    var buttonTapRelay = PublishRelay<Int>()
    
    init(titles: [String],
         horizontalInset: CGFloat = 39,
         initialIndex: Int = 0) {
        self.titles = titles
        self.horizontalInset = horizontalInset
        self.previousIndex = initialIndex
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialLayoutCount += 1
        
        if initialLayoutCount == 2 {
            setupInitialUnderlineFrame()
        }
    }
    
    private func setupInitialUnderlineFrame() {
        guard let button = buttons.first,
              let titleLabel = button.titleLabel else { return }

        titleLabel.layoutIfNeeded()

        let frame = titleLabel.convert(titleLabel.bounds, to: self)
        let y = stackView.frame.maxY - 1

        underLineView.frame = CGRect(
            x: frame.minX,
            y: y,
            width: frame.width,
            height: 1
        )
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
                        self.isSegmentTapTriggered = true
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
    
    //
    // MARK: Tap Item
    //
    func selectItem(at index: Int,
                    animated: Bool = true) {
        guard index < buttons.count else { return }
        
        self.updateSelectedButtonState(index: index)
        self.updateUnderlineFrame(index: index, animated: animated)
    }
    
    private func updateUnderlineFrame(index: Int,
                                      animated: Bool) {
        guard let selectedLabel = buttons[index].titleLabel else { return }

        selectedLabel.layoutIfNeeded()

        let frame = selectedLabel.convert(selectedLabel.bounds, to: self)
        let centerX = frame.midX
        let width = frame.width
        
        applyLayoutUpdate(animated: animated) {
            self.underLineView.bounds.size.width = width
            self.underLineView.center.x = centerX
        }
    }
    
    private func applyLayoutUpdate(animated: Bool,
                                   _ updates: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                updates()
            }
        } else {
            updates()
        }
    }
}

