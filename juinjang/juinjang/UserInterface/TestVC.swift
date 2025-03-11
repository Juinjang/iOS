//
//  TestVC.swift
//  juinjang
//
//  Created by KimDongWoo on 3/9/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

class TestVC: UIViewController {

    // let navigationView = DefaultNavigationView().then {
    //     $0.title = "주인장짱"
    //     $0.leftItem = [.pop]
    //     $0.rightItem = [.record, .search]
    // }

     let navigationView = SearchNavigationView().then {
         $0.searchPlaceHolder = "주인장짱이다"
         $0.leftItem = [.pop]
     }

//    lazy var navigationView: CenterFlexibleNavigationView = {
//        CenterFlexibleNavigationView(centerView: juinjangImageView).then {
//            $0.leftItem = [.pop, .search]
//        }
//    }()

    private let juinjangImageView = UIImageView().then {
        $0.image = .Main.logo
    }

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .blue
        self.view.addSubview(navigationView)

        self.navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        self.juinjangImageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(20)
        }

        self.navigationView.itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    print("pop Button Tap")
                case .recordButtonTap:
                    print("record button tap")
                case .searchButtonTap:
                    print("search Button Tap")
                case .searchSummit:
                    print("search summit")
                case .settingButtonTap:
                    print("setting button Tap")
                }
            }
            .disposed(by: disposeBag)
    }
}
