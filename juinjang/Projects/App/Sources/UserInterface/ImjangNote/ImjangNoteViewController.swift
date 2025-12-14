//
//  ImjangNoteViewController.swift
//  juinjang
//
//  Created by 조유진 on 12/30/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import Alamofire
import AmplitudeSwift
import RxSwift
import RxRelay

final class ImjangNoteViewController: BaseViewController,
                                      SendEditData,
                                      SendDetailEditData,
                                      ButtonStateDelegate,
                                      SendCheckListData {
    private let noteRepository = NoteRepository()
    private let disposeBag = DisposeBag()
    
    private lazy var navigationView: DefaultNavigationView = {
        return DefaultNavigationView().then {
            $0.leftItem = [.pop]
            $0.rightItem = [.text(title: "편집")]
            $0.titleSize = 18
        }
    }()
    
    private let receivedSaveTimeRelay = PublishRelay<Void>()
    
    // 스크롤뷰
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
    }
    
    // 스크롤할 컨텐트뷰
    private let contentView = UIView()
    
    // 하우스 이미지뷰
    private let noImageBackgroundView = UIImageView()
    private let photoRegisterButton = PhotoRegisterButton()
    
    private lazy var firstImage = UIImageView()
    private lazy var secondImage = UIImageView()
    private lazy var thirdImage = UIImageView()
    
    // 이미지 개수 레이블
    private var maximizeImageView = UIImageView()
    
    //이미지 배치할 스택뷰
    private var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    private var vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    private let roomNameLabel = UILabel()
    private let roomPriceLabel = UILabel()
    
    private let roomLocationIcon = UIImageView()
    private let roomAddressLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.isUserInteractionEnabled = false
    }
    private let addressStackView = UIStackView().then {
        $0.isUserInteractionEnabled = false
    }
    private let addressBackgroundView = UIButton().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
    }
    
    private let showReportLabel = UILabel()
    private let reportImageView = UIImageView()
    private let reportStackView = UIStackView()
    
    private let modifiedDateStringLabel = UILabel()
    private let modifiedDate = UILabel()
    private let modifiedDateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    private let noteDetailInfoView = ImjangNoteDetailInfoView()
    
    private let noteShareConditionView = ImjangNoteShareConditionView()
    
    private let shareCompletedButton = ShareCompletedButton()
    
    private let imageBlockView = UIView()
    
    private let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalCentering
        $0.spacing = 4
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 5
    }
    
    lazy var checkListActionButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = .inputCircleCheck.resized(toWidth: 24)
        config.attributedTitle = AttributedString("입력하기", attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 18, weight: .bold),
            .foregroundColor: UIColor.mainWhite
        ]))
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.background.backgroundColor = .main
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        $0.configuration = config
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    private lazy var recordingSegmentedVC = RecordingSegmentedViewController(imjangId: imjangId, version: versionDetail)
    
    private var completionHandler: (() -> Void)?
    private var checkListItems: [CheckListAnswer] = []
    private var existingItems = [Int: CheckListAnswer]()
    
    private lazy var images: [String] = []
    var imjangId: Int
    private var detailDto: NoteDetailModel? = nil
    private var reportDto: ReportDTO?
    var previousVCType: PreviousVCType = .createImjangVC
    var versionInfo: VersionInfo?
    private var versionDetail: Int
    private var editCriteria: Int?
    private var isEditMode: Bool = false // 수정 모드 여부
    
    private let clickPyungFloorRelay = PublishRelay<Void>()
    private let conditionEventRelay = PublishRelay<ImjangNoteShareConditionViewEventType>()
    private var roomName: String = ""
    
    private let signUpToastView = SignUpToastView()
    
    init(imjangId: Int, version: Int) {
        self.imjangId = imjangId
        self.versionDetail = version
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        setDelegate()
        addSubView()
        setConstraints()
        designViews()
        callRequest()
        setReportStackViewClick()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedChildScroll), name: NSNotification.Name("didStoppedChildScroll"), object: nil)
        recordingSegmentedVC.imjangNoteViewController = self
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("ScrollToTop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCheckListItemsUpdated(_:)), name: NSNotification.Name("CheckListItemsUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: NSNotification.Name("ChangeButtonStatus"), object: nil)
        
        if previousVCType == .createImjangVC {
            NotificationCenter.default.post(name: .refreshImjangList, object: nil)
        }
        
        clickPyungFloorRelay
            .subscribe(with: self) { (self, _) in
                let editVC = EditBasicInfoViewController()
                let editDetailVC = EditBasicInfoDetailViewController()
                if self.versionInfo?.editCriteria == 0 {
                    editVC.imjangId = self.imjangId
                    editVC.versionInfo = self.versionInfo
                    editVC.delegate = self
                    editVC.checkSaveTimeRelay = self.receivedSaveTimeRelay
                    self.navigationController?.pushViewController(editVC, animated: true)
                } else if self.versionInfo?.editCriteria == 1 {
                    editDetailVC.imjangId = self.imjangId
                    editDetailVC.versionInfo = self.versionInfo
                    editDetailVC.delegate = self
                    editDetailVC.checkSaveTimeRelay = self.receivedSaveTimeRelay
                    self.navigationController?.pushViewController(editDetailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        conditionEventRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .share:
                    // 온보딩 분기처리
                    if UserDefaultManager.shared.isOnboarding {
                        self.present(SignUpBottomSheetView(), animated: true)
                    }
                    
                    self.noteRepository.retrieveShareableNoteList(
                        param: .init(
                            sort: nil,
                            propertyType: nil,
                            priceType: nil,
                            keyword: self.roomName,
                            page: 1,
                            size: 100
                        )
                    )
                    .asObservable()
                    .map { notes in
                        notes.first(where: { $0.noteId == self.imjangId })
                    }
                    .compactMap { $0 }
                    .subscribe { model in
                        let viewController = ShareWriteViewController(
                            reactor: .init(
                                dependecy: .init(
                                    selectedModel: model,
                                    noteRepository: NoteRepository(),
                                    userRepository: UserRepository(),
                                    sharedNoteRepository: SharedNoteRepository()
                                )
                            )
                        )
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        navigationView.itemActionRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .popButtonTap:
                    self.popView()
                case .textButtonTap:
                    // 온보딩 분기처리
                    if UserDefaultManager.shared.isOnboarding {
                        self.navigationController?.present(SignUpBottomSheetView(), animated: true)
                        return
                    }
                    self.editView()
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        photoRegisterButton.rx.throttleTap
            .subscribe(with: self) { (self,_) in
                self.showImjangImageListVC()
            }
            .disposed(by: disposeBag)
        
        receivedSaveTimeRelay
            .subscribe(with: self) { (self,_) in
                self.callRequest()
            }
            .disposed(by: disposeBag)
        
        noteShareConditionView.infoButtonDidTapRelay
            .bind(with: self) { owner, _ in
                let infoPopup = NoteConditionInfoPopup()
                infoPopup.modalTransitionStyle = .crossDissolve
                infoPopup.modalPresentationStyle = .overFullScreen
                owner.present(infoPopup, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func handlePageChange(notification: Notification) {
        if let userInfo = notification.userInfo, let currentVC = userInfo["currentVC"] as? UIViewController {
            if currentVC is CheckListViewController {
                checkListActionButton.isHidden = false
            } else if currentVC is RecordingRoomViewController {
                checkListActionButton.isHidden = true
            }
        }
    }
    
    deinit {
        // Notification 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PageChanged"), object: nil)
    }
    
    
    @objc private func handleCheckListItemsUpdated(_ notification: Notification) {
        if let items = notification.object as? [CheckListAnswer] {
            self.checkListItems = items
        }
    }
    
    private func configureRoomName(name: String, purposeType: String) {
        let font = UIFont.pretendard(size: 20, weight: .extraBold)
        let attachment = NSTextAttachment()
        attachment.image = (purposeType == PurposeType.INVESTMENT.title) ? .coin : .ImjangNote.house
        attachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 20)

        let icon = NSAttributedString(attachment: attachment)

        let spacing: CGFloat = 6
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = 0
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.minimumLineHeight = 28
        paragraph.maximumLineHeight = 28

        let result = NSMutableAttributedString()
        result.append(icon)
        result.append(NSAttributedString(string: " " + name, attributes: [
            .font: font,
            .foregroundColor: UIColor.gray600
        ]))

        result.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: result.length))

        roomNameLabel.attributedText = result
        roomNameLabel.numberOfLines = 0
        roomNameLabel.lineBreakMode = .byWordWrapping
    }

    
    private func callRequest() {
        noteRepository.retrieveNoteDetail(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, detailData) in
                self.setData(detailDto: detailData)
                self.roomName = self.detailDto?.buildingName ?? ""
                self.updateConditionViewLayout(model: detailData)
            }
            .disposed(by: disposeBag)
        
        requestShareConditions()
    }
    
    private func setData(detailDto: NoteDetailModel) {
        self.navigationItem.title = detailDto.buildingName
        configureRoomName(name: detailDto.buildingName, purposeType: detailDto.purposeType)
        setPriceLabel(model: detailDto)
        
        let fullText = "눌러서 주소 입력하기"
        let underlinedText = "재입력"

        let font = UIFont.pretendard(size: 16, weight: .medium)
        let textColor = UIColor.gray400

        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: font,
            .foregroundColor: textColor
        ])

        if let range = fullText.range(of: underlinedText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        if let address = detailDto.roadAddress {
            if let addressDetail = detailDto.addressDetail {
                roomAddressLabel.text = address + " \(addressDetail)"
            } else {
                roomAddressLabel.text = address
            }
        } else {
            roomAddressLabel.text = "눌러서 주소 입력하기"
        }
        
        modifiedDate.text = detailDto.updatedAt
        images = detailDto.images
        noImageBackgroundView.image = detailDto.propertyTypeImage
        noteDetailInfoView.configure(model: detailDto, relay: clickPyungFloorRelay)
        navigationView.title = detailDto.buildingName.count > 15 ? "\(detailDto.buildingName.prefix(14))..." :
            detailDto.buildingName
        checkListActionButton.isHidden = detailDto.isShared
        photoRegisterButton.isHidden = detailDto.isShared
        imageBlockView.isHidden = !detailDto.isShared
        navigationView.rightItem = detailDto.isShared ? [] : [.text(title: "편집")]
        addressBackgroundView.isEnabled = (detailDto.roadAddress == nil)
        
        // 버전 설정
        // purposeCode (0: 부동산 투자, 1: 직접 입주)
        if detailDto.propertyType == "VILLA" || detailDto.propertyType == "OFFICE_TEL" {
            versionDetail = 0
        } else {
            versionDetail = 1
        }
        
        if detailDto.priceType == "MARGET_PRICE" {
            self.versionInfo = VersionInfo(version: versionDetail, editCriteria: 0)
        } else {
            self.versionInfo = VersionInfo(version: versionDetail, editCriteria: 1)
        }
        versionInfo?.editCriteria = detailDto.purposeType == "INVESTMENT" ? 0 : 1
        setUpImageUI()
        
        addressBackgroundView.rx.throttleTap
            .subscribe(with: self) { (self,_) in
                self.editView()
            }
            .disposed(by: disposeBag)
    }
    
    func sendData(imjangId: Int,
                  model: NoteDetailModel) {
        callRequest()
        
        NotificationCenter.default.post(name: .refreshImjangList, object: nil)
        NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
        NotificationCenter.default.post(name: .refreshSearchList, object: nil)
    }
    
    func sendDetailData(imjangId: Int, model: NoteDetailModel) {
        callRequest()
        
        NotificationCenter.default.post(name: .refreshImjangList, object: nil)
        NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
        NotificationCenter.default.post(name: .refreshSearchList, object: nil)
    }
    
    // 방 가격 설정
    private func setPriceLabel(model: NoteDetailModel) {
        if let monthlyRent = model.monthlyRent {
            // 월세 일 경우
            roomPriceLabel.text = "\(model.priceTypeToString) \(model.price.formatToKoreanCurrencyWithZero()) / \(monthlyRent.formatToKoreanCurrencyWithZero())"
        } else {
            roomPriceLabel.text = "\(model.priceTypeToString) \(model.price.formatToKoreanCurrencyWithZero())"
        }
    }
    
    // 리포트 보기 클릭 했을 때 - showReportVC 호출
    private func setReportStackViewClick() {
        reportStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showReportVC))
        reportStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showReportVC() {
        // savedCheckListItems 배열이 비어 있는지 확인
        let savedCheckListItemsAreEmpty = checkListItems.isEmpty
        if savedCheckListItemsAreEmpty {
            // 팝업창이 뜸
            let reportPopupVC = ReportPopupViewController()
            reportPopupVC.delegate = self
            reportPopupVC.modalPresentationStyle = .overCurrentContext
            present(reportPopupVC, animated: false, completion: nil)
        } else {
            let reportVC = ReportViewController(imjangId: imjangId, savedCheckListItems: checkListItems)
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    func updateButtonState(isSelected: Bool) {
        self.makeEditMode()
        checkListActionButton.isSelected = isSelected
    }
    
    // 방 사진 클릭했을 때 - showImjangImageListVC. 호출
    private func setImageStackViewClick(isEmpty: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImjangImageListVC))
        if isEmpty {
            noImageBackgroundView.addGestureRecognizer(tapGesture)
        } else {
            stackView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setUserInteraction(isEmpty: Bool) {
        stackView.isUserInteractionEnabled = !isEmpty
        vStackView.isUserInteractionEnabled = !isEmpty
        firstImage.isUserInteractionEnabled = !isEmpty
        secondImage.isUserInteractionEnabled = !isEmpty
        thirdImage.isUserInteractionEnabled = !isEmpty
        noImageBackgroundView.isUserInteractionEnabled = isEmpty 
    }
    
    // 이미지 리스트 화면으로 이동
    @objc private func showImjangImageListVC() {
        let imjangImageListVC = ImjangImageListViewController()
        imjangImageListVC.imjangId = imjangId
        imjangImageListVC.completionHandler = { imageStrings in
            self.images = imageStrings
            self.setUpImageUI()
            NotificationCenter.default.post(name: .refreshImjangList, object: nil)
            NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
        }
        navigationController?.pushViewController(imjangImageListVC, animated: true)
    }
    
    @objc private func didStoppedChildScroll() {
        scrollView.isScrollEnabled = true
        let containerY = containerView.frame.origin.y
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset.y = containerY - 21
        }
    }
    
    private func setDelegate() {
        scrollView.delegate = self
    }
    
    // 뒤로가기 버튼 클릭했을 때
    @objc private func popView() {
        switch previousVCType {
        case .createImjangVC:
            changeImjangListVC()
        case .imjangList, .main:
            navigationController?.popViewController(animated: true)
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            switch previousVCType {
            case .createImjangVC:
                amplitude.track(event: BaseEvent(eventType: AmpliEventName.page_viewed.rawValue, eventProperties: [
                    AmpliEventProp.checklist_page.rawValue: "false"
                ]))
                changeImjangListVC()
            default: break
            }
        }
    }
    
    @objc private func editView() {
        let editVC = EditBasicInfoViewController()
        let editDetailVC = EditBasicInfoDetailViewController()
        if versionInfo?.editCriteria == 0 {
            editVC.imjangId = imjangId
            editVC.versionInfo = versionInfo
            editVC.delegate = self
            self.navigationController?.pushViewController(editVC, animated: true)
        } else if versionInfo?.editCriteria == 1 {
            editDetailVC.imjangId = imjangId
            editDetailVC.versionInfo = versionInfo
            editDetailVC.delegate = self
            self.navigationController?.pushViewController(editDetailVC, animated: true)
        }
    }
    
    // MARK: - addSubView()
    private func addSubView() {
        [navigationView,
         scrollView,
         checkListActionButton
        ].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [roomNameLabel,
         roomPriceLabel,
         noteDetailInfoView,
         noteShareConditionView,
         shareCompletedButton,
         infoStackView,
         addressBackgroundView,
         containerView,
         noImageBackgroundView,
         stackView,
         imageBlockView].forEach {
            contentView.addSubview($0)
        }
        
        noImageBackgroundView.addSubview(photoRegisterButton)
        addressBackgroundView.addSubview(addressStackView)
        
        [showReportLabel, reportImageView].forEach {
            reportStackView.addArrangedSubview($0)
        }
        
        [modifiedDateStringLabel, modifiedDate].forEach {
            modifiedDateStackView.addArrangedSubview($0)
        }
        
        [modifiedDateStackView, reportStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        addChild(recordingSegmentedVC)
        containerView.addSubview(recordingSegmentedVC.view)
        recordingSegmentedVC.imjangId = imjangId
        
        // 온보딩 분기 처리
        if UserDefaultManager.shared.isOnboarding {
            photoRegisterButton.removeFromSuperview()
            checkListActionButton.removeFromSuperview()
            view.addSubview(signUpToastView)
        }
    }
    
    // 뷰들 디자인
    private func designViews() {
        designImageView(maximizeImageView, image: UIImage.ImjangNote.maximize, contentMode: .scaleAspectFit)
        
        // 방 이미지뷰 설정
        setRoomImages()
        
        // 방 가격 레이블
        designLabel(roomPriceLabel,
                    font: UIFont.pretendard(size: 20, weight: .semiBold),
                    textColor: .gray450)
        
        // 방 주소 레이블
        designLabel(roomAddressLabel,
                    font: UIFont.pretendard(size: 16, weight: .medium),
                    textColor: .gray400, numberOfLines: 2)
        designImageView(roomLocationIcon,
                        image: UIImage.location1.withRenderingMode(.alwaysOriginal),
                        contentMode: .scaleAspectFit)
        
        setStackView(addressStackView,
                     label: roomAddressLabel,
                     image: roomLocationIcon,
                     axis: .horizontal,
                     distribution: .fill,
                     spacing: 12,
                     isImageRight: false)
        
        // 리포트 보기 레이블
        designLabel(showReportLabel, text: "리포트 보기",
                    alignment: .left,
                    font: UIFont.pretendard(size: 14, weight: .bold),
                    textColor: .gray500)
        
        // 리포트 이미지뷰
        designImageView(reportImageView,
                        image: UIImage.ImjangNote.report,
                        contentMode: .scaleAspectFit)
        
        // 리포트 보기 스택뷰
        setStackView(reportStackView,
                     label: showReportLabel,
                     image: reportImageView,
                     axis: .horizontal,
                     spacing: 4,
                     isImageRight: true)
        
        // 최근 수정날짜 레이블
        designLabel(modifiedDateStringLabel,
                    text: "최근 수정날짜",
                    font: UIFont.pretendard(size: 14, weight: .medium),
                    textColor: .gray300)
        
        // 최근 수정날짜값 레이블
        designLabel(modifiedDate,
                    font: UIFont.pretendard(size: 14, weight: .medium),
                    textColor: .gray300)
    }
    
    // 이미지 개수에 따라 stackView 설정
    private func setUpImageUI() {
        noImageBackgroundView.isHidden = true
        stackView.isHidden = false
        maximizeImageView.isHidden = false
        setUserInteraction(isEmpty: false)
        setImageStackViewClick(isEmpty: false)
        let imageCount = images.count
        switch imageCount {
        case 0:
            noImageBackgroundView.isHidden = false
            stackView.isHidden = true
            maximizeImageView.isHidden = true
            setUserInteraction(isEmpty: true)
            setImageStackViewClick(isEmpty: true)
        case 1:
            setImage1()
        case 2:
            setImage2()
        case 3...:
            setImage3()
        default:
            print("오류")
        }
    }
    
    private func setImage1() {
        let imageWidth = view.frame.width - (24*2)
        stackView.spacing = 0
        
        firstImage.snp.remakeConstraints {
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(firstImage.snp.width).multipliedBy(171.0 / 342.0)
        }
        
        if let image = images.first, let url = URL(string: image) {
            firstImage.kf.setImage(with: url, placeholder: UIImage(named: "1"))
        }
    }
    
    private func setImage2() {
        //        let imagesWidth = view.frame.width - (24*2) - 8
        stackView.spacing = 8
        vStackView.spacing = 0
        
        firstImage.snp.remakeConstraints {
            $0.height.equalTo(firstImage.snp.width).multipliedBy(171.0 / 225.0)
        }
        
        secondImage.snp.remakeConstraints {
            $0.height.equalTo(secondImage.snp.width).multipliedBy(171.0 / 109.0)
        }
        
        if let image1 = images.first, let url1 = URL(string: image1) {
            firstImage.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
        }
        
        if let url2 = URL(string: images[1]) {
            secondImage.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
        }
    }
    
    private func setImage3() {
        stackView.spacing = 8
        vStackView.spacing = 8
        
        firstImage.snp.remakeConstraints {
            $0.height.equalTo(firstImage.snp.width).multipliedBy(171.0 / 225.0)
        }
        
        secondImage.snp.remakeConstraints {
            $0.height.equalTo(secondImage.snp.width).multipliedBy(89.0 / 109.0)
        }
        
        thirdImage.snp.remakeConstraints {
            $0.height.equalTo(thirdImage.snp.width).multipliedBy(74.0 / 109.0)
        }
        
        if let image1 = images.first, let url1 = URL(string: image1) {
            firstImage.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
        }
        if let url2 = URL(string: images[1]) {
            secondImage.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
        }
        if let url3 = URL(string: images[2]) {
            thirdImage.kf.setImage(with: url3, placeholder: UIImage(named: "3"))
        }
    }
    
    // 이미지 없을 때 배경
    private func setImageViewConstraints() {
        let imagesWidth = view.frame.width - (24*2)
        noImageBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(8)
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
            $0.width.equalTo(imagesWidth)
            $0.height.equalTo(noImageBackgroundView.snp.width).multipliedBy(171.0 / 342.0)
        }
        
        // 온보딩 분기처리
        if !UserDefaultManager.shared.isOnboarding {
            photoRegisterButton.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-9)
                $0.trailing.equalToSuperview().offset(-10)
                $0.height.equalTo(27)
                $0.width.equalTo(94)
            }
        }
    }
    
    // constraints 설정
    private func setConstraints() {
        
        var topView: UIView? = nil
        if images.isEmpty {
            topView = noImageBackgroundView
        } else {
            topView = stackView
        }
        
        [firstImage,vStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [secondImage, thirdImage].forEach {
            vStackView.addArrangedSubview($0)
        }
        
        stackView.addSubview(maximizeImageView)
        maximizeImageView.snp.makeConstraints {
            $0.bottom.trailing.equalTo(stackView).inset(12)
            $0.width.height.equalTo(24)
        }
        
        if !UserDefaultManager.shared.isOnboarding {
            checkListActionButton.snp.makeConstraints {
                $0.bottom.equalTo(view.snp.bottom).offset(-28)
                $0.trailing.equalTo(view.snp.trailing).offset(-24)
                $0.height.equalTo(48)
            }
            
            view.bringSubviewToFront(checkListActionButton)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 스크롤뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(4)
        }
        
        // 컨텐트뷰
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(view).multipliedBy(5.6)
        }
        
        setImageViewConstraints()
        
        contentView.bringSubviewToFront(stackView)
        // 방 이미지 스택뷰
        stackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(8)
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
        }
        
        imageBlockView.snp.makeConstraints {
            $0.edges.equalTo(noImageBackgroundView.snp.edges)
        }
        
        // 방 이름 스택뷰
        roomNameLabel.snp.makeConstraints {
            $0.leading.equalTo(topView!.snp.leading)
            $0.trailing.equalTo(topView!.snp.trailing)
            $0.top.equalTo(topView!.snp.bottom).offset(12)
        }
        
        // 방 가격 레이블
        roomPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(topView!.snp.leading)
            $0.top.equalTo(roomNameLabel.snp.bottom).offset(6)
        }
        
        addressBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(topView!.snp.leading)
            $0.trailing.equalTo(topView!.snp.trailing)
            $0.top.equalTo(roomPriceLabel.snp.bottom).offset(6)
        }
        
        addressStackView.snp.makeConstraints {
            $0.leading.equalTo(addressBackgroundView.snp.leading).offset(12)
            $0.trailing.equalTo(addressBackgroundView.snp.trailing).offset(-12)
            $0.top.equalTo(addressBackgroundView.snp.top).offset(8)
            $0.bottom.equalTo(addressBackgroundView.snp.bottom).offset(-8)
        }
        
        roomLocationIcon.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        // MARK: - 노트 디테일 뷰
        noteDetailInfoView.snp.makeConstraints {
            $0.top.equalTo(addressBackgroundView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(161)
        }
    
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(noImageBackgroundView.snp.leading)
            $0.trailing.equalTo(noImageBackgroundView.snp.trailing)
            $0.top.equalTo(noteDetailInfoView.snp.bottom).offset(12)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-24)
        }
        
        recordingSegmentedVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        recordingSegmentedVC.didMove(toParent: self)
        
        contentView.bringSubviewToFront(imageBlockView)
        
        if UserDefaultManager.shared.isOnboarding {
            signUpToastView.snp.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.horizontalEdges.equalToSuperview().inset(17)
                $0.height.equalTo(52)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // 스택뷰 설정
    private func setStackView(_ stackView: UIStackView,
                              label: UILabel,
                              image: UIImageView,
                              axis: NSLayoutConstraint.Axis,
                              distribution: UIStackView.Distribution = .equalSpacing,
                              spacing: CGFloat,
                              isImageRight: Bool){
        
        stackView.axis = axis
        stackView.alignment = .center
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        if isImageRight {
            [label, image].forEach {
                stackView.addArrangedSubview($0)
            }
        } else {
            [image, label].forEach {
                stackView.addArrangedSubview($0)
            }
        }
    }
    
    // 방 이미지뷰 설정
    private func setRoomImages() {
        let imageViews = [firstImage, secondImage, thirdImage]
        for index in 1...imageViews.count {
            designImageView(imageViews[index-1], image: nil, contentMode: .scaleAspectFill, cornerRadius: 5)
        }
    }
    
    // 이미지뷰 디자인
    private func designImageView(_ imageView: UIImageView, image: UIImage?, contentMode: UIView.ContentMode, cornerRadius: CGFloat? = nil) {
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        
        if let cornerRadius {
            imageView.layer.cornerRadius = cornerRadius
        }
    }
    
    // 레이블 디자인
    private func designLabel(_ label: UILabel, text: String = "", alignment: NSTextAlignment = .left, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        label.text = text
        label.textAlignment = alignment
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
    }
    
    // MARK: - API 요청
    private func saveAnswer(completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        noteRepository.retrieveCheckList(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, checkListResponse) in
                var savedQuestionIds = Set<Int>()
                var uniqueItems = [CheckListAnswer]()
                
                // 서버에서 불러온 questionId 목록
                for item in checkListResponse {
                    self.existingItems[item.questionId] = CheckListAnswer(
                        imjangId: self.imjangId,
                        questionId: item.questionId,
                        answer: item.answer,
                        isSelected: true
                    )
                }
                
                // 최근에 추가된 항목만 유지하고 중복된 항목 제거
                for item in self.checkListItems {
                    if !savedQuestionIds.contains(item.questionId) {
                        savedQuestionIds.insert(item.questionId)
                        uniqueItems.append(.init(imjangId: self.imjangId,
                                                 questionId: item.questionId,
                                                 answer: item.answer,
                                                 isSelected: true)) // 중복 제거 후 새로운 값 추가
                    } else if let index = uniqueItems.firstIndex(where: { $0.questionId == item.questionId }) {
                        uniqueItems[index] = .init(imjangId: self.imjangId,
                                                   questionId: item.questionId,
                                                   answer: item.answer,
                                                   isSelected: true) // 기존의 항목이 있다면 새로운 값으로 변경
                    }
                }
                
                self.checkListItems = uniqueItems
                
                // 유효한 값만 필터링
                let validCheckListItems = self.checkListItems.filter { item in
                    if let answer = item.answer as? String {
                        return !answer.isEmpty && answer != "NaN"
                    } else {
                        return item.answer != nil // 문자열이 아니라면 값이 존재하는지 확인
                    }
                }
                
                print("----- 체크리스트 저장할 항목 -----")
                for checkListItem in validCheckListItems {
                    print(checkListItem)
                }
                
                if self.existingItems.isEmpty {
                    self.saveChecklist(
                        items: validCheckListItems.map {
                            .init(
                                imjangId: self.imjangId,
                                questionId: $0.questionId,
                                answer: $0.answer,
                                isSelected: true
                            )
                        },
                        completion: completion
                    )
                } else {
                    self.modifyChecklist(items: validCheckListItems.map {
                        .init(
                            imjangId: self.imjangId,
                            questionId: $0.questionId,
                            answer: $0.answer,
                            isSelected: true
                        )
                    }, completion: completion)
                }
                
                amplitude.track(
                    event: BaseEvent(eventType: AmpliEventName.button_clicked.rawValue,
                                     eventProperties: [
                    AmpliEventProp.floating_button.rawValue: "true"
                ]))
                
            }
            .disposed(by: disposeBag)
    }
    
    // 체크리스트 저장
    private func saveChecklist(items: [CheckListAnswer],
                               completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        self.requestChecklist(items: items, completion: completion)
    }
    
    // 체크리스트 수정
    private func modifyChecklist(items: [CheckListAnswer],
                                 completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        self.requestChecklist(items: items, completion: completion)
    }
    
    // 체크리스트 API
    private func requestChecklist(items: [CheckListAnswer],
                                  completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        guard !items.isEmpty else {
            print("값이 선택되지 않았습니다.")
            completion(nil, nil)
            return
        }
        
        noteRepository.createCheckList(
            noteID: imjangId,
            params: items.map {
                CheckListRequestDto(questionId: $0.questionId, answer: $0.answer)
            }
        )
        .asObservable()
        .subscribe(
            with: self,
            onNext: { (self, response) in
                completion(response.reportDto.limjangDto, response.reportDto.reportDTO)
                
                NotificationCenter.default.post(name: .refreshImjangList, object: nil)
                NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
                NotificationCenter.default.post(name: .refreshSearchList, object: nil)
                
                self.requestShareConditions()
            },
            onError: { (self, error) in
                completion(nil,nil)
            })
        .disposed(by: disposeBag)
    }
    
    // 수정 버튼 클릭
    @objc private func editButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isEditMode.toggle()
        if sender.isSelected {
            self.makeEditMode()
            
            NotificationCenter.default.post(name: Notification.Name("EditModeChanged"), object: true)
        } else {
            self.makeDefaultMode()
            NotificationCenter.default.post(name: Notification.Name("EditModeChanged"), object: false)
            
            saveAnswer { [weak self] detailDto, reportDto in
                guard let self = self else { return }
                
                if let detailDto = detailDto, let reportDto = reportDto {
                    if existingItems.isEmpty {
                        let reportVC = ReportViewController(imjangId: detailDto.limjangId, savedCheckListItems: checkListItems)
                        reportVC.checkListDatadelegate = self
                        reportVC.setData(detailDto: detailDto)
                        reportVC.setData(reportDto: reportDto)
                        self.navigationController?.pushViewController(reportVC, animated: true)
                    }
                } else {
                    print("체크리스트 값이 입력되지 않았습니다.")
                    makeDefaultMode()
                    NotificationCenter.default.post(name: Notification.Name("EditModeChanged"), object: false)
                }
                
            }
        }
    }
    
    func sendData(savedCheckListItems: [CheckListAnswer]) {
        self.checkListItems = savedCheckListItems
    }
    
    // 스크롤 가장 위로 가게
    @objc private func scrollToTop() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    private func updateConditionViewLayout(model: NoteDetailModel) {
        // MARK: - 공유 조건 뷰
        // 평층 입력 X -> 공유 조건 뷰 X
        if model.pyong != nil && model.floor != nil {
            if model.isShared {
                shareCompletedButton.snp.remakeConstraints {
                    $0.top.equalTo(infoStackView.snp.bottom).offset(16)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(68)
                }
                
                // containerView
                containerView.snp.remakeConstraints {
                    $0.top.equalTo(shareCompletedButton.snp.bottom).offset(12)
                    $0.leading.trailing.equalTo(contentView)
                    $0.bottom.equalTo(contentView).offset(-24)
                }
            } else {
                noteShareConditionView.snp.remakeConstraints {
                    $0.top.equalTo(infoStackView.snp.bottom).offset(16)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(106)
                }
                
                // containerView
                containerView.snp.remakeConstraints {
                    $0.top.equalTo(noteShareConditionView.snp.bottom).offset(12)
                    $0.leading.trailing.equalTo(contentView)
                    $0.bottom.equalTo(contentView).offset(-24)
                }
            }
        }
    }
    
    private func requestShareConditions() {
        noteRepository.retrieveChecklistConditionList(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, conditionDTO) in
                self.noteShareConditionView.configure(model: conditionDTO, relay: self.conditionEventRelay)
            }
            .disposed(by: disposeBag)
    }
    
    private func makeEditMode() {
        checkListActionButton.configuration?.image = .completedCircleCheck.resized(toWidth: 24)
        checkListActionButton.configuration?.attributedTitle = AttributedString("입력 완료", attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 18, weight: .bold),
            .foregroundColor: UIColor.mainWhite
        ]))
        checkListActionButton.configuration?.background.backgroundColor = .gray500
    }
    
    private func makeDefaultMode() {
        checkListActionButton.configuration?.image = .inputCircleCheck.resized(toWidth: 24)
        checkListActionButton.configuration?.attributedTitle = AttributedString("입력하기", attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 18, weight: .bold),
            .foregroundColor: UIColor.mainWhite
        ]))
        checkListActionButton.configuration?.background.backgroundColor = .main
    }
}

extension ImjangNoteViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let containerY = containerView.frame.origin.y
        
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > containerY - 10 {
            scrollView.isScrollEnabled = false
            scrollView.contentOffset.y = containerY
            NotificationCenter.default.post(name: NSNotification.Name("didStoppedParentScroll"), object: nil)
        }
    }
}

