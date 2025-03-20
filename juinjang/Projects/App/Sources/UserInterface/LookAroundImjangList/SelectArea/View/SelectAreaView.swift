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
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    let bottomButtonView = BottomButtonView()
    
    
    override func configureHierarchy() {
        addSubview(naviagtionView)
        addSubview(collectionView)
        addSubview(bottomButtonView)
    }
    
    override func configureLayout() {
        naviagtionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
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
        collectionView.backgroundColor = .mainWhite
    }
}

extension SelectAreaView {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        return UICollectionViewLayout()
    }
}
