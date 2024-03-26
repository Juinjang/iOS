//
//  BottomSheetViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/09.
//

import UIKit
import SnapKit
import AVFoundation

class BottomSheetViewController: UIViewController {
    
    var currentViewController: UIViewController?
    
    let dimmedView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupLayout()
        
        dimmedView.alpha = 0.0
        
        let warningMessageVC = WarningMessageViewController()
        warningMessageVC.bottomSheetViewController = self
        addContentViewController(warningMessageVC)
    }
    
    private func addContentViewController(_ viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        // Content View Controller의 레이아웃 설정
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    func addSubViews() {
        view.addSubview(dimmedView)
    }
    
    func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    public func showBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func hideBottomSheetAndGoBack() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
               // self.dismiss(animated: false, completion: nil)
                let recordListViewController = RecordingFilesViewController()
                // 현재 내비게이션 컨트롤러가 nil인지 확인
                if let navigationController = self.navigationController {
                    // 내비게이션 컨트롤러 스택에 MainViewController를 push
                    navigationController.pushViewController(recordListViewController, animated: true)
                    print("recordListViewController로 push됨") // 확인용 로그 추가
                } else {
                    // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 MainViewController를 rootViewController로 설정
                    let navigationController = UINavigationController(rootViewController: recordListViewController)
                    if let windowScene = UIApplication.shared.connectedScenes
                        .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                        if let window = windowScene.windows.first {
                            window.rootViewController = navigationController
                        }
                    }
                    print("recordListViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
                }
            }
        }
    }
    
    func transitionToViewController(_ viewController: UIViewController) {
        // 이전 뷰 컨트롤러를 제거
        currentViewController?.removeFromParent()
        currentViewController?.view.removeFromSuperview()

        // 새로운 뷰 컨트롤러를 추가
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        // 현재 뷰 컨트롤러 갱신
        currentViewController = viewController
    }
}
