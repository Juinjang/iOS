
import UIKit
import ObjectiveC

enum NavAnimationStyle: Int {
    case `default`
    case slideFromLeft
}

private var navAnimationStyleKey: UInt8 = 0

extension UIViewController {
    var navAnimationStyle: NavAnimationStyle {
        get {
            let value = objc_getAssociatedObject(self, &navAnimationStyleKey) as? Int
            return NavAnimationStyle(rawValue: value ?? 0) ?? .default
        }
        set {
            objc_setAssociatedObject(self,
                                     &navAnimationStyleKey,
                                     newValue.rawValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

final class TransitionNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let style: NavAnimationStyle
        
        operation == .push
        ? (style = toVC.navAnimationStyle)
        : (style = fromVC.navAnimationStyle)
        
        return style == .slideFromLeft
        ? SlideAnimator(operation: operation)
        : nil
    }
}

extension UINavigationController {
    func pushViewControllerFromLeftSide(_ viewController: UIViewController,
                                        animated: Bool = true) {
        viewController.navAnimationStyle = .slideFromLeft
        pushViewController(viewController, animated: animated)
    }
    
    
}
