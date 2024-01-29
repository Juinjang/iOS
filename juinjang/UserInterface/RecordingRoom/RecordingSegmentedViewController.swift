//
//  RecordingSegmentedViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/5/24.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class RecordingSegmentedViewController: TabmanViewController {
    let tabView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.addBorder([.top, .bottom], color: UIColor(named: "gray0")!, width: 1.0)
    }
    let border = UIView()
    
    private var viewControllers: Array<UIViewController> = []
    let tabTitles = ["체크리스트", "기록룸"]
    
    var imjangNoteViewController: ImjangNoteViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        addBottomBorder(with: UIColor(named: "gray0"), andWidth: 1)
        setConstraints()
        addViewControllers()
        setDelegate()
        createBar()
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        border.backgroundColor = color
        tabView.addSubview(border)
    }
    
    func addViewControllers() {
        let checkListVC = CheckListViewController()
        let recordingRoomVC = RecordingRoomViewController()
        
        viewControllers.append(contentsOf: [checkListVC, recordingRoomVC])
    }
    
    func setDelegate() {
        self.dataSource = self
    }
    
    func createBar() {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(named: "gray1")
            button.font = .pretendard(size: 16, weight: .regular)
            button.selectedFont = .pretendard(size: 16, weight: .bold)
            button.selectedTintColor = UIColor(named: "textBlack")
        }
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.tintColor =  UIColor(named: "textBlack")
        bar.indicator.overscrollBehavior = .compress
//        bar.layout.interButtonSpacing = 35 // 버튼 사이 간격
        bar.layout.contentMode = .fit
        
        // Add to View
        self.addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
        
    }
    
    func addSubView() {
        view.addSubview(tabView)
    }
    
    func setConstraints() {
        tabView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(48)
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(view).offset(24)
            $0.trailing.equalTo(view).offset(-24)
            $0.height.equalTo(1)
        }
    }
}

extension RecordingSegmentedViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = tabTitles[index]
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
}


