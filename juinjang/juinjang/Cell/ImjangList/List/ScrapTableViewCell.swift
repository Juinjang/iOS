//
//  ScrapTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/18/24.
//

import UIKit

class ScrapTableViewCell: UITableViewCell {
    let clippingEmptyBackgroundView = UIView()
    lazy var messageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 9
    }
    lazy var clipImageView = UIImageView()
    lazy var clipEmptyMessageLabel = UILabel()
    
    // collectionView
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionFlowLayout())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
        configureCollectionView()
    }
    
    func configureHierarchy() {
        [clippingEmptyBackgroundView].forEach {
            contentView.addSubview($0)
        }
        [clipImageView, clipEmptyMessageLabel].forEach {
            messageStackView.addArrangedSubview($0)
        }
        clippingEmptyBackgroundView.addSubview(messageStackView)
        // 스크랩 없을때 끝
        clippingEmptyBackgroundView.addSubview(collectionView)
        
    }
    
    func configureLayout() {
        clippingEmptyBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        messageStackView.snp.makeConstraints {
            $0.center.equalTo(clippingEmptyBackgroundView)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(clippingEmptyBackgroundView)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .white
        collectionView.isHidden = true  // 초기값
        clipImageView.design(image: ImageStyle.bookmark, contentMode: .scaleAspectFit)
        clipEmptyMessageLabel.design(text: "버튼을 누르면 상단에 고정할 수 있어요",
                                     textColor: ColorStyle.null,
                                     font: .pretendard(size: 16, weight: .medium))
        DispatchQueue.main.async {
            self.clippingEmptyBackgroundView.applyGradientBackground()    // 스크랩 배경에 Gradient 추가
        }
    }
    
    func setEmptyUI(isEmpty: Bool) {
        print(isHidden)
        // empty면 messge 보이게, collectionView 숨기기, empty아니면 반대
        messageStackView.isHidden = isEmpty ? false : true
        collectionView.isHidden = isEmpty ? true : false
    }
    
    func configureCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false  // 한 페이지의 넓이를 조절할 수 없기 때문에 scrollViewWillEndDragging을 사용하여 구현
        collectionView.contentInsetAdjustmentBehavior = .never // 내부적으로 safe area에 의해 가려지는 것을 방지하기 위해서 자동으로 indset 조정해주는 것을 비활성화
        collectionView.contentInset = Const.collectionViewContentInset
        collectionView.decelerationRate = .fast // 스크롤이 빠르게 되도록 (페이징 애니메이션같이 보이게 하기 위함)
        collectionView.backgroundColor = .clear
        collectionView.register(ScrapCollectionViewCell.self, forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
    }
    
    func configureCollectionFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let spacing = 44
        layout.itemSize = Const.bigItemSize
        layout.minimumLineSpacing = Const.itemSpacing
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
