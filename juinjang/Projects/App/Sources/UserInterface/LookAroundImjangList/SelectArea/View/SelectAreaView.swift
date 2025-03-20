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
    
    override func configureHierarchy() {
        addSubview(naviagtionView)
    }
    
    override func configureLayout() {
        naviagtionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
    }
}
