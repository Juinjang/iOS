//
//  ImjangListHeaderView.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import UIKit
import SnapKit
import Then

private enum Const {
    static let bigItemSize = CGSize(width: Int(UIScreen.main.bounds.width) - 88 , height: 220)
    static let smallItemSize = CGSize(width: Int(UIScreen.main.bounds.width) - 59*2, height: 198)
    static let itemSpacing = 12.0
    static var previousIndex = 0
    
    static var insetX: CGFloat {
        (UIScreen.main.bounds.width - self.bigItemSize.width) / 2.0
    }
    
    static var collectionViewContentInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
    }
}

class ImjangListHeaderView: UITableViewHeaderFooterView {
    let clippingEmptyBackgroundView = UIView()
    lazy var messageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 9
    }
    lazy var clipImageView = UIImageView()
    lazy var clipEmptyMessageLabel = UILabel()
    
//    var list: [ImjangNote] = [] 
    
    // collectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing = 44
        layout.itemSize = Const.bigItemSize
        layout.minimumLineSpacing = Const.itemSpacing
//        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false  // 한 페이지의 넓이를 조절할 수 없기 때문에 scrollViewWillEndDragging을 사용하여 구현
        collectionView.contentInsetAdjustmentBehavior = .never // 내부적으로 safe area에 의해 가려지는 것을 방지하기 위해서 자동으로 indset 조정해주는 것을 비활성화
        collectionView.contentInset = Const.collectionViewContentInset
