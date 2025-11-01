//
//  BaseAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/2/25.
//

import UIKit
import SnapKit
import Then
import RxRelay
import RxSwift

class BaseAlertView: BaseView {
    private let disposeBag = DisposeBag()
    private let containerView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.roundCorners(cornerRadius: 10, corner: .all)
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    private var containerHeightConstraint: Constraint?
        
    let dismissButton = UIButton().then {
        $0.setImage(.x24.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .gray450
    }
    
    let eventRelay = PublishRelay<AlertEventType>()
    
    override func configureView() {
        backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    override func configureHierarchy() {
        add(
            containerView.with(
                buttonStack,
                dismissButton
            )
        )
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            containerHeightConstraint = $0.height.equalTo(0).constraint
            $0.center.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalToSuperview().offset(14)
            $0.right.equalToSuperview().offset(-12)
        }
    }
}


// MARK: - Setup Views
extension BaseAlertView {
    func setBackgroundDismissEnabled(_ enabled: Bool) {
        if enabled {
            addBackgroundTapGesture()
        }
    }
    
    func setDismissButtonVisible(_ isVisible: Bool) {
        dismissButton.isHidden = !isVisible
    }
    
    func setContainerHeight(_ height: CGFloat) {
        containerHeightConstraint?.deactivate()
        containerView.snp.makeConstraints {
            containerHeightConstraint = $0.height.equalTo(height).constraint
        }
    }
    
    func addContainerSubviews(_ views: [UIView]) {
        containerView.add(views)
    }
    
    func setButtons(with types: [AlertButtonType]) {
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let hasFixedWidth = types.contains {
            switch $0 {
            case .confirm(_, let width, _, _), .cancel(_, let width, _, _):
                return width != nil
            default:
                return false
            }
        }
        
        buttonStack.distribution = hasFixedWidth ? .fill : .fillEqually

        types.forEach {
            buttonStack.addArrangedSubview(createButton(for: $0))
        }
    }
    
    private func createButton(for type: AlertButtonType) -> UIButton {
        let button = UIButton()

        switch type {
        case .confirm(let title, let width, let color, let backgroundColor):
            button.design(title: title,
                          font: .pretendard(size: 16, weight: .semiBold),
                          titleColor: color,
                          backgroundColor: backgroundColor,
                          cornerRadius: 10)
            applyWidthIfNeeded(button, width: width)

        case .cancel(let title, let width, let color, let backgroundColor):
            button.design(title: title,
                          font: .pretendard(size: 16, weight: .semiBold),
                          titleColor: color,
                          backgroundColor: backgroundColor,
                          cornerRadius: 10)
            applyWidthIfNeeded(button, width: width)

        case .custom(let view):
            button.design(backgroundColor: .gray500,
                          cornerRadius: 10)
            button.addSubview(view)
            view.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }

        button.rx.throttleTap
            .map { type.event }
            .bind(to: eventRelay)
            .disposed(by: disposeBag)

        return button
    }

    private func applyWidthIfNeeded(_ button: UIButton,
                                    width: CGFloat?) {
        if let width = width {
            button.snp.makeConstraints {
                $0.width.equalTo(width)
            }
        }
    }
    
    private func addBackgroundTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !containerView.frame.contains(location) {
            eventRelay.accept(.cancel) // or .dismiss if you define it
        }
    }
}
