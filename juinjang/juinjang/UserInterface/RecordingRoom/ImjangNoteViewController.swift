//
//  ImjangNoteViewController.swift
//  juinjang
//
//  Created by 조유진 on 12/30/23.
//

import UIKit
import SnapKit
import Then

class ImjangNoteViewController: UIViewController {
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    // 하우스 이미지뷰
    let noImageBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "backgroundGray")
        $0.layer.cornerRadius = 5
    }
    let noImageIcon = UIImageView().then {
        $0.image = UIImage(named: "gallery-add")
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
        $0.backgroundColor = UIColor(named: "gray0")
        $0.layer.cornerRadius = 10
    }
    
    let showReportLabel = UILabel()
    let reportImageView = UIImageView()
    let reportStackView = UIStackView()
    
    let modifiedDateString = UILabel()
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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
    
    let upButton = UIButton().then {
        $0.setImage(UIImage(named: "floating"), for: .normal)
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit-button"), for: .normal)
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.13).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 1
        $0.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
    
    let recordingSegmentedVC = RecordingSegmentedViewController()
    
    var roomName: String = "판교푸르지오월드마크"
    var roomPriceString: String = "30억 1천만원"
    var roomAddress: String = "경기도 성남시 분당구 삼평동 741"
    var mDateString: String = "23.12.01"
    
    lazy var images: [UIImage?] = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3")]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDelegate()
        designNavigationBar()
        designViews()
        addSubView()
        setUpUI()
        setConstraints()
        upButton.addTarget(self, action: #selector(upToTop), for: .touchUpInside)
        setReportStackViewClick()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedChildScroll), name: NSNotification.Name("didStoppedChildScroll"), object: nil)
        recordingSegmentedVC.imjangNoteViewController = self
    }
    
    func setReportStackViewClick() {
        reportStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showReportVC))
        reportStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showReportVC() {
        // 현재 ViewController를 검사해서 미입력 상태라면
        if let currentVC = recordingSegmentedVC.currentViewController,
           currentVC.isKind(of: NotEnteredCheckListViewController.self) {
            // 팝업창이 뜸
            let reportPopupVC = ReportPopupViewController()
            reportPopupVC.modalPresentationStyle = .overCurrentContext
            present(reportPopupVC, animated: false, completion: nil)
        } else {
            // 아니라면 ReportViewController로 이동
            let reportVC = ReportViewController()
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    @objc func didStoppedChildScroll() {
        scrollView.isScrollEnabled = true
        let containerY = containerView.frame.origin.y
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset.y = containerY - 21
        }
    }
    
    @objc func upToTop() {
        UIView.animate(withDuration: 0.5) {
            self.scrollView.contentOffset.y = 0
        }
    }
    
    func setDelegate() {
        scrollView.delegate = self
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "판교푸르지오월드마크"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        // 이미지 로드
        let backImage = UIImage(named: "arrow-left")

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popView))
        
        let editButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editView))
        editButtonItem.tintColor = UIColor(named: "textGray")

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editView() {
        // TODO: 실거래가 / 매매-전세-월세 구분 필요
        let editVC = EditBasicInfoViewController()
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    // MARK: - addSubView()
    func addSubView() {
        [scrollView, upButton, editButton].forEach {
            view.addSubview($0)
        }
        
        upButton.isHidden = true

        scrollView.addSubview(contentView)
        
        [roomStackView, roomPriceLabel, infoStackView, addressBackgroundView, containerView, noImageBackgroundView, stackView].forEach {
            contentView.addSubview($0)
        }
        
        noImageBackgroundView.addSubview(noImageIcon)
        addressBackgroundView.addSubview(addressStackView)
        
        [showReportLabel, reportImageView].forEach {
            reportStackView.addArrangedSubview($0)
        }
        
        [modifiedDateString, modifiedDate].forEach {
            modifiedDateStackView.addArrangedSubview($0)
        }
        
        [modifiedDateStackView, reportStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    
    // 뷰들 디자인
    func designViews() {
        upButton.alpha = 0
        designImageView(maximizeImageView, image: UIImage(named: "maximize"), contentMode: .scaleAspectFit)
        
        // 방 이미지뷰 설정
        setRoomImages()
        
        // 집 아이콘 이미지뷰
        designImageView(houseImageView,
                        image: UIImage(named: "house"),
                        contentMode: .scaleAspectFit)
        
        // 방 이름 레이블
        designLabel(roomNameLabel,
                    text: roomName,
                    alignment: .left,
                    font: UIFont.pretendard(size: 20, weight: .extraBold),
                    textColor: UIColor(named: "mainOrange")!)
        
        // 방 이름 스택뷰
        setStackView(roomStackView,
                     label: roomNameLabel,
                     image: houseImageView,
                     axis: .horizontal,
                     spacing: 6,
                     isImageRight: true)
        
        // 방 가격 레이블
        designLabel(roomPriceLabel,
                    text: roomPriceString,
                    font: UIFont.pretendard(size: 20, weight: .bold),
                    textColor: UIColor(named: "textBlack")!)
        
        // 방 주소 레이블
        designLabel(roomAddressLabel,
                    text: roomAddress,
                    font: UIFont.pretendard(size: 16, weight: .medium),
                    textColor: UIColor(named:"textGray")!, numberOfLines: 2)
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
//                    textColor: UIColor(named:"textGray")!)
        

        
        // 리포트 보기 레이블
        designLabel(showReportLabel, text: "리포트 보기",
                    alignment: .left,
                    font: UIFont.pretendard(size: 14, weight: .bold),
                    textColor: UIColor(named: "textBlack")!)
        
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
        designLabel(modifiedDateString,
                    text: "최근 수정날짜",
                    font: UIFont.pretendard(size: 14, weight: .semiBold),
                    textColor: UIColor(named: "textGray")!)
        
        // 최근 수정날짜값 레이블
        designLabel(modifiedDate,
                    text: mDateString,
                    font: UIFont.pretendard(size: 14, weight: .semiBold),
                    textColor: UIColor(named: "textGray")!)
        
        
        addChild(recordingSegmentedVC)
        containerView.addSubview(recordingSegmentedVC.view)
    }
    
    // 이미지 개수에 따라 stackView 설정
    func setUpUI() {
        noImageBackgroundView.isHidden = true
        let imageCount = images.count
        print("이미지 개수\(imageCount)")
        switch imageCount {
        case 0:
            noImageBackgroundView.isHidden = false
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
    
    func setImage1() {
        [firstImage].forEach { stackView.addArrangedSubview($0)}
        firstImage.addSubview(maximizeImageView)
        let imageWidth = view.frame.width - (24*2)
        
        firstImage.snp.makeConstraints {
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(firstImage.snp.width).multipliedBy(171.0 / 342.0)
        }
        
        maximizeImageView.snp.makeConstraints {
            $0.bottom.equalTo(firstImage.snp.bottom).offset(-12)
            $0.trailing.equalTo(firstImage.snp.trailing).offset(-12)
            $0.width.height.equalTo(24)
        }
    }
    
    func setImage2() {
        let imagesWidth = view.frame.width - (24*2) - 8
        [firstImage, secondImage].forEach { stackView.addArrangedSubview($0)}
        secondImage.addSubview(maximizeImageView)
        
        firstImage.snp.makeConstraints {
            $0.height.equalTo(firstImage.snp.width).multipliedBy(171.0 / 225.0)
        }
        
        secondImage.snp.makeConstraints {
            $0.height.equalTo(secondImage.snp.width).multipliedBy(171.0 / 109.0)
        }
        
        maximizeImageView.snp.makeConstraints {
            $0.bottom.equalTo(secondImage.snp.bottom).offset(-12)
            $0.trailing.equalTo(secondImage.snp.trailing).offset(-12)
            $0.width.height.equalTo(24)
        }

    }
    
    func setImage3() {
        let images = [firstImage, secondImage, thirdImage]
        let imagesWidth = view.frame.width - (24 * 2)
        
        [images[0],vStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [images[1], images[2]].forEach {
            vStackView.addArrangedSubview($0)
        }
        
        images[2].addSubview(maximizeImageView)
        
        images[0].snp.makeConstraints {
            $0.height.equalTo(images[0].snp.width).multipliedBy(171.0 / 225.0)
        }
        let vstackHeight = images[0].frame.height - 8
        
        images[1].snp.makeConstraints {
            $0.height.equalTo(images[1].snp.width).multipliedBy(89.0 / 109.0)
        }
        
        images[2].snp.makeConstraints {
            $0.height.equalTo(images[2].snp.width).multipliedBy(74.0 / 109.0)
        }
        
        maximizeImageView.snp.makeConstraints {
            $0.bottom.equalTo(images[2].snp.bottom).offset(-12)
            $0.trailing.equalTo(images[2].snp.trailing).offset(-12)
            $0.width.height.equalTo(24)
        }
    }
    
    // 이미지 없을 때 배경
    func setImageViewConstraints() {
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
    func setConstraints() {
        
        var topView: UIView? = nil
        if images.isEmpty {
            topView = noImageBackgroundView
        } else {
            topView = stackView
        }
        
        upButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        view.bringSubviewToFront(upButton)
        
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
            $0.height.equalTo(view).multipliedBy(1.6)
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
//            $0.height.equalTo(37)
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
//            $0.bottom.equalTo(contentView).offset(-24)
            $0.height.equalTo(view).multipliedBy(1.5)
        }
        
        recordingSegmentedVC.view.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        recordingSegmentedVC.didMove(toParent: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // 스택뷰 설정
    func setStackView(_ stackView: UIStackView, label: UILabel, image: UIImageView, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .equalSpacing,spacing: CGFloat, isImageRight: Bool){
        
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
    func setRoomImages() {
        let imageViews = [firstImage, secondImage, thirdImage]
        for index in 1...imageViews.count {
            designImageView(imageViews[index-1], image: UIImage(named: "\(index)"), contentMode: .scaleAspectFill, cornerRadius: 5)
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
    
    // 수정 버튼 클릭
    @objc func editButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            editButton.setImage(UIImage(named: "completed-button"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("EditButtonToggled"), object: sender.isSelected)
        } else {
            editButton.setImage(UIImage(named: "edit-button"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("EditButtonToggled"), object: sender.isSelected)
            let reportVC = ReportViewController()
            self.navigationController?.pushViewController(reportVC, animated: true)
        }
    }
}


extension ImjangNoteViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("스크롤 좌표 - \(scrollView.contentOffset.y), containerView 좌표 - \(containerView.frame.origin.y)")
        
        let containerY = containerView.frame.origin.y
        
        // 0이상,
        if (scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y > containerY - 20 && scrollView.contentOffset.y <= containerY){
            DispatchQueue.main.async {
                scrollView.isScrollEnabled = false
                UIView.animate(withDuration: 0.1) {
                    scrollView.contentOffset.y = containerY
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("didStoppedParentScroll"), object: nil)
        }
        
        if scrollView.contentOffset.y > 20 {
            UIView.animate(withDuration: 0.5, delay:0) {
                self.upButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5, delay:0) {
                self.upButton.alpha = 0
            }
        }
    }
}