//        collectionView.decelerationRate = .fast // 스크롤이 빠르게 되도록 (페이징 애니메이션같이 보이게 하기 위함)
        collectionView.backgroundColor = .clear
        collectionView.register(ScrapCollectionViewCell.self, forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
        return collectionView
    }()
    
    let filterBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.imagePadding = 2
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.setTitleColor(ColorStyle.darkGray, for: .normal)
        button.setImage(ImageStyle.arrowDown, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        button.tintColor = .white
        return button
    }()
    let deleteButton = UIButton()

    
    var menuChildren: [UIMenuElement] = []
    let filterList = Filter.allCases
    lazy var scrapedList: [ImjangNote] = ImjangList.list
    weak var delegate: ButtonTappedDelegate?    // 북마크 버튼 클릭했을 때
    
    // MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        setupConstraints()
        configureView()
        setFilterData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set Data
    func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: {  (action: UIAction) in
                self.changefilterTitle(filter.title)
                self.callRequestFiltered(sort: filter.title)
            }))
        }
        let menu = UIMenu(options: .displayAsPalette, children: menuChildren)
        filterselectBtn.menu = menu
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    
    func callRequestFiltered(sort: String) {
        
    }
    
    func changefilterTitle(_ title: String) {
        var config = filterselectBtn.configuration
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        container.foregroundColor = ColorStyle.darkGray
        config?.attributedTitle = AttributedString(title, attributes: container)
        config?.imagePadding = 2
        filterselectBtn.configuration = config
    }
    
    func configureHierarchy() {
        // 스크랩 없을 때
        [clippingEmptyBackgroundView, filterBackgroundView].forEach {
            contentView.addSubview($0)
        }
        [clipImageView, clipEmptyMessageLabel].forEach {
            messageStackView.addArrangedSubview($0)
        }
        clippingEmptyBackgroundView.addSubview(messageStackView)
        clippingEmptyBackgroundView.addSubview(collectionView)
        filterBackgroundView.addSubview(filterselectBtn)
        filterBackgroundView.addSubview(deleteButton)
        collectionView.isHidden = true  // 초기값
        // 스크랩 있을 때: 1. backgroundView 숨기기 2. 고정된 높이의 collectionView 보이게 하기 + gradient 추가
        // 아니면 1. backgroundView 높이를 높이고, 2. label을 없애기
        // 스택뷰를 사용하는게 좋을까,,?
    }
    
    func configureView(){
        contentView.backgroundColor = .white
        clipImageView.design(image: ImageStyle.bookmark, contentMode: .scaleAspectFit)
        clipEmptyMessageLabel.design(text: "버튼을 누르면 상단에 고정할 수 있어요",
                                     textColor: ColorStyle.null,
                                     font: .pretendard(size: 16, weight: .medium))
        DispatchQueue.main.async {
            self.clippingEmptyBackgroundView.applyGradientBackground()    // 스크랩 배경에 Gradient 추가
        }
        deleteButton.design(image: ImageStyle.trash, backgroundColor: .clear)

    }
    
    func setupConstraints() {
        print(#function)
        clippingEmptyBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(contentView)
            $0.height.equalTo(114)
        }
        
        messageStackView.snp.makeConstraints {
            $0.center.equalTo(clippingEmptyBackgroundView)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(clippingEmptyBackgroundView)
            $0.height.equalTo(252)
        }
        
        print("hi")
        filterBackgroundView.snp.makeConstraints {
            $0.top.equalTo(clippingEmptyBackgroundView.snp.bottom).offset(18)
            $0.horizontalEdges.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(5)
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
    
    func setFilterView(isEmpty: Bool) {
        print(#function)
        // empty 아니면 배경 숨기고, 콜렉션뷰 보이기, 콜렉션뷰 top으로 기준 변경, header의 높이도 변경 필요
        // empty면 collectionView 숨기고, top 기준 변경
        if isEmpty {
            print("collectionView 숨기기")
            messageStackView.isHidden = false
            collectionView.isHidden = true
            clippingEmptyBackgroundView.snp.updateConstraints {
                $0.height.equalTo(114)
            }
            filterselectBtn.snp.updateConstraints {
                $0.centerY.equalTo(filterBackgroundView)
                $0.leading.equalToSuperview().offset(16)
            }
            deleteButton.snp.updateConstraints {
                $0.centerY.equalTo(filterBackgroundView)
                $0.trailing.equalToSuperview().inset(24)
                $0.size.equalTo(22)
            }
        } else {
            print("filterBackground 숨기기")
            messageStackView.isHidden = true
            collectionView.isHidden = false
            clippingEmptyBackgroundView.snp.updateConstraints {
                $0.height.equalTo(252)
            }
            filterselectBtn.snp.updateConstraints {
                $0.centerY.equalTo(filterBackgroundView)
                $0.leading.equalToSuperview().offset(16)
            }
            deleteButton.snp.updateConstraints {
                $0.centerY.equalTo(filterBackgroundView)
                $0.trailing.equalToSuperview().inset(24)
                $0.size.equalTo(22)
            }
        }
    }
    
//    @objc func bookMarkButtonClicked(sender: UIButton) {
//        scrapedList.remove(at: sender.tag)
//        collectionView.reloadData()
//    }
}

//extension ImjangListHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//
//    
//}

//var currentIndex = 0
//
//extension ImjangListHeaderView: UICollectionViewDelegateFlowLayout {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
//        let cellWidth = Const.bigItemSize.width + Const.itemSpacing
//        let index = round(scrolledOffsetX / cellWidth)
//        currentIndex = Int(index)
////        print(index)
//        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left,
//                                              y: scrollView.contentInset.top)
//        self.collectionView.reloadData()
//    }
//}
//
//extension ImjangListHeaderView {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        
//        let cellWidthIncludeSpacing = Const.smallItemSize.width + Const.itemSpacing
//        let offsetX = collectionView.contentOffset.x
//        let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
//        let roundedIndex = round(index)
//        print(roundedIndex)
//        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            animateZoomforCell(zoomCell: cell)
//        }
//        if Int(roundedIndex) != Const.previousIndex {
//            let preIndexPath = IndexPath(item: Const.previousIndex, section: 0)
//           if let preCell = collectionView.cellForItem(at: preIndexPath) {
//               animateZoomforCellremove(zoomCell: preCell)
//           }
//            Const.previousIndex = indexPath.item
//       }
//    }
//    
//    func animateZoomforCell(zoomCell: UICollectionViewCell) {
//        UIView.animate(
//            withDuration: 0.2,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                zoomCell.transform = .identity
//        },
//            completion: nil)
//    }
//    
//    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
//        UIView.animate(
//            withDuration: 0.2,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                zoomCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        },
//            completion: nil)
//    }
//}
