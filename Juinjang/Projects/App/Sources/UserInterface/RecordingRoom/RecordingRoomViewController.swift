//
//  RecordingRoomViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/5/24.
//

import UIKit
import SnapKit
import Then
import AmplitudeSwift
import RxSwift

protocol RemoveRecordDelegate: AnyObject {
    func removeRecordResponse(recordId: Int)
}

final class RecordingRoomViewController: BaseViewController, RemoveRecordDelegate {
    private let onboardRepsotiroy = OnboardingRepository()
    private let disposeBag = DisposeBag()
    func removeRecordResponse(recordId: Int) {
        if let index = fileItems.firstIndex(where: { $0.recordId == recordId }) {
            fileItems.remove(at: index)
            loadRecordings()
        }
    }
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.bounces = true
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    let recordingFileLabel = UILabel()
    let addRecordingButton = UIButton()
    let recordingFileStackView = UIStackView()
    
    let showTotalRecordingButton = UIButton()
    let recordingHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let emptyMessageLabel = UILabel()
    
    let recordingFileTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
    }
    
    let notePadLabel = UILabel()
    lazy var memoTextView = UITextView().then {
        $0.backgroundColor = .gray100
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.textContainerInset = .init(top: 20, left: 16, bottom: 20, right: 16)
        $0.text = memoTextViewPlaceholder
        $0.textColor = .gray300
    }
    
    let memoTextViewPlaceholder = "500자까지 메모를 남길 수 있어요."
    
    var fileItems: [RecordResponse] = []
    
    var imjangId: Int
    var savedCheckListItems: [CheckListAnswer] = []
    var imjangNoteViewController: ImjangNoteViewController?
    
    init(imjangId: Int, savedCheckListItems: [CheckListAnswer]) {
        self.imjangId = imjangId
        self.savedCheckListItems = savedCheckListItems
        super.init()
    }
    
    let lastPopupDateKey = "lastPopupDate" // 경고 메시지 날짜 저장 Key
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        addSubView()
        setConstraints()
        designViews()
        setDelegate()
        hideKeyboardWhenTappedArround()
        setAddObserver()
        showTotalRecordingButton.addTarget(self, action: #selector(showRecordingFilesVC), for: .touchUpInside)
        addRecordingButton.addTarget(self, action: #selector(addRecordingFilesVC), for: .touchUpInside)
        callFetchRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("ChangeButtonStatus"), object: nil, userInfo: ["status": true])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("ChangeButtonStatus"), object: nil, userInfo: ["status": false])
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateUI(with items: [CheckListAnswer]) {
        self.savedCheckListItems = items
    }
    
    @objc
    func didStoppedParentScroll() {
        DispatchQueue.main.async {
            self.scrollView.isScrollEnabled = true
        }
    }
    
    private func setAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordName), name: .editRecordName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordScript), name: .editRecordScript, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeRecordFile), name: .removeRecordResponse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRecordResponse), name: .addRecordResponse, object: nil)
    }
    
    @objc private func addRecordResponse(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        if fileItems.count < 3 {
            fileItems.insert(recordResponse, at: 0)
        } else {
            fileItems.insert(recordResponse, at: 0)
            fileItems.removeLast()
        }
    
        loadRecordings()
    }
    
    @objc private func removeRecordFile(_ notification: Notification) {
        guard let recordId = notification.object as? Int else { return }
        fileItems.removeAll { $0.recordId == recordId }
        loadRecordings()
    }
    
    @objc private func editRecordName(_ notification: Notification) {
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordName = recordResponse.recordName
                recordingFileTableView.reloadData()
            }
        }
    }
    
    @objc private func editRecordScript(_ notification: Notification) {
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordScript = recordResponse.recordScript
                recordingFileTableView.reloadData()
            }
        }
    }
    
    // 녹음 3개까지, 메모 조회
    func callFetchRequest() {
        if UserDefaultManager.shared.isOnboarding {
            onboardRepsotiroy
                .retrieveMyNoteRecordMemo()
                .asObservable()
                .subscribe(with: self) { (self, response) in
                    self.setMemo(memo: response.memo)
                    self.fileItems = response.recordDto
                    self.loadRecordings()
                }
                .disposed(by: disposeBag)
            return
        }
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<RecordMemoDto>.self, api: .fetchRecordingRoom(imjangId: imjangId)) { [weak self] recordMemoDto, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self else { return }
            guard let recordMemoDto = recordMemoDto else { return }
            guard let result = recordMemoDto.result else { return }
            self.setMemo(memo: result.memo)
            fileItems = result.recordDto
            loadRecordings()
        }
    }
    func loadRecordings() {
        emptyMessageLabel.isHidden = fileItems.isEmpty ? false : true
        switch fileItems.count {
        case 0:
            updateTableViewHeight(multi: 3)
        case 1:
            updateTableViewHeight(multi: 1)
        case 2:
            updateTableViewHeight(multi: 2)
        case 3...:
            updateTableViewHeight(multi: 3)
        default:
            updateTableViewHeight(multi: 3)
        }
        recordingFileTableView.reloadData()
    }
    
    private func updateTableViewHeight(multi: Int) {
        recordingFileTableView.snp.updateConstraints { make in
            make.height.equalTo(56 * multi)
        }
    }
    
    func setMemo(memo: String?) {
        guard let memo = memo else {
            memoTextView.textColor = .gray300
            return
        }
        memoTextView.text = memo
        print("memo======\(memo)")
        memoTextView.textColor = memo.isEmpty ? .gray300 : .gray500
        if memo == memoTextViewPlaceholder {
            memoTextView.textColor = .gray300
        }
    }
    
    // 메모장 생성/수정 요청
    func callMemoRequest() {
        guard (!UserDefaultManager.shared.isOnboarding) else { return }
        print(#function)
        guard let memo = memoTextView.text else { return }
        let parameter = [
            "memo": memo
        ]
        print(UserDefaultManager.shared.accessToken)
        JuinjangAPIManager.shared.postData(type: BaseResponse<MemoDto>.self, api: .memo(imjangId: imjangId), parameter: parameter) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // 메모장 기재 이벤트
            amplitude.track(event: BaseEvent(eventType: AmpliEventName.button_clicked.rawValue, eventProperties: [
                AmpliEventProp.record_memo.rawValue: "true"
            ]))
        }
    }
    
    @objc
    func showRecordingFilesVC() {
        if UserDefaultManager.shared.isOnboarding {
            present(SignUpBottomSheetView(), animated: true)
            return
        }
        let RecordingFilesVC = RecordingFilesViewController(imjangId: imjangId)
        RecordingFilesVC.removeRecordDelegate = self
        self.navigationController?.pushViewController(RecordingFilesVC, animated: true)
    }
    
    @objc
    func addRecordingFilesVC() {
        if UserDefaultManager.shared.isOnboarding {
            present(SignUpBottomSheetView(), animated: true)
            return
        }
        
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
    
    func shouldShowPopup() -> Bool {
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
    
    func resetPopupDateIfNeeded() {
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
    
    // 키보드 내리기
    func hideKeyboardWhenTappedArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setDelegate() {
        recordingFileTableView.dataSource = self
        recordingFileTableView.delegate = self
        scrollView.delegate = self
        memoTextView.delegate = self
    }
    
    func addSubView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [recordingFileStackView, showTotalRecordingButton].forEach {
            recordingHeaderStackView.addArrangedSubview($0)
        }
        
        [recordingHeaderStackView, recordingFileTableView, notePadLabel, memoTextView].forEach {
            contentView.addSubview($0)
        }
        
        recordingFileTableView.addSubview(emptyMessageLabel)
    }
    
    func designViews() {
        designLabel(recordingFileLabel,
                    text: "녹음 파일",
                    font: .pretendard(size: 20, weight: .bold),
                    textColor: .gray500)
        
        designButton(addRecordingButton,
                     image: UIImage.addOrange)
        
        setStackView(recordingFileStackView,
                     label: recordingFileLabel,
                     button: addRecordingButton,
                     axis: .horizontal,
                     spacing: 8)
        
        designButton(showTotalRecordingButton, title: "전체보기")
        
        designLabel(emptyMessageLabel, text: "아직 녹음 파일이 없어요", font: .pretendard(size: 16, weight: .medium), textColor: .gray300)
        
        designLabel(notePadLabel, text: "메모장", font: .pretendard(size: 20, weight: .bold), textColor: .gray500)
        
    }
    
    func setConstraints() {
        // 스크롤뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(4)
        }
        
        // 컨텐트뷰
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView).multipliedBy(1.23)
        }
        
        recordingFileLabel.snp.makeConstraints {
            $0.height.equalTo(27)
        }
        
        addRecordingButton.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        
        showTotalRecordingButton.snp.makeConstraints {
            $0.height.equalTo(23)
        }
        
        recordingHeaderStackView.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
            $0.top.equalTo(contentView).offset(24)
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.center.equalTo(recordingFileTableView)
            $0.height.equalTo(22)
        }
        
        recordingFileTableView.snp.makeConstraints {
            $0.top.equalTo(recordingHeaderStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(56 * 3)
        }
        
        notePadLabel.snp.makeConstraints {
            $0.top.equalTo(recordingFileTableView.snp.bottom).offset(36)
            $0.leading.equalTo(contentView).offset(24)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(notePadLabel.snp.bottom).offset(12)
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
            $0.height.equalTo(368)
        }
    }
    
    
    // MARK: - 디자인
    // 스택뷰 설정
    func setStackView(_ stackView: UIStackView, label: UILabel, button: UIButton, axis: NSLayoutConstraint.Axis, spacing: CGFloat, isButtonRight: Bool=true){
        
        stackView.axis = axis
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        
        if isButtonRight {
            [label, button].forEach {
                stackView.addArrangedSubview($0)
            }
        } else {
            [button, label].forEach {
                stackView.addArrangedSubview($0)
            }
        }
    }
    
    
    // 이미지뷰 디자인
    func designImageView(_ imageView: UIImageView, image: UIImage?, contentMode: UIView.ContentMode, cornerRadius: CGFloat? = nil) {
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        
        if cornerRadius != nil {
            imageView.layer.cornerRadius = cornerRadius!
        }
    }
    
    // 레이블 디자인
    func designLabel(_ label: UILabel, text: String, alignment: NSTextAlignment = .left, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        label.text = text
        label.textAlignment = alignment
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
    }
    
    // 버튼 디자인
    func designButton(_ button: UIButton, title: String?=nil, image: UIImage?=nil) {
        if let title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray500, for: .normal)
            button.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        }
        
        if let image {
            button.setImage(image, for: .normal)
        }
    }
}
    
extension RecordingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function, fileItems.count)
        switch fileItems.count {
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 3...: return 3
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let fileItem = fileItems[indexPath.row]
        print(fileItem.recordId)
        cell.setData(fileItem: fileItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
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
}

extension RecordingRoomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("Child 스크롤 좌표 - \(scrollView.contentOffset.y)")
        
        // Child 스크롤 0 이하일 때
        if scrollView.contentOffset.y < -1 {
            scrollView.contentOffset.y = 0
            scrollView.isScrollEnabled = false
            NotificationCenter.default.post(name: NSNotification.Name("didStoppedChildScroll"), object: nil)
        }
    }
}

extension RecordingRoomViewController: UITextViewDelegate {
    // textView에 focus를 얻는 경우 발생
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == memoTextViewPlaceholder {
            textView.text = nil
            textView.textColor = .gray500
        }
    }
    
    // textView에 focus를 잃는 경우 발생
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextViewPlaceholder
            textView.textColor = .gray300
            
            callMemoRequest()
        } else {
            callMemoRequest()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 500 {
            textView.deleteBackward()
        }
    }
}

extension RecordingRoomViewController: CheckWarningMessageDelegate {
    func checkMessage() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(startOfDay, forKey: lastPopupDateKey)
    }
}
