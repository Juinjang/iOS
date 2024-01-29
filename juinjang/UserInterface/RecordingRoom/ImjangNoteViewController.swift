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
    let firstImage = UIImageView()
    let secondImage = UIImageView()
    let thirdImage = UIImageView()
    
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
    let roomAddressLabel = UILabel()
    
    let phoneImageView = UIImageView()
    let addPhoneNumberLabel = UILabel()
    let addPhoneStackView = UIStackView()
    
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
    }
    
    let upButton = UIButton().then {
        $0.setImage(UIImage(named: "floating"), for: .normal)
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "edit-button"), for: .normal)
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.13).cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 1
    }
    
    let recordingSegmentedVC = RecordingSegmentedViewController()
    
    var roomName: String = "판교푸르지오월드마크"
    var roomPriceString: String = "30억 1천만원"
    var roomAddress: String = "경기도 성남시 분당구 삼평동 741"
    var mDateString: String = "23.12.01"

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
        recordingSegmentedVC.imjangNoteViewController = self
    }
    
    @objc
    func upToTop() {
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
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: nil)
        
        let editImage = UIImage(named: "edit")
        let editButtonItem = UIBarButtonItem(image: editImage, style: .plain, target: self, action: nil)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // MARK: - addSubView()
    func addSubView() {
        [scrollView, upButton, editButton].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [roomStackView, roomPriceLabel, roomAddressLabel, addPhoneStackView, infoStackView, containerView].forEach {
            contentView.addSubview($0)
        }
        
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
                     imageRight: true)
        
        // 방 가격 레이블
        designLabel(roomPriceLabel,
                    text: roomPriceString,
                    font: UIFont.pretendard(size: 20, weight: .bold),
                    textColor: UIColor(named: "textBlack")!)
        
        // 방 주소 레이블
        designLabel(roomAddressLabel, 
                    text: roomAddress,
                    font: UIFont.pretendard(size: 16, weight: .medium),
                    textColor: UIColor(named:"textGray")!)
        
        // 전화 아이콘 이미지뷰
        designImageView(phoneImageView, 
                        image: UIImage(named: "call"),
                        contentMode: .scaleAspectFit)
        
        // 전화번호 추가 레이블
        designLabel(addPhoneNumberLabel, 
                    text: "전화번호 추가",
                    font: UIFont.pretendard(size: 16, weight: .medium),
                    textColor: UIColor(named: "textBlack")!)
        
        // 전화번호 추가 스택뷰
        setStackView(addPhoneStackView, 
                     label: addPhoneNumberLabel,
                     image: phoneImageView,
                     axis: .horizontal, 
                     spacing: 4,
                     imageRight: false)
        
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
                     imageRight: true)
        
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
        let images = [firstImage, secondImage, thirdImage]
        
        if images.count >= 3 {
            contentView.addSubview(stackView)
            [images[0],vStackView].forEach {
                stackView.addArrangedSubview($0)
            }
            
            [images[1], images[2]].forEach {
                vStackView.addArrangedSubview($0)
            }
            
            images[2].addSubview(maximizeImageView)
        }
    }
    
    // constraints 설정
    func setConstraints() {
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
            $0.leading.equalTo(stackView.snp.leading)
            $0.top.equalTo(stackView.snp.bottom).offset(12)
        }
        
        // 방 가격 레이블
        roomPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading)
            $0.top.equalTo(roomStackView.snp.bottom).offset(6)
        }
        
        // 방 주소 레이블
        roomAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading)
            $0.top.equalTo(roomPriceLabel.snp.bottom).offset(6)
        }
        
        // 전화번호 추가 스택뷰
        addPhoneStackView.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading)
            $0.top.equalTo(roomAddressLabel.snp.bottom).offset(6)
        }
        
        // info 스택뷰
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.leading)
            $0.trailing.equalTo(stackView.snp.trailing)
            $0.top.equalTo(addPhoneStackView.snp.bottom).offset(24)
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
        let images = [firstImage, secondImage, thirdImage]
        let imagesWidth = view.frame.width - (24 * 2) - 8
        
        images[0].snp.makeConstraints {
            $0.width.equalTo(imagesWidth * 0.7)
            $0.height.equalTo(images[0].snp.width).multipliedBy(57.0 / 85.0)
        }
        
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
    
    // 스택뷰 설정
    func setStackView(_ stackView: UIStackView, label: UILabel, image: UIImageView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, imageRight: Bool){
        
        stackView.axis = axis
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        
        if imageRight {
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
}


extension ImjangNoteViewController: UIScrollViewDelegate {

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("스크롤 좌표 - \(scrollView.contentOffset.y), containerView 좌표 - \(containerView.frame.origin.y)")
//        
//        let containerY = containerView.frame.origin.y
//        
//        if (scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y > containerY - 20 && scrollView.contentOffset.y <= containerY){
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.2) {
//                    scrollView.contentOffset.y = containerY
//                }
//                scrollView.isScrollEnabled = false
//            }
//            NotificationCenter.default.post(name: NSNotification.Name("didStoppedParentScroll"), object: nil)
//        }
//        
//        if scrollView.contentOffset.y > 20 {
//            UIView.animate(withDuration: 0.5, delay:0) {
//                self.upButton.alpha = 1
//            }
//        } else {
//            UIView.animate(withDuration: 0.5, delay:0) {
//                self.upButton.alpha = 0
//            }
//        }
//    }
}
