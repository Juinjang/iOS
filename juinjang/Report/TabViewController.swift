//
//  TabViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//

import UIKit
import SnapKit
import Then
import Tabman
import Pageboy

class TabViewController: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    
    let tabView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    func addViewControllers() {
        let graphVC = GraphViewController()
        let compareVC = CompareViewController()
        viewControllers.append(graphVC)
        viewControllers.append(compareVC)
    }
    
    func createBar() {
        let bar = TMBar.ButtonBar()
        //bar.backgroundColor = .white
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(named: "400")
            button.font = UIFont(name: "Pretendard-Medium", size: 16) ?? .systemFont(ofSize: 16)
            button.selectedFont = UIFont(name: "Pretendard-SemiBold", size: 16)
            button.selectedTintColor = UIColor(named: "500")
        }
        bar.indicator.weight = .custom(value: 1)     //하단바 두께
        bar.indicator.tintColor =  UIColor(named: "500")   //하단바 색상
        bar.indicator.overscrollBehavior = .compress

        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
    
    func setConstraints() {
        tabView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(38)
        }
        lineView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllers()
        self.dataSource = self
        
        view.addSubview(tabView)
        tabView.addSubview(lineView)
        createBar()
        
        setConstraints()
    }
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "그래프")
        default:
            return TMBarItem(title: "비교해보기")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: 0)
    }
}
