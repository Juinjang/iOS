//
//  BaseAlertViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

enum AlertButtonType: Equatable {
    case confirm(title: String, width: CGFloat?)
    case cancel(title: String, width: CGFloat?)
    case custom(view: UIView)
    
    var title: String {
        switch self {
        case .cancel(title: let title, _):
            return title
        case .confirm(title: let title, _):
            return title
        default: 
            return ""
        }
    }
    
    var event: AlertEventType {
        switch self {
        case .confirm(_,_):
            return .confirm
        case .cancel(_,_):
            return .cancel
        case .custom(_):
            return .confirm
        }
    }
    
    static func confirm(title: String) -> AlertButtonType {
        return .confirm(title: title, width: nil)
    }
    
    static func cancel(title: String) -> AlertButtonType {
        return .cancel(title: title, width: nil)
    }
}

enum AlertEventType {
    case confirm
    case cancel
}

class BaseAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let eventRelay = PublishRelay<AlertEventType>()

    lazy var mainView: BaseAlertView = {
        return BaseAlertView()
    }()
        
    init(height: CGFloat,
         isShowDismissButton: Bool = false,
         isBackgroundDismissEnabled: Bool = false,
         contentViews: [UIView],
         buttons: [AlertButtonType]) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        mainView.setContainerHeight(height)
        mainView.setButtons(with: buttons)
        mainView.addContainerSubviews(contentViews)
        mainView.setDismissButtonVisible(isShowDismissButton)
        mainView.setBackgroundDismissEnabled(isBackgroundDismissEnabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentHierarchy()
        configureContentLayout()
    }
    
    func configureContentHierarchy() {}
    func configureContentLayout() {}
    
    private func bind() {
        mainView
            .dismissButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView
            .eventRelay
            .subscribe(with: self) { (self, event) in
                self.eventRelay.accept(event)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
