//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit

class RecordingFilesViewController: UIViewController {
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.bounces = false
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    
    let recordingFileTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
    }
    
    var fileItems: [RecordingFileItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setConstraints()
        designNavigationBar()
        setDelegate()
        setItemData()
    }
    
    func setDelegate() {
        recordingFileTableView.dataSource = self
        recordingFileTableView.delegate = self
    }
    
    func designNavigationBar() {
        self.navigationItem.title = "녹음 파일"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = UIColor(named: "textBlack")
        navigationItem.setHidesBackButton(true, animated: true)

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(back))
        
        let addButtonItem = UIBarButtonItem(image: UIImage(named: "+"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(startRecording))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func startRecording(_ sender: Any) {
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.modalPresentationStyle = .custom
//        bottomSheetViewController.transitioningDelegate = self
        self.present(bottomSheetViewController, animated: false, completion: nil)
        // TODO: - 녹음 파일 추가
    }
    
    func setItemData() {
        fileItems.append(contentsOf: [
            .init(name: "녹음_001", recordedDate: Date(), recordedTime: "1:57"),
            .init(name: "녹음_002", recordedDate: Date(), recordedTime: "2:12"),
            .init(name: "녹음_003", recordedDate: Date(), recordedTime: "2:43"),
            .init(name: "녹음_004", recordedDate: Date(), recordedTime: "3:11"),
            .init(name: "녹음_005", recordedDate: Date(), recordedTime: "2:41"),
            .init(name: "녹음_006", recordedDate: Date(), recordedTime: "1:03"),
            .init(name: "녹음_007", recordedDate: Date(), recordedTime: "2:42"),
            .init(name: "보일러 관련", recordedDate: Date(), recordedTime: "1:30"),
            .init(name: "화장실 관련", recordedDate: Date(), recordedTime: "1:50"),
            .init(name: "인테리어 관련", recordedDate: Date(), recordedTime: "4:20"),
            .init(name: "계약 관련", recordedDate: Date(), recordedTime: "4:20"),
        ])
        
        if fileItems.isEmpty {
            recordingFileTableView.isHidden = true
        }
        
        recordingFileTableView.reloadData()
    }
    
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(recordingFileTableView)
    }
    
    func setConstraints() {
        // 스크롤뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 컨텐트뷰
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(view).multipliedBy(1.1)
        }
        
        recordingFileTableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(contentView)
        }
    }
}

extension RecordingFilesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setData(fileItem: fileItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // editing style에 대한 종류를 설정
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            fileItems.remove(at: indexPath.row)
////            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제하기") {
            (_,_, completionHandler) in
            
        }
        
        deleteAction.backgroundColor = UIColor(named: "mainOrange")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
