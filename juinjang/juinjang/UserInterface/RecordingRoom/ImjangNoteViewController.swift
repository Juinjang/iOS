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

final class ImjangNoteViewController: BaseViewController,
                                SendEditData,
                                SendDetailEditData,
                                ButtonStateDelegate,
                                SendCheckListData {
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .mainWhite
        $0.showsVerticalScrollIndicator = false
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    // 하우스 이미지뷰
    let noImageBackgroundView = UIView().then {
        $0.backgroundColor = .stroke2
        $0.layer.cornerRadius = 5
    }
    let noImageIcon = UIImageView().then {
        $0.image = ImageStyle.galleryAdd
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var firstImage = UIImageView()
    lazy var secondImage = UIImageView()
    lazy var thirdImage = UIImageView()
    
    // 이미지 개수 레이블
    var maximizeImageView = UIImageView()
    
    //이미지 배치할 스택뷰
    var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    var vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    let roomNameLabel = UILabel()
    
    let houseImageView = UIImageView()
    let roomStackView = UIStackView()
    let roomPriceLabel = UILabel()
    
    let roomLocationIcon = UIImageView()
    let roomAddressLabel = UILabel()
    let addressStackView = UIStackView()
    let addressBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10
    }
    
    let showReportLabel = UILabel()
    let reportImageView = UIImageView()
    let reportStackView = UIStackView()
    
    let modifiedDateStringLabel = UILabel()
    let modifiedDate = UILabel()
    let modifiedDateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalCentering
        $0.spacing = 4
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 5
    }
    
    let upButton = UIButton().then {
        $0.setImage(ImageStyle.floating, for: .normal)
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit-button"), for: .normal)
        $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.13).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 1
        $0.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var recordingSegmentedVC = RecordingSegmentedViewController(imjangId: imjangId, version: versionDetail)
    

    var completionHandler: (() -> Void)?
    
    
    var checkListItems: [CheckListAnswer] = []
    var existingItems = [Int: CheckListAnswer]()
    
    lazy var images: [String] = []
    var imjangId: Int
    var detailDto: DetailDto? = nil
    var reportDto: ReportDTO?
    var previousVCType: PreviousVCType = .createImjangVC
    var versionInfo: VersionInfo?
    var versionDetail: Int
    var editCriteria: Int?
    var isEditMode: Bool = false // 수정 모드 여부
    
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
        designNavigationBar()
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
    }
    
    @objc private func handlePageChange(notification: Notification) {
        if let userInfo = notification.userInfo, let currentVC = userInfo["currentVC"] as? UIViewController {
            if currentVC is CheckListViewController {
                editButton.isHidden = false
            } else if currentVC is RecordingRoomViewController {
                editButton.isHidden = true
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

    
    private func callRequest() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if error == nil {
                guard let result = detailDto else { return }
                if let detailDto = result.result {
                    self.setData(detailDto: detailDto)
                }
            } else {
                guard let error else { return }
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
    
    private func setData(detailDto: DetailDto) {
        self.navigationItem.title = detailDto.nickname
        roomNameLabel.text = detailDto.nickname
        let priceTypeString: String
        switch detailDto.priceType {
        case 0:
            priceTypeString = "매매"
        case 1:
            priceTypeString = "전세"
        case 2:
            priceTypeString = "월세"
        case 3:
            priceTypeString = "실거래가"
        default:
            priceTypeString = "" // 값이 없을 경우 공백 처리
        }
        setPriceLabel(priceList: detailDto.priceList, priceType: priceTypeString)
        if let addressDetail = detailDto.addressDetail {
            roomAddressLabel.text = "\(detailDto.address) \(detailDto.addressDetail ?? "")"
        } else {
            roomAddressLabel.text = "\(detailDto.address)"
        }
        modifiedDate.text = "\(String.dateToString(target: detailDto.updatedAt))"
        images = detailDto.images
        
        // 버전 설정
        let checkListVersion = detailDto.checkListVersion
        // purposeCode (0: 부동산 투자, 1: 직접 입주)
        if checkListVersion == "LIMJANG" {
            versionDetail = 0
        } else if checkListVersion == "NON_LIMJANG" {
            versionDetail = 1
        }
        if detailDto.purposeCode == 0 {
            self.versionInfo = VersionInfo(version: versionDetail, editCriteria: 0)
        } else if detailDto.purposeCode == 1 {
            self.versionInfo = VersionInfo(version: versionDetail, editCriteria: 1)
        }
        versionInfo?.editCriteria = detailDto.purposeCode
        setUpImageUI()
        adjustLabelHeight()
    }
    
    func sendData(imjangId: Int, priceList: [String], address: String, addressDetail: String?, nickname: String, updatedAt: String) {
        self.navigationItem.title = nickname
        roomNameLabel.text = nickname
        setPriceLabel(priceList: priceList, priceType: "")
        if let addressDetail = addressDetail {
            roomAddressLabel.text = "\(address) \(addressDetail)"
        } else {
            roomAddressLabel.text = address
        }
        modifiedDate.text = updatedAt
        
        NotificationCenter.default.post(name: .refreshImjangList, object: nil)
        NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
        NotificationCenter.default.post(name: .refreshSearchList, object: nil)
    }
    
    func sendDetailData(imjangId: Int, priceType: Int, priceList: [String], address: String, addressDetail: String?, nickname: String, updatedAt: String) {
        self.navigationItem.title = nickname
        roomNameLabel.text = nickname
        let priceTypeString: String
        switch priceType {
        case 0:
            priceTypeString = "매매"
        case 1:
            priceTypeString = "전세"
        case 2:
            priceTypeString = "월세"
        default:
            priceTypeString = "" // 값이 없을 경우 공백 처리
        }
        setPriceLabel(priceList: priceList, priceType: priceTypeString)
        if let addressDetail = addressDetail {
            roomAddressLabel.text = "\(address) \(addressDetail)"
        } else {
            roomAddressLabel.text = address
        }
        modifiedDate.text = updatedAt
        
        NotificationCenter.default.post(name: .refreshImjangList, object: nil)
        NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
        NotificationCenter.default.post(name: .refreshSearchList, object: nil)
    }
    
    private func adjustLabelHeight() {
        let maxSize = CGSize(width: addressBackgroundView.bounds.width - 30, height: CGFloat.greatestFiniteMagnitude) // 여백 고려
        let expectedSize = roomAddressLabel.sizeThatFits(maxSize)
        
        // 텍스트 길이에 따라 조건적으로 높이 업데이트
        roomAddressLabel.snp.updateConstraints { make in
            if expectedSize.height > 30 { // someThreshold는 조건에 맞는 텍스트 높이입니다.
                make.height.equalTo(42) // 텍스트 높이의 2배로 설정
            } else {
                make.height.equalTo(21) // 예상된 텍스트 높이로 설정
            }
        }
    }
    
    // 방 가격 설정
    private func setPriceLabel(priceList: [String], priceType: String) {
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            print(priceString.formatToKoreanCurrencyWithZero())
            if priceType.isEmpty {
                roomPriceLabel.text = priceString.formatToKoreanCurrencyWithZero()
            } else {
                roomPriceLabel.text = "\(priceType) \(priceString.formatToKoreanCurrencyWithZero())"
            }
        case 2:
            let priceString1 = priceList[0].formatToKoreanCurrencyWithZero()
            let priceString2 = priceList[1].oneSplitAmount()
            let formattedPriceString2 = priceString2.addingCommas()
            roomPriceLabel.text = "\(priceType) \(priceString1) / \(formattedPriceString2)"

        default:
            roomPriceLabel.text = "편집을 통해 가격을 설정해주세요."
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
        editButton.setImage(UIImage(named: "completed-button"), for: .normal)
        editButton.isSelected = isSelected
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
        stackView.isUserInteractionEnabled = isEmpty ? false : true
        vStackView.isUserInteractionEnabled = isEmpty ? false : true
        firstImage.isUserInteractionEnabled = isEmpty ? false : true
        secondImage.isUserInteractionEnabled = isEmpty ? false : true
        thirdImage.isUserInteractionEnabled = isEmpty ? false : true
        noImageBackgroundView.isUserInteractionEnabled = isEmpty ? true : false
    }
        
    // 이미지 리스트 화면으로 이동
    @objc private func showImjangImageListVC() {
        //        guard let imjangId = imjangId else { return }
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
    
    @objc private func upToTop() {
        UIView.animate(withDuration: 0.5) {
            self.scrollView.contentOffset.y = 0
        }
    }
    
    private func setDelegate() {
        scrollView.delegate = self
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationItem.title = ""     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        
        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
        let editButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editView))
        backButtonItem.tintColor = .gray400
        editButtonItem.tintColor = .gray400
        
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // 뒤로가기 버튼 클릭했을 때
    @objc private func popView() {
        switch previousVCType {
        case .createImjangVC:
            amplitude.track(event: BaseEvent(eventType: AmpliEventName.page_viewed.rawValue, eventProperties: [
                AmpliEventProp.checklist_page.rawValue: "false"
            ]))
            changeImjangListVC()
        case .imjangList, .main:
            navigationController?.popViewController(animated: true)
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right { // 뒤로가기
            switch previousVCType {
            case .createImjangVC:
                amplitude.track(event: BaseEvent(eventType: AmpliEventName.page_viewed.rawValue, eventProperties: [
                    AmpliEventProp.checklist_page.rawValue: "false"
                ]))
                changeImjangListVC()
            case .imjangList, .main:
                navigationController?.popViewController(animated: true)
            default:
                navigationController?.popViewController(animated: true)
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
        [scrollView, editButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [roomStackView, roomPriceLabel, infoStackView, addressBackgroundView, containerView, noImageBackgroundView, stackView].forEach {
            contentView.addSubview($0)
        }
        
        noImageBackgroundView.addSubview(noImageIcon)
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
    }
    
    // 뷰들 디자인
    private func designViews() {
//        upButton.alpha = 0
        designImageView(maximizeImageView, image: UIImage(named: "maximize"), contentMode: .scaleAspectFit)
        
        // 방 이미지뷰 설정
        setRoomImages()
        
        // 집 아이콘 이미지뷰
        designImageView(houseImageView,
                        image: ImageStyle.house,
                        contentMode: .scaleAspectFit)
        
        // 방 이름 레이블
        designLabel(roomNameLabel,
                    alignment: .left,
                    font: UIFont.pretendard(size: 20, weight: .extraBold),
                    textColor: .main)
        
        // 방 이름 스택뷰
        setStackView(roomStackView,
                     label: roomNameLabel,
                     image: houseImageView,
                     axis: .horizontal,
                     spacing: 6,
                     isImageRight: true)
        
        // 방 가격 레이블
        designLabel(roomPriceLabel,
                    font: UIFont.pretendard(size: 20, weight: .semiBold),
                    textColor: .gray450)
        
        // 방 주소 레이블
        designLabel(roomAddressLabel,
                    font: UIFont.pretendard(size: 16, weight: .medium),
                    textColor: .gray400, numberOfLines: 2)
        designImageView(roomLocationIcon,
                        image: UIImage(named: "location"),
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
                        image: UIImage(named: "report"),
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
                    font: UIFont.pretendard(size: 14, weight: .semiBold),
                    textColor: .gray400)
        
        // 최근 수정날짜값 레이블
        designLabel(modifiedDate,
                    font: UIFont.pretendard(size: 14, weight: .semiBold),
                    textColor: .gray400)
        
        
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
        
        noImageIcon.snp.makeConstraints {
            $0.centerX.equalTo(noImageBackgroundView)
            $0.centerY.equalTo(noImageBackgroundView)
            $0.height.equalTo(71)
            $0.width.equalTo(71)
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
        
        editButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-28)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        view.bringSubviewToFront(editButton)
        
        // 스크롤뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        // 하우스 아이콘 크기 설정
        houseImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        // 방 이름 스택뷰
        roomStackView.snp.makeConstraints {
            $0.leading.equalTo(topView!.snp.leading)
            $0.top.equalTo(topView!.snp.bottom).offset(12)
        }
        
        // 방 가격 레이블
        roomPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(topView!.snp.leading)
            $0.top.equalTo(roomStackView.snp.bottom).offset(6)
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
        
        
        // 위치 아이콘
        roomLocationIcon.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        // info 스택뷰
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(noImageBackgroundView.snp.leading)
            $0.trailing.equalTo(noImageBackgroundView.snp.trailing)
            $0.top.equalTo(addressBackgroundView.snp.bottom).offset(24)
        }
        
        // containerView
        containerView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-24)
            //            $0.height.equalTo(view).multipliedBy(1.5)
            //            $0.height.equalTo(view).multipliedBy(5) // 체크리스트 뷰 컨트롤러에서는 변경될 수 있게 적절한 값으로 설정 필요
        }
        
        recordingSegmentedVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        recordingSegmentedVC.didMove(toParent: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // 스택뷰 설정
    private func setStackView(_ stackView: UIStackView, label: UILabel, image: UIImageView, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .equalSpacing,spacing: CGFloat, isImageRight: Bool){
        
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
        
        if cornerRadius != nil {
            imageView.layer.cornerRadius = cornerRadius!
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
        let token = UserDefaultManager.shared.accessToken
        print("토큰값 \(token)")

        // 저장된 체크리스트 불러오기
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[QuestionAnswerDto]>.self, api: .showChecklist(imjangId: imjangId)) { [weak self] response, error in
            guard let self = self else { return }
            guard let checkListResponse = response else { return }
            
            var savedQuestionIds = Set<Int>()
            var uniqueItems = [CheckListAnswer]()
            
            // 서버에서 불러온 questionId 목록
            if let categoryItem = checkListResponse.result {
                for item in categoryItem {
                    existingItems[item.questionId] = CheckListAnswer(imjangId: imjangId, questionId: item.questionId, answer: item.answer, isSelected: true)
                }
            }
            
            // 최근에 추가된 항목만 유지하고 중복된 항목 제거
            for item in checkListItems {
                if !savedQuestionIds.contains(item.questionId) {
                    savedQuestionIds.insert(item.questionId)
                    uniqueItems.append(item) // 중복 제거 후 새로운 값 추가
                } else if let index = uniqueItems.firstIndex(where: { $0.questionId == item.questionId }) {
                    uniqueItems[index] = item // 기존의 항목이 있다면 새로운 값으로 변경
                }
            }
            
            self.checkListItems = uniqueItems
            
            // 유효한 값만 필터링
            let validCheckListItems = checkListItems.filter { item in
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
            
            if existingItems.isEmpty {
                saveChecklist(items: validCheckListItems, token: token, completion: completion)
            } else {
                modifyChecklist(items: validCheckListItems, token: token, completion: completion)
            }
            
            amplitude.track(event: BaseEvent(eventType: AmpliEventName.button_clicked.rawValue, eventProperties: [
                AmpliEventProp.floating_button.rawValue: "true"
            ]))
        }
    }
    
    
    // 체크리스트 저장
    private func saveChecklist(items: [CheckListAnswer], token: String, completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        self.requestChecklist(with: .post, items: items, action: "create", token: token, completion: completion)
    }

    // 체크리스트 수정
    private func modifyChecklist(items: [CheckListAnswer], token: String, completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        self.requestChecklist(with: .post, items: items, action: "update", token: token, completion: completion)
    }
    
    // 체크리스트 API
    private func requestChecklist(with method: HTTPMethod,
                                  items: [CheckListAnswer],
                                  action: String,
                                  token: String,
                                  completion: @escaping (DetailDto?, ReportDTO?) -> Void) {
        guard !items.isEmpty else {
            print("값이 선택되지 않았습니다.")
            completion(nil, nil)
            return
        }
        
        let parameters = items.map { item -> [String: Any?] in
            var answerValue: Any? = item.answer
            if let answer = item.answer as? String, answer == "NaN" || answer.isEmpty {
                answerValue = NSNull()
            }
            return [
                "action": action,
                "questionId": item.questionId,
                "answer": answerValue
            ]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Data: \(jsonString)")
            }

            var request: URLRequest
            let api = JuinjangAPI.saveChecklist(imjangId: imjangId)
            request = URLRequest(url: api.endpoint)
            request.httpMethod = api.method.rawValue
            request.headers = api.header
            request.httpBody = jsonData
            
            AF.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("체크리스트 \(action == "create" ? "저장" : "수정") 처리 성공")
                        print(value)
                        
                        if let json = value as? [String: Any],
                           let result = json["result"] as? [String: Any],
                           let reportData = result["reportDto"] as? [String: Any],
                           let limjangData = reportData["limjangDto"] as? [String: Any],
                           let reportDTOData = reportData["reportDTO"] as? [String: Any] {
                            let reportDto = self.createReportDTO(from: reportData)
                            let detailDto = self.createDetailDto(from: reportData)
                            completion(detailDto, reportDto)
                            NotificationCenter.default.post(name: .refreshImjangList, object: nil)
                            NotificationCenter.default.post(name: .refreshMainImjang, object: nil)
                            NotificationCenter.default.post(name: .refreshSearchList, object: nil)
                        }
                    case .failure(let error):
                        print("체크리스트 \(action == "create" ? "저장" : "수정") 처리 실패")
                        if let data = response.data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            print("서버 응답 에러 메시지: \(errorMessage)")
                        } else {
                            print("에러: \(error.localizedDescription)")
                        }
                        completion(nil, nil)
                    }
                }
        } catch {
            print("encoding 에러: \(error)")
            completion(nil, nil)
        }
    }
    
    private func createReportDTO(from data: [String: Any]) -> ReportDTO {
        let reportDTOData = data["reportDTO"] as? [String: Any] ?? [:]
        return ReportDTO(
            reportId: reportDTOData["reportId"] as? Int ?? 0,
            indoorKeyWord: reportDTOData["indoorKeyWord"] as? String ?? "",
            publicSpaceKeyWord: reportDTOData["publicSpaceKeyWord"] as? String ?? "",
            locationConditionsWord: reportDTOData["locationConditionsWord"] as? String ?? "",
            indoorRate: reportDTOData["indoorRate"] as? Float ?? 0,
            publicSpaceRate: reportDTOData["publicSpaceRate"] as? Float ?? 0,
            locationConditionsRate: reportDTOData["locationConditionsRate"] as? Float ?? 0,
            totalRate: reportDTOData["totalRate"] as? Float ?? 0
        )
    }

    private func createDetailDto(from data: [String: Any]) -> DetailDto {
        let limjangData = data["limjangDto"] as? [String: Any] ?? [:]
        return DetailDto(
            limjangId: limjangData["limjangId"] as? Int ?? 0,
            checkListVersion: limjangData["checkListVersion"] as? String ?? "",
            images: limjangData["images"] as? [String] ?? [],
            purposeCode: limjangData["purposeCode"] as? Int ?? 0,
            nickname: limjangData["nickname"] as? String ?? "",
            priceType: limjangData["priceType"] as? Int ?? 0,
            priceList: limjangData["priceList"] as? [String] ?? [],
            address: limjangData["address"] as? String ?? "",
            addressDetail: limjangData["addressDetail"] as? String ?? "",
            createdAt: limjangData["createdAt"] as? String ?? "",
            updatedAt: limjangData["updatedAt"] as? String ?? ""
        )
    }
    
    // 수정 버튼 클릭
    @objc private func editButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isEditMode.toggle()
        if sender.isSelected {
            editButton.setImage(UIImage(named: "completed-button"), for: .normal)
            NotificationCenter.default.post(name: Notification.Name("EditModeChanged"), object: true)
        } else {
                editButton.setImage(UIImage(named: "edit-button"), for: .normal)
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
                        editButton.setImage(UIImage(named: "edit-button"), for: .normal)
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

