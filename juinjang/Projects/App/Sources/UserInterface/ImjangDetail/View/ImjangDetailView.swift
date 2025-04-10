//
//  ImjangDetailView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ImjangDetailView: BaseView {
    fileprivate let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension Reactive where Base: ImjangDetailView {
    var navigationTitle: Binder<String> {
        return Binder(base) { view, title in
            view.navigationView.title = title
        }
    }
}
