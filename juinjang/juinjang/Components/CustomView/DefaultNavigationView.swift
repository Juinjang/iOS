//
//  DefaultNavigationView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/3/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import RxCocoa

enum NavigationButton {
    case pop
    case search
    case setting
    case record
    
    var image: UIImage {
        switch self {
        case .pop:
            return .arrowLeft
        case .search:
            return .ImjangList.search
        case .setting:
            return .Main.setting
        case .record:
            return .SignUp.microphone
        }
    }
    
    var action: NavigationAction {
        switch self {
        case .pop:
            return .popButtonTap
        case .search:
            return .searchButtonTap
        case .setting:
            return .settingButtonTap
        case .record:
            return .recordButtonTap
        }
    }
}

enum NavigationAction {
    case popButtonTap
    case searchButtonTap
    case searchSummit
    case settingButtonTap
    case recordButtonTap
}

class DefaultNavigationView: UIView {
    var disposeBag = DisposeBag()
    let view = UIView()
    private let titleLabel: UILabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = .gray600
        $0.textAlignment = .center
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            self.titleLabel.textColor = self.titleColor
        }
    }
    
    var isTitleHidden: Bool? {
        didSet {
            self.titleLabel.isHidden = self.isTitleHidden ?? false
        }
    }
    
    let rightItemStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .trailing
        $0.spacing = 16
    }
    
    let leftItemStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 16
    }
    
    var rightItem: [NavigationButton]? {
        didSet {
            self.setupItem(isLeftItem: false)
        }
    }
    
    var leftItem: [NavigationButton]? {
        didSet {
            self.setupItem(isLeftItem: true)
        }
    }
    
    var itemActionRelay = PublishRelay<NavigationAction>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.addSubview(view.with(
            self.titleLabel,
            self.leftItemStackView,
            self.rightItemStackView
        ))
    }
    
    func makeConstraints() {
        self.view.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        self.leftItemStackView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        self.rightItemStackView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func setupItem(isLeftItem: Bool) {
        let stackView = isLeftItem ? self.leftItemStackView : self.rightItemStackView
        let items = isLeftItem ? self.leftItem : self.rightItem
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        items?.forEach { item in
            let button = ImageButton().then {
                $0.image = item.image
                $0.snp.makeConstraints {
                    $0.width.height.equalTo(24)
                }
                $0.rx.tap
                    .withUnretained(self)
                    .subscribe(onNext: { (self, _) in
                        self.itemActionRelay.accept(item.action)
                    })
                    .disposed(by: self.disposeBag)
            }
            stackView.addArrangedSubview(button)
        }
    }
}
