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
import AmplitudeSwift


final class RecordingSegmentedViewController: TabmanViewController, MoveWarningMessageDelegate, CheckListDelegate {
    
    let tabView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.addBorder([.top, .bottom], color: UIColor(named: "gray0")!, width: 1.0)
    }
    let border = UIView()
    
//    var viewControllers: Array<UIViewController> = [CheckListViewController(), RecordingRoomViewController()]
    var viewControllers: [UIViewController] = []
    let tabTitles = ["체크리스트", "기록룸"]
    var recordingRoomVC: RecordingRoomViewController?
    
    var imjangNoteViewController: ImjangNoteViewController?
    var imjangId: Int
    var version: Int
    
    init(imjangId: Int, version: Int) {
        self.imjangId = imjangId
        self.version = version
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        addBottomBorder(with: ColorStyle.gray0, andWidth: 1)
        setConstraints()
        addViewControllers()
        setDelegate()
        createBar()
        NotificationCenter.default.addObserver(self, selector: #selector(changePage), name: Notification.Name("ChangeButtonStatus"), object: nil)
    }
    
    @objc func changePage(notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? Bool {
            if (status) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    self.imjangNoteViewController?.editButton.alpha = 0.0
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    self.imjangNoteViewController?.editButton.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        border.backgroundColor = color
        tabView.addSubview(border)
    }
    
    func didSavedCheckListItems(_ items: [CheckListAnswer]) {
        recordingRoomVC?.updateUI(with: items)
    }
    
    func addViewControllers() {
        let checkListVC = CheckListViewController(imjangId: imjangId, version: version)
        checkListVC.delegate = self
        
        recordingRoomVC = RecordingRoomViewController(imjangId: imjangId, savedCheckListItems: checkListVC.savedCheckListItems)
        viewControllers.append(contentsOf: [checkListVC, recordingRoomVC!])
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
        
        let currentVC = self.viewControllers[index]
        
        if index == 1 { // 기록룸 클릭 이벤트
            amplitude.track(event: BaseEvent(eventType: AmpliEventName.button_clicked.rawValue, eventProperties: [
                AmpliEventProp.record_room.rawValue: "true"
            ]))
        }
        return currentVC
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    // 팝업창
    func showPopUp() {
        let warningPopup = CheckListPopUpViewController()
        warningPopup.moveWarningDelegate = self
        warningPopup.modalPresentationStyle = .overCurrentContext
    }
}
