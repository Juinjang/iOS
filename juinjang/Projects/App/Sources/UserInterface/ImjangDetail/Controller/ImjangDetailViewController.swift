//
//  ImjangDetailViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import UIKit
import ReactorKit
import RxSwift


final class ImjangDetailViewController: BaseViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    private let mainView = ImjangDetailView()
    
    init(reactor: ImjangDetailViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: ImjangDetailViewReactor) {
        reactor.state
            .map { $0.title }
            .bind(to: mainView.rx.navigationTitle)
            .disposed(by: disposeBag)
    }
}
