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
    
    private lazy var segmentedControl: UnderLineSegmentedView = {
        return UnderLineSegmentedView(
            titles: [
                "공유한 노트",
                "소장한 노트",
                "좋아한 노트"
            ],
            horizontalInset: 46.5
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        bind()
    }
    
    func bind(reactor: MyNoteViewReactor) {
        reactor.state
            .compactMap { $0.categoryState }
            .asDriver(onErrorDriveWith: .just(.share))
            .drive(with: self, onNext: { owner, state in
                switch state {
                case .share:
                    print("공유한 노트 클릭")
                case .own:
                    print("소장 노트 클릭")
                case .like:
                    print("좋아요 누른 노트 클릭")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.add(
            self.navigationView,
            self.segmentedControl
        )
    }
    
    private func makeConstraints() {
        self.navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.segmentedControl.snp.makeConstraints {
            $0.top.equalTo(self.navigationView.snp.bottom)
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
                    self.navigationController?.popViewController(animated: true)
                case .searchButtonTap:
                    print("push MyNoteSearchViewController")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        self.segmentedControl
            .buttonTapRelay
            .withUnretained(self)
            .subscribe { (self, index) in
                self.reactor?.action.onNext(.categoryButtonDidTap(index))
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    return MyNoteViewController().then {
        $0.reactor = MyNoteViewReactor()
    }
}
