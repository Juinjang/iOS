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
        
        reactor.state
            .compactMap { $0.showUpdateAppPopup }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, show in
                guard show else { return }
                owner.showUpdateAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func showUpdateAlert() {
            
        // 커스텀 뷰 인스턴스 생성
        let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: 342, height: 325))
        updateAlertView.center = view.center
        
        // 커스텀 뷰 배경에 어두운 배경 추가 (배경 어두운 색을 두고 뷰만 강조)
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        view.addSubview(dimmingView)
        view.addSubview(updateAlertView)
        
        // 업데이트 버튼 클릭 시 동작 정의
        updateAlertView.updateButtonTappedAction = { [weak self] in
            guard let self else { return }
            openAppStore()
        }
        
        // 닫기 버튼 클릭 시 동작 정의
        updateAlertView.closeButtonTappedAction = {
            dimmingView.removeFromSuperview()
            updateAlertView.removeFromSuperview()
        }
    }

    // 앱 스토어로 이동
    private func openAppStore() {
        guard let url = URL(string: APIKey.appStoreOpenUrlString),
              UIApplication.shared.canOpenURL(url)
        else { return }
        
        UIApplication.shared.open(url, options: [:]) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
}
