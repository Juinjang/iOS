//
//  SelectAreaView.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SelectAreaView: BaseView {
    let naviagtionView = DefaultNavigationView().then {
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
        $0.register(SidoCell.self, forCellWithReuseIdentifier: SidoCell.identifier)
    }
    
    lazy var sigunguCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createVerticalListLayout()).then {
        $0.backgroundColor = .mainWhite
        $0.register(SigunguCell.self, forCellWithReuseIdentifier: SigunguCell.identifier)
    }
    
    lazy var dongepmyeonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createVerticalListLayout()).then {
        $0.backgroundColor = .mainWhite
    }
    
    let bottomButtonView = BottomButtonView()
    
    
    
    override func configureHierarchy() {
        addSubview(naviagtionView)
        addSubview(collectionViewStackView)
        [sidoCollectionView, sigunguCollectionView, dongepmyeonCollectionView].forEach {
            collectionViewStackView.addArrangedSubview($0)
        }
        addSubview(bottomButtonView)
    }
    
    override func configureLayout() {
        naviagtionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        collectionViewStackView.snp.makeConstraints { make in
            make.top.equalTo(naviagtionView.snp.bottom).offset(24)
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
        sidoCollectionView.backgroundColor = .mainWhite
        sigunguCollectionView.backgroundColor = .gray100
        dongepmyeonCollectionView.backgroundColor = .gray200
    }
}

extension SelectAreaView {
    private func createVerticalListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(43))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
