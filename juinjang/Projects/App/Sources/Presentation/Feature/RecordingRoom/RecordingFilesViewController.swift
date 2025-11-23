//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation
import SkeletonView
import RxSwift

final class RecordingFilesViewController: BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.title = "녹음 파일"
        $0.leftItem = [.pop]
        $0.rightItem = [.startRecord]
    }
    
    let lastPopupDateKey = "lastPopupDate" // 경고 메시지 날짜 저장 Key
    
    // empty view
    private let emptyRecordImageView = UIImageView().then {
        $0.image = UIImage.Recording.emptyRecord
        $0.contentMode = .scaleAspectFit
        $0.alpha = 0
    }
    private let emptyLabel = UILabel().then {
        $0.text = "아직 녹음된 파일이 없어요"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray400
        $0.alpha = 0
    }
    
    private let recordingFileTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
    }
    
    var fileItems: [RecordResponse] = [] {
        didSet {
            recordingFileTableView.reloadData()
        }
    }
    
    weak var removeRecordDelegate: RemoveRecordDelegate?
    var imjangId: Int
    private var disposeBag = DisposeBag()
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        addSubViews()
        setConstraints()
        configureView()
        setDelegate()
        fetchRecordFiles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)    }
    
    private func setAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordName), name: .editRecordName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordScript), name: .editRecordScript, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRecordResponse), name: .addRecordResponse, object: nil)
    }
    
    private func bind() {
        navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.popViewController()
                case .startRecordButtonTap: owner.startRecording()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showSkeletonView() {
        setEmptyView(false)
        recordingFileTableView.showAnimatedSkeleton(usingColor: .gray100, transition: .crossDissolve(0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.recordingFileTableView.stopSkeletonAnimation()
            self.recordingFileTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            self.setEmptyView(self.fileItems.isEmpty)
        }
    }
    
    @objc private func addRecordResponse(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        showSkeletonView()
        fileItems.insert(recordResponse, at: 0)
    }
    
    @objc private func editRecordName(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordName = recordResponse.recordName
            }
        }
    }
      
    @objc private func editRecordScript(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordScript = recordResponse.recordScript
            }
        }
    }
    
    private func fetchRecordFiles() {
        showSkeletonView()
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[RecordResponse]?>.self, api: .fetchRecordFiles(imjangId: imjangId)) { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response, let result = response.result, let fileList = result else { return }
            guard let self else { return }
            fileItems = fileList
        }
    }
    
    private func setDelegate() {
        recordingFileTableView.dataSource = self
        recordingFileTableView.delegate = self
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func startRecording() {
        if fileItems.count >= 3 {
            showAlert(title: nil, message: "녹음 파일은 3개까지 생성 가능해요", actionHandler: nil)
            return
        }
        let bottomSheetVC = BottomSheetViewController(imjangId: imjangId)
        let warningMessageVC = WarningMessageViewController(imjangId: imjangId)
        let recordVC = RecordViewController(imjangId: imjangId)
        if shouldShowPopup() {
            warningMessageVC.bottomSheetViewController = bottomSheetVC
            warningMessageVC.delegate = self
            bottomSheetVC.addContentViewController(warningMessageVC)
            bottomSheetVC.modalPresentationStyle = .custom
            self.present(bottomSheetVC, animated: false, completion: nil)
        } else {
            print("오늘 하루 보지 않기 버튼을 선택했으므로 경고 메시지가 내일 나타납니다.")
            recordVC.bottomSheetViewController = bottomSheetVC
            bottomSheetVC.addContentViewController(recordVC)
            bottomSheetVC.modalPresentationStyle = .custom
            self.present(bottomSheetVC, animated: false, completion: nil)
        }
    }
    
    private func shouldShowPopup() -> Bool {
        let userDefaults = UserDefaults.standard
        if let lastPopupDate = userDefaults.object(forKey: lastPopupDateKey) as? Date {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastPopupDate) {
                return false
            } else {
                return true
            }
        } else {
            return true // 처음 실행
        }
    }
    
    private func resetPopupDateIfNeeded() {
        let userDefaults = UserDefaults.standard
        if let lastPopupDate = userDefaults.object(forKey: lastPopupDateKey) as? Date {
            let calendar = Calendar.current
            if !calendar.isDateInToday(lastPopupDate) {
                userDefaults.removeObject(forKey: lastPopupDateKey)
            } else {
                print("오늘 하루 보지 않기 버튼을 선택했으므로 경고 메시지가 내일 나타납니다.")
            }
        }
    }
    
    private func setEmptyView(_ isEmpty: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.emptyRecordImageView.alpha = isEmpty ? 1 : 0
            self.emptyLabel.alpha = isEmpty ? 1 : 0
        }
    }
 
    private func addSubViews() {
        view.add(
            navigationView,
            recordingFileTableView,
            emptyRecordImageView,
            emptyLabel
        )
    }
    
    private func setConstraints() {
        navigationView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        recordingFileTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyRecordImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.centerY.equalToSuperview().offset(-36)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyRecordImageView.snp.bottom).offset(16)
        }
    }
    
    private func configureView() {
        recordingFileTableView.isSkeletonable = true
    }
    
    func showDeletePopup(indexPath: IndexPath) {
        let deletePopupVC = DeletePopupViewController()
        deletePopupVC.fileIndexPath = indexPath
        
        let index = indexPath.row
        let fileName = fileItems[index].recordName
        deletePopupVC.fileName = fileItems[index].recordName
        deletePopupVC.completionHandler = { [weak self] indexPath in
            guard let self else { return }
            let index = indexPath.row
            deleteRecordFile(recordId: fileItems[index].recordId)
            NotificationCenter.default.post(name: .removeRecordResponse, object: fileItems[index].recordId, userInfo: nil)
            fileItems.remove(at: index)
            view.makeToast("\(fileName)이 삭제되었습니다.", duration: 1.0)
        }
        deletePopupVC.modalPresentationStyle = .overCurrentContext
        present(deletePopupVC, animated: false)
    }
    
    private func deleteRecordFile(recordId: Int) {
        showSkeletonView()
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<String>.self, api: .deleteRecordFile(recordId: recordId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response, let result = response.result else { return }
            print(#function, response)
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
        let fileItem = fileItems[indexPath.row]
        cell.setData(fileItem: fileItem)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordResponse = fileItems[indexPath.row]
        
        let bottomSheetViewController = BottomSheetViewController(imjangId: imjangId)
        let recordPlaybackVC = RecordPlaybackViewController(recordResponse: recordResponse)
        recordPlaybackVC.bottomSheetViewController = bottomSheetViewController
        bottomSheetViewController.addContentViewController(recordPlaybackVC)
        bottomSheetViewController.modalPresentationStyle = .custom
        self.present(bottomSheetViewController, animated: true, completion: nil)
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
        
        deleteAction.backgroundColor = .main
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension RecordingFilesViewController: SkeletonTableViewDataSource {
    // skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RecordFileSkeletonTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return RecordFileSkeletonTableViewCell()
    }
}

extension RecordingFilesViewController: CheckWarningMessageDelegate {
    func checkMessage() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(startOfDay, forKey: lastPopupDateKey)
    }
}
