//
//  RecordingRoomViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/5/24.
//

import UIKit
import SnapKit
import Then

protocol PassDataDelegate: AnyObject {
    func passData(id: Int)
}

class RecordingRoomViewController: UIViewController, PassDataDelegate {
    func passData(id: Int) {
        self.imjangId = id
    }
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
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
    
    let tableBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    let emptyMessageLabel = UILabel()
    
    let recordingFileTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
        $0.estimatedRowHeight = 56
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
    }
    
    let notePadLabel = UILabel()
    lazy var memoTextView = UITextView().then {
        $0.backgroundColor = UIColor(named: "lightBackgroundOrange")
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.textContainerInset = .init(top: 20, left: 16, bottom: 20, right: 16)
        $0.text = memoTextViewPlaceholder
        $0.textColor = UIColor(named: "placeholderOrange")
    }
    
    let memoTextViewPlaceholder = "눌러서 메모를 추가해보세요!"

    //var fileItems: [RecordingFileItem] = []
    var fileURLs : [URL] = []
    
    var imjangId: Int? = nil {
        didSet {
            print("임장룸\(imjangId)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(Date())
        setDelegate()
        addSubView()
       // setItemData()
        loadRecordings()
        designViews()
        setConstraints()
        hideKeyboardWhenTappedArround()
        showTotalRecordingButton.addTarget(self, action: #selector(showRecordingFilesVC), for: .touchUpInside)
        addRecordingButton.addTarget(self, action: #selector(addRecordingFilesVC), for: .touchUpInside)
        callFetchRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
    }
    
    @objc
    func didStoppedParentScroll() {
        print("얍")
        DispatchQueue.main.async {
            self.scrollView.isScrollEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordingFileTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        callMemoRequest()
    }
    
    // 녹음 3개까지, 메모 조회
    func callFetchRequest() {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<RecordMemoDto>.self, api: .fetchRecordingRoom(imjangId: imjangId)) { recordMemoDto, error in
            if error == nil {
                guard let recordMemoDto = recordMemoDto else { return }
                guard let result = recordMemoDto.result else { return }
                print(result)
                self.setMemo(memo: result.memo)
            } else {
                guard let error = error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
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
        if fileURLs.isEmpty {
            tableBackgroundView.isHidden = false
        } else {
            tableBackgroundView.isHidden = true
        }
        recordingFileTableView.reloadData()

           // UITableView 새로고침
           recordingFileTableView.reloadData()
    }
    
    func setMemo(memo: String?) {
        guard let memo = memo else { return }
        memoTextView.text = memo
        memoTextView.textColor = memo.isEmpty ? ColorStyle.placeholderOrange : ColorStyle.textBlack
    }
    
    // 메모장 생성/수정 요청
    func callMemoRequest() {
        print(#function)
        guard let imjangId = imjangId else { return }
        guard let memo = memoTextView.text else { return }
        let parameter = [
            "memo": memo
        ]
        print(UserDefaultManager.shared.accessToken)
        JuinjangAPIManager.shared.postData(type: BaseResponse<MemoDto>.self, api: .memo(imjangId: imjangId), parameter: parameter) { response, error in
            if error == nil {
                guard let response = response else { return }
            } else {
                guard let error = error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    @objc
    func showRecordingFilesVC() {
        let RecordingFilesVC = RecordingFilesViewController()
        self.navigationController?.pushViewController(RecordingFilesVC, animated: true)
    }
    @objc
    func addRecordingFilesVC() {
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.modalPresentationStyle = .custom
        self.present(bottomSheetViewController, animated: false, completion: nil)
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
    
//    func setItemData() {
//        fileItems.append(contentsOf: [
//            .init(name: "보일러 관련", recordedDate: Date(), recordedTime: "1:30"),
//            .init(name: "녹음_002", recordedDate: Date(), recordedTime: "2:12"),
//            .init(name: "녹음_001", recordedDate: Date(), recordedTime: "1:57"),
//            .init(name: "으아앙", recordedDate: Date(), recordedTime: "3:10")
//        ])
//        
//        if fileItems.isEmpty {
//            tableBackgroundView.isHidden = false
//        } else {
//            tableBackgroundView.isHidden = true
//        }
//        recordingFileTableView.reloadData()
//    }
    
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
       
        [recordingHeaderStackView, tableBackgroundView, recordingFileTableView, notePadLabel, memoTextView].forEach {
            contentView.addSubview($0)
        }
        
        tableBackgroundView.addSubview(emptyMessageLabel)
    }
    
    func designViews() {
        tableBackgroundView.isHidden = true
        designLabel(recordingFileLabel,
                    text: "녹음 파일",
                    font: .pretendard(size: 20, weight: .bold),
                    textColor: ColorStyle.textBlack)
        
        designButton(addRecordingButton,
                     image: UIImage(named: "addOrange"))
        
        setStackView(recordingFileStackView,
                     label: recordingFileLabel,
                     button: addRecordingButton,
                     axis: .horizontal,
                     spacing: 8)
        
        designButton(showTotalRecordingButton, title: "전체보기")
        
        designLabel(emptyMessageLabel, text: "아직 녹음 파일이 없어요", font: .pretendard(size: 16, weight: .medium), textColor: ColorStyle.gray0)
        
        designLabel(notePadLabel, text: "메모장", font: .pretendard(size: 20, weight: .bold), textColor: ColorStyle.textBlack)
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
        
        var topView: UIView? = nil
        if fileURLs.isEmpty {
            topView = tableBackgroundView
        } else {
            topView = recordingFileTableView
        }
        
        tableBackgroundView.snp.makeConstraints {
            $0.top.equalTo(recordingHeaderStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(0)
        }
        contentView.bringSubviewToFront(tableBackgroundView)
        
        emptyMessageLabel.snp.makeConstraints {
            $0.centerX.equalTo(tableBackgroundView)
            $0.centerY.equalTo(tableBackgroundView)
            $0.height.equalTo(22)
        }
        
        var rowHeight = 0.13
        print("file \(fileURLs.count)개")
        switch fileURLs.count {
        case 0: rowHeight = 1
            tableBackgroundView.isHidden = false
        case 1: rowHeight = 1
        case 2: rowHeight = 2
        case 3...: rowHeight = 3
        default:
            print("오류")
        }
        recordingFileTableView.snp.makeConstraints {
            $0.top.equalTo(recordingHeaderStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(56*rowHeight)
        }
        
        notePadLabel.snp.makeConstraints {
            $0.top.equalTo(topView!.snp.bottom).offset(36)
            $0.leading.equalTo(contentView).offset(24)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(notePadLabel.snp.bottom).offset(12)
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
            $0.height.equalTo(368)
        }
    }
    
    func isEmptyRecordingFile(_ isEmpty: Bool) {
        if fileURLs.isEmpty {
            recordingFileTableView.isHidden = true
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
            button.setTitleColor(UIColor(named: "textBlack"), for: .normal)
            button.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        }
        
        if let image {
            button.setImage(image, for: .normal)
        }
    }
}

extension RecordingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fileURLs.isEmpty {
            return 0
        } else if fileURLs.count == 1{
            return 1
        } else if fileURLs.count == 2{
            return 2
        } else {
            return 3
        }
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if fileURLs.isEmpty {
//            return 0
//        } else if fileURLs.count == 1{
//            return 1
//        } else if fileURLs.count == 2{
//            return 2
//        } else {
//            return 3
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let playVC = PlayRecordViewController()
        playVC.bottomViewController.audioFile = fileURLs[indexPath.row]
        playVC.bottomViewController.initPlay1()
       // playVC.bottomViewController.audioFile = fileItems[indexPath.row].url
        //cell.setData(fileItem: fileItems[indexPath.row])
        cell.setData(fileTitle: "\(fileURLs[indexPath.row].lastPathComponent)", time: "\(playVC.bottomViewController.remainingTimeLabel.text ?? "0:00")")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}

extension RecordingRoomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Child 스크롤 좌표 - \(scrollView.contentOffset.y)")
        
        // Child 스크롤 0 이하일 때
        if scrollView.contentOffset.y < -30 {
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
            textView.textColor = ColorStyle.textBlack
        }
    }
    
    // textView에 focus를 잃는 경우 발생
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextViewPlaceholder
            textView.textColor = ColorStyle.placeholderOrange
        }
    }
}

