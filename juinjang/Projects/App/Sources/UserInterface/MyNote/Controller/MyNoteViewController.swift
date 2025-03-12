//
//  MyNoteViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import UIKit
import ReactorKit
import RxCocoa
import Then
import SnapKit

final class MyNoteViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationView = DefaultNavigationView().then {
        $0.title = "마이노트"
        $0.leftItem = [.pop]
        $0.rightItem = [.search]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        bind()
    }
    
    func bind(reactor: MyNoteViewReactor) {
        reactor.state
            .compactMap { $0.navigation }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .just(.search))
            .drive(with: self, onNext: { owner, state in
                
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.categoryState }
            .asDriver(onErrorDriveWith: .just(.share))
            .drive(with: self, onNext: { owner, state in
                switch state {
                case .share: break
                case .own: break
                case .like: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.add(
            self.navigationView
        )
    }
    
    private func makeConstraints() {
        self.navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func bind() {
        self.navigationView
            .itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    print("Pop Button Did Tap")
                case .searchButtonTap:
                    print("Search Button Tap")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
