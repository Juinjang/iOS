//
//  SelectedAreaView.swift
//  juinjang
//
//  Created by 조유진 on 7/6/25.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

final class SelectedAreaView: BaseView {
    private let selectedCountLabel = DSLabel(.body2).then {
        $0.fontColor = .main
    }
    
    private let totalCountLabel = DSLabel(.body2).then {
        $0.text = "/3"
        $0.fontColor = .gray400
    }
    
    private let resetButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            "초기화",
            attributes: AttributeContainer([
                .font: UIFont.pretendard(size: 14, weight: .medium),
                .foregroundColor: UIColor.gray400
            ])
        )
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.configuration = config
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }
    
    private let stackView = UIStackView().then {
        $0.design(alignment: .fill, distribution: .fill, spacing: 12)
    }
    
    private let bottomBorder = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    let resetTapRelay = PublishRelay<Void>()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        resetButton.rx.throttleTap
            .subscribe(with: self) { owner, _ in
                owner.resetTapRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    func configureSelectedList(itemList: Set<DongCellItem>) {
        stackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        itemList.forEach { item in
            let label = makeLabel(title: item.name)
            stackView.addArrangedSubview(label)
        }
        
        selectedCountLabel.text = "\(itemList.count)"
    }
    
    private func makeLabel(title: String) -> UILabel {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6))
        label.font = .pretendard(size: 14, weight: .medium)
        label.text = title
        label.textColor = .main
        label.backgroundColor = .main100
        
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            selectedCountLabel,
            totalCountLabel,
            resetButton,
            scrollView,
            bottomBorder
        )
        
        scrollView.add(stackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        selectedCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedCountLabel.snp.top)
            make.leading.equalTo(selectedCountLabel.snp.trailing)
            make.height.equalTo(20)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(selectedCountLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(28)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            make.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.08
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false

        let shadowHeight: CGFloat = layer.shadowRadius
        let pathRect = CGRect(x: 0,
                              y: -shadowHeight / 2,
                              width: bounds.width,
                              height: shadowHeight)
        layer.shadowPath = UIBezierPath(rect: pathRect).cgPath
    }
}
