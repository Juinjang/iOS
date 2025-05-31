//
//  ImjangListHeader.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SnapKit
import Then

final class ImjangListHeader: UICollectionReusableView {
    let filterBackgroundView = UIView().then {
        $0.backgroundColor = .mainWhite
    }
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.baseBackgroundColor = .mainWhite
        configuration.baseForegroundColor = .gray450
        configuration.image = UIImage.ImjangList.arrowDown
        configuration.image?.withTintColor(.gray450)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    let deleteButton = UIButton()
    let shareButton = UIButton()
    let chatBubbleView = ChatBubbleView(text: "나의 임장을 공유할 수 있어요!")
    var menuChildren: [UIMenuElement] = []
    let filterList = Filter.allCases
    weak var sendFilterItemDelegate: SendFilterItemDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        setFilterData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Cell
extension ImjangListHeader {
    
    private func callRequestFiltered(filterItem: Filter) {
        sendFilterItemDelegate?.sendFilterItem(filter: filterItem)
    }
    
    private func changefilterTitle(_ title: String) {
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        filterselectBtn.configuration?.title = title
        filterselectBtn.configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
}

// MARK: - Configure UI
extension ImjangListHeader {
    // MARK: - Set Data
    private func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: {  (action: UIAction) in
                self.changefilterTitle(filter.title)
                self.callRequestFiltered(filterItem: filter)
            }))
        }
        if #available(iOS 17.0, *) {
            filterselectBtn.menu = UIMenu(options: .displayAsPalette, preferredElementSize: .small ,children: menuChildren)
        } else if #available(iOS 16.0, *){
            filterselectBtn.menu = UIMenu(options: .displayInline, preferredElementSize: .small ,children: menuChildren)
        } else {
            filterselectBtn.menu = UIMenu(options: .destructive, children: menuChildren)
        }
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    
    private func configureHierarchy() {
        add(
            filterBackgroundView.with(
                filterselectBtn,
                deleteButton,
                shareButton,
                chatBubbleView
            )
        )
    }
    private func configureLayout() {
        filterBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(49)
        }
        
        filterselectBtn.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(22)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-18)
            $0.size.equalTo(22)
        }
        
        chatBubbleView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(174)
            $0.trailing.equalTo(shareButton.snp.trailing)
            $0.bottom.equalTo(shareButton.snp.top).offset(-2)
        }
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        clipsToBounds = false
        deleteButton.design(image: UIImage.trash, backgroundColor: .clear)
        shareButton.design(image: UIImage.share, backgroundColor: .clear)
        chatBubbleView.isHidden = !(UserDefaultManager.shared.isShowShareAlert ?? true)
        chatBubbleView.onDismiss = { [weak chatBubbleView] in
            UserDefaultManager.shared.isShowShareAlert = false
            chatBubbleView?.isHidden = true
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != nil {
            return view
        }

        let convertedPoint = chatBubbleView.convert(point, from: self)
        if chatBubbleView.bounds.contains(convertedPoint) {
            return chatBubbleView.hitTest(convertedPoint, with: event)
        }

        return nil
    }
}
