//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation



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
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
    }
    
    var fileURLs : [URL] = []
    //var fileItems: [RecordingFileItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setConstraints()
        designNavigationBar()
        setDelegate()
        //setItemData()
        loadRecordings()
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
        
        let addButtonItem = UIBarButtonItem(image: UIImage(named: "addOrange"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(startRecording))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "mainOrange")
    }
    
    @objc func back(_ sender: Any) {
        let vc = ImjangNoteViewController()
        navigationController?.pushViewController(vc, animated: true)
       // navigationController?.popViewController(animated: true)
    }
    
    @objc func startRecording(_ sender: Any) {
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.modalPresentationStyle = .custom
//        bottomSheetViewController.transitioningDelegate = self
        self.present(bottomSheetViewController, animated: false, completion: nil)
        // TODO: - 녹음 파일 추가
    }
    
//    func setItemData() {
//        fileItems.append(contentsOf: [
//            .init(name: "보일러 관련", recordedDate: Date(), recordedTime: "1:30"),
//            .init(name: "화장실 관련", recordedDate: Date(), recordedTime: "1:50"),
//            .init(name: "인테리어 관련", recordedDate: Date(), recordedTime: "4:20"),
//            .init(name: "계약 관련", recordedDate: Date(), recordedTime: "4:20"),
//        ])
//        
//        if fileItems.isEmpty {
//            recordingFileTableView.isHidden = true
//        }
//        
//        recordingFileTableView.reloadData()
//    }
    
    func loadRecordings() {
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
           do {
               // 문서 디렉토리에서 녹음 파일들을 가져옴
               let recordingURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
               // 녹음 파일 목록에 추가
               fileURLs = recordingURLs.filter { $0.pathExtension == "m4a" } // .m4a 확장자를 가진 파일만 필터링
           } catch {
               print("Failed to load recordings: \(error)")
           }

           // UITableView 새로고침
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
    
    func showDeletePopup(indexPath: IndexPath) {
        let deletePopupVC = DeletePopupViewController()
        deletePopupVC.fileIndexPath = indexPath
        //deletePopupVC.fileName = fileItems[indexPath.row].name
        
        let fileURL = self.fileURLs[indexPath.row]
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting file: \(error)")
        }
        deletePopupVC.fileName = fileURLs[indexPath.row].lastPathComponent
        deletePopupVC.completionHandler = { [weak self] indexPath in
            self?.fileURLs.remove(at: indexPath.row)
            self?.recordingFileTableView.deleteRows(at: [indexPath], with: .fade)
        }
        deletePopupVC.modalPresentationStyle = .overCurrentContext
        present(deletePopupVC, animated: true)
    }
    @objc func playButtonTapped(_ sender: UIButton) {
        // 버튼 이미지 변경
        print("버튼 눌림")
        sender.setImage(UIImage(named: "star"), for: .normal)
        
        // 녹음 파일을 재생하는 코드
        
    }
}

extension RecordingFilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fileItems.count
        return fileURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else { return UITableViewCell() }
        let recordingURL = fileURLs[indexPath.row]
        let playVC = PlayRecordViewController()
        playVC.bottomViewController.audioFile = fileURLs[indexPath.row]
        playVC.bottomViewController.initPlay1()
        cell.selectionStyle = .none
        //cell.setData(fileItem: fileURLs[indexPath.row])
        cell.setData(fileTitle: "\(fileURLs[indexPath.row].lastPathComponent)", time: "\(playVC.bottomViewController.remainingTimeLabel.text ?? "0:00")")
        //cell.recordingFileNameLabel.text = fileURLs[indexPath.row].lastPathComponent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 새로운 뷰 컨트롤러를 생성하고 데이터를 전달합니다.
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .custom
        
        let playVC = PlayRecordViewController()
        playVC.bottomViewController.audioFile = fileURLs[indexPath.row]
        playVC.bottomViewController.titleTextField.text = fileURLs[indexPath.row].lastPathComponent
        
        vc.transitionToViewController(playVC)
        
        // 새로운 뷰 컨트롤러를 present 합니다.
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제하기") {
            (_,_, completionHandler) in
            self.showDeletePopup(indexPath: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(named: "mainOrange")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
