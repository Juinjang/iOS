//
//  SplashViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/5/24.
//

import UIKit
import Lottie
import Then
import ReactorKit
import RxCocoa

final class SplashViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let animationView = LottieAnimationView(name: "splash60.json").then {
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAnimation()
    }
    
    func configureAnimation() {
        view.backgroundColor = .splash
        view.addSubview(animationView)
        animationView.center = view.center

        animationView.play { [weak self] (finish) in
            self?.reactor?.action.onNext(.viewDidLoad)
        }
    }
    
    func bind(reactor: SplashViewReactor) {
        reactor.state
            .compactMap { $0.navigation }
            .asDriver(onErrorDriveWith: .just(.login))
            .drive(with: self, onNext: { owner, navigation in
                owner.animationView.stop()
                
                switch navigation {
                case .onbording:
                    owner.changeOnboardingContainerVC()
                case .login:
                    owner.changeLoginVC()
                case .home:
                    owner.changeHome()
                }
            })
            .disposed(by: disposeBag)
    }
}
