//
//  ImjangListHeader.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit

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
        configuration.image = ImageStyle.arrowDown
        configuration.image?.withTintColor(.gray450)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    
    let deleteButton = UIButton()
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
        addSubview(filterBackgroundView)
        filterBackgroundView.addSubview(filterselectBtn)
        filterBackgroundView.addSubview(deleteButton)
    }
    private func configureLayout() {
        filterBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(49)
        }
        filterselectBtn.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.leading.equalToSuperview().offset(16)
        }
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(22)
        }
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        deleteButton.design(image: ImageStyle.trash, backgroundColor: .clear)
    }
}
