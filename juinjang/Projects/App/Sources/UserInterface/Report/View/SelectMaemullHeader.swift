//
//  SelectMaemullHeader.swift
//  juinjang
//
//  Created by 조유진 on 6/1/25.
//

import UIKit
import SnapKit
import RxSwift

final class SelectMaemullHeader: BaseCollectionReusableView {
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
    
    var menuChildren: [UIMenuElement] = []
    let filterList = Filter.allCases
    weak var sendFilterItemDelegate: SendFilterItemDelegate?
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func callRequestFiltered(filterItem: Filter) {
        sendFilterItemDelegate?.sendFilterItem(filter: filterItem)
    }
    
    private func changefilterTitle(_ title: String) {
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        filterselectBtn.configuration?.title = title
        filterselectBtn.configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(filterselectBtn)
    }
    
    override func configureLayout() {
        super.configureLayout()
        filterselectBtn.snp.makeConstraints { make in
            
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
