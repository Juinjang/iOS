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

class RecordingSegmentedViewController: TabmanViewController, MoveWarningMessageDelegate {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditButtonToggled), name: NSNotification.Name("EditButtonToggled"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editCheckList), name: NSNotification.Name("EditCheckList"), object: nil)
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        border.backgroundColor = color
        tabView.addSubview(border)
    }
    
    func addViewControllers() {
        let checkListVC = NotEnteredCheckListViewController()
        let recordingRoomVC = RecordingRoomViewController()
        
        viewControllers.append(contentsOf: [checkListVC, recordingRoomVC])
    }
    
    @objc func handleEditButtonToggled(_ notification: Notification) {
        if let isSelected = notification.object as? Bool {
            let checkListVC: UIViewController = isSelected ? CheckListViewController() : NotEnteredCheckListViewController()

            if let index = viewControllers.firstIndex(where: { $0 is NotEnteredCheckListViewController }) {
                viewControllers[index] = checkListVC
                self.reloadData()
            } else if let index = viewControllers.firstIndex(where: { $0 is CheckListViewController }) {
                viewControllers[index] = checkListVC
                self.reloadData()
            }
        }
    }
    
    @objc func editCheckList() {
        // CheckListViewController로 교체
        let checkListVC = CheckListViewController()

        if let index = viewControllers.firstIndex(where: { $0 is NotEnteredCheckListViewController }) {
            viewControllers[index] = checkListVC
            self.reloadData()
        }
        imjangNoteViewController?.editButton.setImage(UIImage(named: "completed-button"), for: .normal)
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
    
    func getWarningMessage() -> String {
        // viewControllers[0]가 CheckListViewController 일 때의 처리를 추가
        if let currentViewController = viewControllers.first, currentViewController is CheckListViewController {
            dismiss(animated: false) {
                self.scrollToPage(.next, animated: true) // 페이지 전환
            }
            return "기록룸으로 이동할까요?\n저장하지 않은 수정사항은 사라집니다."
        } else {
            return "임장노트로 이동할까요?\n저장하지 않은 수정사항은 사라집니다."
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
        
        let currentViewController = self.viewControllers[index]
        print("Current View Controller: \(currentViewController)")
        
        if currentViewController == self.viewControllers[0] {
            print("현재 ViewController", currentViewController)
            imjangNoteViewController?.editButton.isHidden = false
            imjangNoteViewController?.upButton.isHidden = true
            
        } else {
            print("현재 ViewController", currentViewController)
            imjangNoteViewController?.editButton.isHidden = true
            imjangNoteViewController?.upButton.isHidden = false
        }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    // 팝업창
    func showPopUp() {
        let warningPopup = CheckListPopUpViewController()
        warningPopup.moveWarningDelegate = self
        warningPopup.modalPresentationStyle = .overCurrentContext
        present(warningPopup, animated: true)
    }
}


