//
//  UIViewController+Extension.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit

// 키보드 숨기기
extension UIViewController {
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        vc.navigationController?.navigationBar.isHidden = true
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }

    func changeHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate,
        let window = sceneDelegate.window else { return }
        
        let mainViewController = MainViewController()
        let nav = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
        window.makeKey()
    }
    
    func changeImjangListVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate,
        let window = sceneDelegate.window else { return }
        
        let imjangListViewController = ImjangListViewController()
        let mainViewController = MainViewController()
        let nav = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = nav
        DispatchQueue.main.async {
            nav.pushViewController(imjangListViewController, animated: false)
        }
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
        window.makeKey()
    }
    
    func changeLoginVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate,
        let window = sceneDelegate.window else { return }
        
        let mainViewController = SignUpViewController()
        let nav = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
        window.makeKey()
    }
    
    func changeOnboardingContainerVC() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate,
        let window = sceneDelegate.window else { return }
        
        let mainViewController = OnboardingContainerViewController(reactor: OnboardingContainerReactor())
        let nav = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
        window.makeKey()
    }
}
