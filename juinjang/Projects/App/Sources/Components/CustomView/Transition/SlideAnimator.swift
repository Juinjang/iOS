//
//  SlideAnimator.swift
//  App
//
//  Created by KimDongWoo on 12/11/25.
//

import UIKit

final class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC   = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let duration = transitionDuration(using: transitionContext)
        let bounds = container.bounds
        
        switch operation {
        case .push:
            // 1. toVC를 화면 왼쪽 바깥에 배치
            toVC.view.frame = bounds.offsetBy(dx: -bounds.width, dy: 0)
            container.addSubview(toVC.view)
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                // 새 화면: 중앙으로 슬라이드 인
                toVC.view.frame = bounds
                // 기존 화면: 살짝 오른쪽으로 밀리는 느낌 (옵션)
                fromVC.view.frame = bounds.offsetBy(dx: bounds.width * 0.3, dy: 0)
            }, completion: { finished in
                // fromVC 원위치 복구 (캔슬 대비)
                fromVC.view.frame = bounds
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        case .pop:
            // 뒤에 있는 화면을 먼저 깔아두고, 오른쪽에 살짝 배치
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            toVC.view.frame = bounds.offsetBy(dx: bounds.width * 0.3, dy: 0)
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                // 현재 화면: 왼쪽으로 화면 밖으로 나가게
                fromVC.view.frame = bounds.offsetBy(dx: -bounds.width, dy: 0)
                
                // 뒤에 있던 화면: 오른쪽에서 중앙으로 들어오게
                toVC.view.frame = bounds
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        default:
            transitionContext.completeTransition(true)
        }
    }
}
