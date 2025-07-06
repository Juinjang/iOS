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
    
    let bottomButtonView = BottomButtonView()
    
    override func configureHierarchy() {
        add(navigationView, collectionViewStackView, bottomButtonView)
        [sidoCollectionView, sigunguCollectionView, dongCollectionView].forEach {
            collectionViewStackView.addArrangedSubview($0)
        }
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
        
        bottomButtonView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let borderName = "topBorder"
        // 이미 추가된 게 있으면 중복 금지
        if let sublayers = collectionViewStackView.layer.sublayers,
           sublayers.contains(where: { $0.name == borderName }) {
            return
        }
        
        let border = CALayer()
        
        border.name = borderName
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
        collectionViewStackView.layer.addSublayer(border)
        collectionViewStackView.layer.masksToBounds = true
    }
    
    func addRightBorder(collectionView: UICollectionView, color: UIColor, thickness: CGFloat) {
        if collectionView.viewWithTag(1) != nil { return }

        let border = UIView()
        border.backgroundColor = color
        border.tag = 1  // 중복 추가 체크용
        add(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.snp.makeConstraints { make in
            make.verticalEdges.equalTo(collectionView)
            make.trailing.equalTo(collectionView.snp.trailing)
            make.width.equalTo(thickness)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.addTopBorder(color: .gray200, thickness: 1)
            self.addRightBorder(collectionView: self.sidoCollectionView, color: .gray200, thickness: 1)
            self.addRightBorder(collectionView: self.sigunguCollectionView, color: .gray200, thickness: 1)
        }
    }
}

extension SelectAreaView {
    private func createVerticalListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(43))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1000))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
