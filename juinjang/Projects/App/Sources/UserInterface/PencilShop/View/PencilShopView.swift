//
//  PencilShopView.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import RxSwift
import RxRelay
import StoreKit

enum PencilShopCategoryType: Int, CaseIterable {
    case buying
    case obtainedPencil
    case purchasedPencil
    case usedPencil
}

extension PencilShopCategoryType {
    var toText: String {
        switch self {
        case .buying: return "구매하기"
        case .obtainedPencil: return "얻은 연필"
        case .purchasedPencil: return "구매한 연필"
        case .usedPencil: return "사용한 연필"
        }
    }
}

final class PencilShopView: BaseView {
    private var disposeBag = DisposeBag()

    private let navigationView = DefaultNavigationView().then {
        $0.title = "연필상점"
        $0.leftItem = [.pop]
    }
    
    lazy var segmentedView: UnderLineSegmentedView = {
         return UnderLineSegmentedView(
             titles: PencilShopCategoryType.allCases.map { $0.toText },
             horizontalInset: 46.5
         ).then {
             $0.bind(to: scrollView)
         }
     }()
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    
    private let stackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    private var pages: [UIView] = []
    
    let navigationEventRelay = PublishRelay<NavigationAction>()
    let buyingView = BuyingView()
    let obtainedView = ObtainedPencilView()
    let purchasedView = PurchasedPencilView()
    let usedView = UsedPencilView()
    
    init() {
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProductList(_ products: [Product]) {
        buyingView.setProductList(products)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        self.pages = [buyingView, obtainedView, purchasedView, usedView]
        add(
            navigationView,
            segmentedView,
            scrollView.with(stackView)
        )
        
        pages.forEach { page in
            stackView.addArrangedSubview(page)
            page.snp.makeConstraints { make in
                make.width.equalTo(scrollView.snp.width)
            }
        }
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func scrollToPage(categoryType: PencilShopCategoryType, animated: Bool = true) {
        let pageWidth = UIScreen.main.bounds.size.width
        let targetOffset = CGPoint(x: pageWidth * CGFloat(categoryType.rawValue), y: 0)
        
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(targetOffset, animated: animated)
        scrollView.isScrollEnabled = false
    }
}
