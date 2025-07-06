//
//  SelectAreaView.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SelectAreaView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.title = "임장 지역 선택"
        $0.leftItem = [.pop]
    }
    
    private let collectionViewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .mainWhite
    }
    
    private let topBorder = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    lazy var sidoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createVerticalListLayout()).then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
        $0.register(
            SidoCell.self,
            forCellWithReuseIdentifier: SidoCell.identifier
        )
    }
    
    lazy var sigunguCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createVerticalListLayout()).then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
        $0.register(
            SigunguCell.self,
            forCellWithReuseIdentifier: SigunguCell.identifier
        )
    }
    
    lazy var dongCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createVerticalListLayout()).then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.register(
            DongCell.self,
            forCellWithReuseIdentifier: DongCell.identifier
        )
    }
    
    let selectedAreaView = SelectedAreaView()
    
    let bottomButtonView = BottomButtonView()
    
    func setCollectionViewContentInset(isShowSelectedAreaView: Bool) {
        var inset: UIEdgeInsets
        
        inset = isShowSelectedAreaView ?
        UIEdgeInsets(top: 0, left: 0, bottom: 92, right: 0) :
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionViewStackView.subviews.forEach { view in
            guard let view = view as? UICollectionView else { return }
            setCollectionViewContentInset(view: view, inset: inset)
        }
    }
    
    func setCollectionViewContentInset(view: UICollectionView, inset: UIEdgeInsets) {
        view.contentInset = inset
    }
    
    override func configureHierarchy() {
        [sidoCollectionView,
         sigunguCollectionView,
         dongCollectionView
        ].forEach {
            collectionViewStackView.addArrangedSubview($0)
        }
        
        add(
            navigationView,
            collectionViewStackView,
            topBorder,
            bottomButtonView,
            selectedAreaView
        )
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
        }
        
        collectionViewStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomButtonView.snp.top)
        }
        
        topBorder.snp.makeConstraints { make in
            make.top.equalTo(collectionViewStackView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        selectedAreaView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButtonView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(92)
        }
    }
    
    override func configureView() {
        super.configureView()
        DispatchQueue.main.async {
            self.addRightBorder(collectionView: self.sidoCollectionView, color: .gray200, thickness: 1)
            self.addRightBorder(collectionView: self.sigunguCollectionView, color: .gray200, thickness: 1)
            self.bringSubviewToFront(self.selectedAreaView)
        }
    }
    
    func addRightBorder(collectionView: UICollectionView, color: UIColor, thickness: CGFloat) {
        if collectionView.viewWithTag(1) != nil { return }
        
        let border = UIView()
        border.backgroundColor = color
        border.tag = 1  // 중복 추가 체크용
        add(border)
        
        border.snp.makeConstraints { make in
            make.verticalEdges.equalTo(collectionView)
            make.trailing.equalTo(collectionView.snp.trailing)
            make.width.equalTo(thickness)
        }
    }
}

extension SelectAreaView {
    private func createVerticalListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(43))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
