//
//  LookAroundSearchView.swift
//  juinjang
//
//  Created by 조유진 on 3/21/25.
//

import UIKit

final class LookAroundSearchView: BaseView {
    let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "임장노트 지역이나 제목을 입력해보세요."
        $0.leftItem = [.pop]
    }
    
    override func configureHierarchy() {
        addSubview(navigationView)
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
