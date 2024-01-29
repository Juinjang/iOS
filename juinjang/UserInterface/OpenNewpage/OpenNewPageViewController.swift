//
//  OpenNewPageViewController.swift
//  juinjang
//
//  Created by 임수진 on 2023/12/30.
//

import UIKit
import Then
import SnapKit

class OpenNewPageViewController: UIViewController {
    
    var purposeButtons: [UIButton] = [] // "거래 목적"을 나타내는 선택지
    var propertyTypeButtons: [UIButton] = [] // "매물 유형"을 나타내는 선택지
    var moveTypeButtons: [UIButton] = [] // "입주 유형"을 나타내는 선택지
    
    // 거래 목적 카테고리의 버튼
    var selectedPurposeButton: UIButton?
    
    // 매물 유형 카테고리의 버튼
    var selectedPropertyTypeButton: UIButton?
    
    var moveTypeStackView: UIStackView!
    var inputPriceStackView: UIStackView!
    var inputMonthlyRentStackView: UIStackView!
    
    // 입주 유형 카테고리의 버튼
    var selectedMoveTypeButton: UIButton?
    
    var priceDetailLabel: UILabel?
    var priceDetailLabel2: UILabel?
    
    var isPurposeSelected: Bool = false
    var isPropertyTypeSelected: Bool = false
    var isMoveTypeSelected: Bool = false
    
    var transactionModel = TransactionModel()
    
    var backgroundImageViewWidthConstraint: NSLayoutConstraint? // 배경 이미지의 너비 제약조건
    
    let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.backgroundColor = .blue
    }
    
    func makeImageView(_ imageView: UIImageView, imageName: String) {
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
    }
    
    lazy var backgroundImageView = UIImageView().then {
        let backgroundImage = UIImage(named: "creation-background")
        $0.image = backgroundImage
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
    }
    
    lazy var investorImageView = UIImageView().then {
        makeImageView($0, imageName: "investor")
    }
    
    lazy var movingUserImageView = UIImageView().then {
        makeImageView($0, imageName: "user-moving-in-directly")
    }
    
    lazy var apartmentImageView = UIImageView().then {
        makeImageView($0, imageName: "apartment-image")
    }
    
    lazy var villaImageView = UIImageView().then {
        makeImageView($0, imageName: "villa-image")
    }
    
    lazy var officetelImageView = UIImageView().then {
        makeImageView($0, imageName: "officetel-image")
    }
    
    lazy var houseImageView = UIImageView().then {
        makeImageView($0, imageName: "house-image")
    }
    
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var purposeLabel = UILabel().then {
        configureLabel($0, text: "거래 목적")
    }
    
    lazy var typeLabel = UILabel().then {
        configureLabel($0, text: "매물 유형")
    }
    
    lazy var priceLabel = UILabel().then {
        configureLabel($0, text: "가격")
    }
    
    func configureButton(_ button: UIButton, normalImage: UIImage?, selectedImage: UIImage?, action: Selector) {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지
    }
    
    lazy var realestateInvestmentButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "realestate-investment-button"), selectedImage: UIImage(named: "realstate-investment-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var moveInDirectlyButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "move-in-directly-button"), selectedImage: UIImage(named: "move-in-directly-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var apartmentButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "apartment-button"), selectedImage: UIImage(named: "apartment-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var villaButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "villa-button"), selectedImage: UIImage(named: "villa-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var officetelButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "officetel-button"), selectedImage: UIImage(named: "officetel-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var houseButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "house-button"), selectedImage: UIImage(named: "house-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var saleButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "sale-button"), selectedImage: UIImage(named: "sale-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var jeonseButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "jeonse-button"), selectedImage: UIImage(named: "jeonse-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var monthlyRentButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "monthlyrent-button"), selectedImage: UIImage(named: "monthlyrent-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var priceView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var priceView2 = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configurePriceLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 55, height: 22)
        label.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var priceDetailLabels: [UILabel] = {
        let labelsTexts = [
            "실거래가",
            "매매가",
            "보증금",
            "전세금",
            "억",
            "월",
            "만원", // 기본 단위
            "만원" // 월세 선택 시 추가되는 단위
        ]
        return labelsTexts.map { text in
            UILabel().then {
                configurePriceLabel($0, text: text)
                if text == "실거래가" {
                    priceDetailLabel = $0
                    priceView.addSubview($0)
                }
            }
        }
    }()
    
    
    lazy var threeDisitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        $0.layer.cornerRadius = 15
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var fourDisitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        $0.layer.cornerRadius = 15
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var fourDisitMonthlyRentField = UITextField().then {
        $0.layer.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        $0.layer.cornerRadius = 15
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var nextButtonContainerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        
        $0.backgroundColor = UIColor(named: "lightGray")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "새 페이지 펼치기"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        if UIScreen.main.bounds.height <= 667 { // 아이폰 SE(3rd generation) 기준으로 스크린이 작으면
            // 스크롤뷰 사용
            setupScrollView()
            scrollView.isScrollEnabled = true
        } else {
            // 다른 디바이스에서는 스크롤뷰 미사용
//            setupWidgets()
            setupScrollView()
            scrollView.isScrollEnabled = false
        }
        threeDisitPriceField.delegate = self
        fourDisitPriceField.delegate = self
        fourDisitMonthlyRentField.delegate = self
        checkNextButtonActivation()
        nextButton.isEnabled = false
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        // 위젯들을 서브뷰로 추가
        [purposeLabel,
        typeLabel,
        priceLabel,
        backgroundImageView,
        apartmentImageView,
        villaImageView,
        officetelImageView,
        houseImageView,
        priceView,
        priceView2].forEach { contentView.addSubview($0) }
        view.addSubview(nextButtonContainerView)
        nextButtonContainerView.addSubview(nextButton)
        setupScrollLayout()
        setButton()
    }
    
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        [purposeLabel,
        typeLabel,
        priceLabel,
        backgroundImageView,
        apartmentImageView,
        villaImageView,
        officetelImageView,
        houseImageView,
        priceView,
        priceView2,
        nextButtonContainerView,
        nextButton].forEach { view.addSubview($0) }
        setupLayout()
        setButton()
    }
    
    func setupScrollLayout() {
        // 위젯에 관한 Auto Layout 설정
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(view.snp.width)
//            $0.height.equalTo(view.snp.height).multipliedBy(0.75)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
//            $0.top.equalTo(scrollView.snp.top)
//            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide)
//            $0.height.equalTo(view.snp.height).multipliedBy(1.1)
//            $0.bottom.equalTo(nextButton.snp.top).offset(10)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
//        setupLayout()
        
        // 배경 ImageView
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.28)
        }
        
        // 배경 ImageView
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.28)
        }
        
        // 건물 ImageView
        apartmentImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-13)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(30)
        }
        
        villaImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.5)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(82)
        }
        
        officetelImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.5)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(37)
        }
        
        houseImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.84)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-91)
            $0.top.equalTo(backgroundImageView.snp.top).offset(102)
        }
        
        apartmentImageView.isHidden = true
        villaImageView.isHidden = true
        officetelImageView.isHidden = true
        houseImageView.isHidden = true
        
        // 거래 목적 Label
        purposeLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(21)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(contentView.snp.leading).offset(24)
        }
        
        // 거래 목적 Stack View
        let purposeButtonsStackView = UIStackView(arrangedSubviews: [realestateInvestmentButton, moveInDirectlyButton])
        
        purposeButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        purposeButtonsStackView.axis = .horizontal
        purposeButtonsStackView.spacing = 8
        
        contentView.addSubview(purposeButtonsStackView)
        
        purposeButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(purposeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.leading.equalTo(view).offset(24)
        }
        
        // 매물 유형 Label
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(realestateInvestmentButton.snp.bottom).offset(27)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(contentView.snp.leading).offset(24)
        }
        
        // 매물 유형 Stack View
        let propertyTypeStackView = UIStackView(arrangedSubviews: [apartmentButton, villaButton, officetelButton, houseButton])
        
        propertyTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        propertyTypeStackView.axis = .horizontal
        propertyTypeStackView.spacing = 8
        
        contentView.addSubview(propertyTypeStackView)
        
        propertyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.leading.equalTo(contentView).offset(24)
        }
        
        // 가격 Label
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(propertyTypeStackView.snp.bottom).offset(27)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(contentView.snp.leading).offset(24)
        }
        
        // 가격 View
        priceView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.isHidden = true
        
        // 입주 유형 Stack View
        moveTypeStackView = UIStackView(
            arrangedSubviews:
                [saleButton,
                 jeonseButton,
                 monthlyRentButton])
        
        moveTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        moveTypeStackView.axis = .horizontal
        moveTypeStackView.spacing = 8
        
        // 매매 버튼이 기본으로 선택되어 있음
        saleButton.isSelected = true

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(
            arrangedSubviews:
                [threeDisitPriceField,
                 priceDetailLabels[4],
                 fourDisitPriceField,
                 priceDetailLabels[6]])

        inputPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        inputPriceStackView.axis = .horizontal
        inputPriceStackView.spacing = 5

        priceView.addSubview(inputPriceStackView)

        if let priceDetailLabel = priceDetailLabel {
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
            }
        }
        
        propertyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.07)
            $0.leading.equalTo(contentView).offset(24)
        }
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.translatesAutoresizingMaskIntoConstraints = false
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5
    
        // 가격 입력 받는 TextField
        threeDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }

        fourDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }
        
        nextButtonContainerView.snp.makeConstraints {
//            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(97)
        }
        scrollView.bringSubviewToFront(nextButtonContainerView)
        
        // 다음으로 버튼
        nextButton.snp.makeConstraints {
//            $0.width.equalTo(view.snp.width).multipliedBy(0.87)
//            $0.height.equalTo(52)
            $0.top.equalTo(nextButtonContainerView.snp.top).offset(12)
            $0.leading.equalTo(nextButtonContainerView.snp.leading).offset(24)
            $0.trailing.equalTo(nextButtonContainerView.snp.trailing).offset(-24)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.bottom.equalTo(nextButtonContainerView.snp.bottom).offset(-33)
        }
    }
    
    
    func setupLayout() {
        // 위젯에 관한 Auto Layout 설정
        
        // 배경 ImageView
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.28)
        }
        
        // 건물 ImageView
        apartmentImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-13)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(30)
        }
        
        villaImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.5)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(82)
        }
        
        officetelImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.5)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-95)
            $0.top.equalTo(backgroundImageView.snp.top).offset(37)
        }
        
        houseImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.84)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-91)
            $0.top.equalTo(backgroundImageView.snp.top).offset(102)
        }
        
        apartmentImageView.isHidden = true
        villaImageView.isHidden = true
        officetelImageView.isHidden = true
        houseImageView.isHidden = true
        
        // 거래 목적 Label
        purposeLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(21)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 거래 목적 Stack View
        let purposeButtonsStackView = UIStackView(arrangedSubviews: [realestateInvestmentButton, moveInDirectlyButton])
        
        purposeButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        purposeButtonsStackView.axis = .horizontal
        purposeButtonsStackView.spacing = 8
        
        view.addSubview(purposeButtonsStackView)
        
        purposeButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(purposeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.leading.equalTo(view).offset(24)
        }
        
        // 매물 유형 Label
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(realestateInvestmentButton.snp.bottom).offset(27)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 매물 유형 Stack View
        let propertyTypeStackView = UIStackView(arrangedSubviews: [apartmentButton, villaButton, officetelButton, houseButton])
        
        propertyTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        propertyTypeStackView.axis = .horizontal
        propertyTypeStackView.spacing = 8
        
        view.addSubview(propertyTypeStackView)
        
        propertyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.leading.equalTo(view).offset(24)
        }
        
        // 가격 Label
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(propertyTypeStackView.snp.bottom).offset(27)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 가격 View
        priceView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.isHidden = true
        
        // 입주 유형 Stack View
        moveTypeStackView = UIStackView(
            arrangedSubviews:
                [saleButton,
                 jeonseButton,
                 monthlyRentButton])
        
        moveTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        moveTypeStackView.axis = .horizontal
        moveTypeStackView.spacing = 8
        
        // 매매 버튼이 기본으로 선택되어 있음
        saleButton.isSelected = true

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(
            arrangedSubviews:
                [threeDisitPriceField,
                 priceDetailLabels[4],
                 fourDisitPriceField,
                 priceDetailLabels[6]])

        inputPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        inputPriceStackView.axis = .horizontal
        inputPriceStackView.spacing = 5

        priceView.addSubview(inputPriceStackView)

        if let priceDetailLabel = priceDetailLabel {
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
            }
        }
        
        propertyTypeStackView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.07)
            $0.leading.equalTo(view).offset(24)
        }
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.translatesAutoresizingMaskIntoConstraints = false
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5
    
        // 가격 입력 받는 TextField
        threeDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }

        fourDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }
        
        // 다음으로 버튼
        nextButton.snp.makeConstraints {
            $0.width.equalTo(view.snp.width).multipliedBy(0.87)
            $0.height.equalTo(52)
            $0.centerX.equalTo(view.snp.centerX)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }
    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    func setButton() {
        // 거래 목적 카테고리에 속한 버튼
        purposeButtons = [realestateInvestmentButton, moveInDirectlyButton]
        // 매물 유형 카테고리에 속한 버튼
        propertyTypeButtons = [apartmentButton, villaButton, officetelButton, houseButton]
        // 입주 유형 카테고리에 속한 버튼
        moveTypeButtons = [saleButton, jeonseButton, monthlyRentButton]
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard !sender.isSelected else { return } // 이미 선택된 버튼이면 아무 동작도 하지 않음
        // 해당 버튼의 선택 여부를 반전
        sender.isSelected = !sender.isSelected
        
        if purposeButtons.contains(sender) {
            // 거래 목적 카테고리의 버튼일 경우
            if let selectedButton = selectedPurposeButton, selectedButton != sender {
                // 이전에 선택된 버튼이 있고 새로운 버튼과 다른 경우에는 이전 버튼의 선택을 해제
                selectedButton.isSelected = false
            }
            selectedPurposeButton = sender.isSelected ? sender : nil
            
            // 버튼에 따라 사용자 표시
            if sender == realestateInvestmentButton {
                transactionModel.selectedPurposeButtonImage = investorImageView.image
                backgroundImageView.addSubview(investorImageView)
                priceView2.isHidden = true
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[0]
                checkPriceDetailLabel()
                
                // 이미지 배치
                investorImageView.snp.makeConstraints {
                    $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-15)
                    $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-258.67)
                    $0.top.equalTo(backgroundImageView.snp.top).offset(105)
                }
                movingUserImageView.removeFromSuperview()
            } else if sender == moveInDirectlyButton {
                transactionModel.selectedPurposeButtonImage = movingUserImageView.image
                backgroundImageView.addSubview(movingUserImageView)
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[1]
                checkPriceDetailLabel()
                
                
                // 이미지 배치
                movingUserImageView.snp.makeConstraints {
                    $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.84)
                    $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-255.55)
                    $0.top.equalTo(backgroundImageView.snp.top).offset(110)
                }
                investorImageView.removeFromSuperview()
            }
        } else if propertyTypeButtons.contains(sender) {
            if let selectedButton = selectedPropertyTypeButton, selectedButton != sender {
                selectedButton.isSelected = false
            }
            selectedPropertyTypeButton = sender.isSelected ? sender : nil
            
            // 버튼에 따라 집 표시
            if sender == apartmentButton {
                transactionModel.selectedPropertyTypeButtonImage = apartmentImageView.image
                RemovePropertyImageViews()
                apartmentImageView.isHidden = false
            } else if sender == villaButton {
                transactionModel.selectedPropertyTypeButtonImage = villaImageView.image
                RemovePropertyImageViews()
                villaImageView.isHidden = false
            } else if sender == officetelButton {
                transactionModel.selectedPropertyTypeButtonImage = officetelImageView.image
                RemovePropertyImageViews()
                officetelImageView.isHidden = false
            } else if sender == houseButton {
                transactionModel.selectedPropertyTypeButtonImage = houseImageView.image
                RemovePropertyImageViews()
                houseImageView.isHidden = false
            }
        } else if moveTypeButtons.contains(sender) {
            if sender != saleButton {
                saleButton.isSelected = false
            }
            // 매물 유형 카테고리의 버튼일 경우
            if let selectedButton = selectedMoveTypeButton, selectedButton != sender {
                // 이전에 선택된 버튼이 있고 새로운 버튼과 다른 경우에는 이전 버튼의 선택을 해제
                selectedButton.isSelected = false
            }
            
            threeDisitPriceField.placeholder = "000"
            fourDisitPriceField.placeholder = "0000"
            fourDisitMonthlyRentField.placeholder = "0000"
            
            // 버튼에 따라 가격 View 표시
            if sender == saleButton {
                threeDisitPriceField.text = ""
                fourDisitPriceField.text = ""
                priceView2.isHidden = true
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[1]
                checkPriceDetailLabel()
            } else if sender == jeonseButton {
                threeDisitPriceField.text = ""
                fourDisitPriceField.text = ""
                priceView2.isHidden = true
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[3]
                checkPriceDetailLabel()
            } else if sender == monthlyRentButton {
                threeDisitPriceField.text = ""
                fourDisitPriceField.text = ""
                fourDisitMonthlyRentField.text = ""
                priceDetailLabel?.removeFromSuperview()
                priceView2.isHidden = false
                priceDetailLabel = priceDetailLabels[2]
                checkPriceDetailLabel()
                priceView2.addSubview(inputMonthlyRentStackView)
                priceDetailLabel2 = priceDetailLabels[5]
                inputMonthlyRentStackView.addArrangedSubview(fourDisitMonthlyRentField)
                inputMonthlyRentStackView.addArrangedSubview(priceDetailLabels[7])
                if let priceDetailLabel2 = priceDetailLabel2 {
                    priceView2.addSubview(priceDetailLabel2)
                    priceDetailLabel2.snp.makeConstraints {
                        $0.centerY.equalTo(priceView2.snp.centerY)
                        $0.top.equalTo(priceView2.snp.top).offset(8)
                        $0.leading.equalTo(priceView2.snp.leading).offset(24)
                    }
                    inputMonthlyRentStackView.snp.makeConstraints {
                        $0.leading.equalTo(priceDetailLabel2.snp.trailing).offset(16)
                        $0.centerY.equalTo(priceView2.snp.centerY)
                        $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.1)
                        $0.top.equalTo(priceView2.snp.top).offset(8)
                    }
                    fourDisitMonthlyRentField.snp.makeConstraints {
                        $0.top.equalTo(priceView2.snp.top).offset(4)
                        $0.centerY.equalTo(priceView2.snp.centerY)
                    }
                }
            }
            selectedMoveTypeButton = sender.isSelected ? sender : nil
        }
        
        // moveInDirectlyButton을 눌렀을 때 매매, 전세, 월세 버튼을 포함한 moveTypeStackView가 나타남
        if moveInDirectlyButton.isSelected {
            priceView.removeFromSuperview()
            // moveInDirectlyButton이 선택된 상태일 때
            contentView.addSubview(moveTypeStackView) // moveTypeStackView을 표시
            contentView.addSubview(priceView)
            contentView.addSubview(priceView2)
            // moveTypeStackView 제약 조건
            moveTypeStackView.snp.makeConstraints {
                $0.top.equalTo(priceLabel.snp.bottom).offset(12)
                $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
                $0.leading.equalTo(view.snp.leading).offset(24)
            }
            // priceView 제약 조건
            priceView.snp.makeConstraints {
                $0.top.equalTo(moveTypeStackView.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(view.snp.height).multipliedBy(0.05)
            }
            
            // priceVeiw2 제약 조건
            priceView2.snp.makeConstraints {
                $0.top.equalTo(priceView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(view.snp.height).multipliedBy(0.05)
            }
        } else {
            // moveInDirectlyButton이 선택되지 않은 상태일 때
            moveTypeStackView.removeFromSuperview() // moveTypeStackView을 숨김
            saleButton.isSelected = true
            jeonseButton.isSelected = false
            monthlyRentButton.isSelected = false
            contentView.addSubview(priceView)
            priceView.snp.makeConstraints {
                $0.top.equalTo(priceLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(view.snp.height).multipliedBy(0.05)
            }
        }
        
        // 각 카테고리에 대한 버튼 선택 여부
        if sender == realestateInvestmentButton || sender == moveInDirectlyButton {
            isPurposeSelected = sender.isSelected
            checkNextButtonActivation()
        } else if sender == apartmentButton || sender == villaButton || sender == officetelButton || sender == houseButton {
            isPropertyTypeSelected = sender.isSelected
            checkNextButtonActivation()
        } else if sender == saleButton || sender == jeonseButton || sender == monthlyRentButton {
            isMoveTypeSelected = sender.isSelected
            checkNextButtonActivation()
        }
    }
    
    func checkPriceDetailLabel() {
        if let priceDetailLabel = priceDetailLabel {
            priceView.addSubview(priceDetailLabel)
            priceView.addSubview(inputPriceStackView)
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
                $0.top.equalTo(priceView.snp.top).offset(8)
            }
        }
    }
    
    func RemovePropertyImageViews() {
        apartmentImageView.isHidden = true
        villaImageView.isHidden = true
        officetelImageView.isHidden = true
        houseImageView.isHidden = true
    }
    
    func checkNextButtonActivation() {
        // 각 카테고리별 버튼과 텍스트 필드가 모두 선택 및 입력되었는지 확인
        let isPurposeButtonSelected = selectedPurposeButton != nil
        
        if isPurposeButtonSelected {
            if realestateInvestmentButton.isSelected {
                // 매물 유형 버튼이 선택되었는지 확인
                let isPropertyTypeSelected = propertyTypeButtons.contains { $0.isSelected }
                
                // 필드의 상태를 확인
                let threeDisitPriceFieldEmpty = threeDisitPriceField.text?.isEmpty ?? true
                let fourDisitPriceFieldEmpty = fourDisitPriceField.text?.isEmpty ?? true
                
                // 각 버튼 선택 여부와 텍스트 필드 입력 여부에 따라 다음으로 버튼 활성화 여부 결정
                let allCategoriesSelected = isPropertyTypeSelected
                let allTextFieldsFilled = !threeDisitPriceFieldEmpty || !fourDisitPriceFieldEmpty
                
                // 모든 조건이 충족되었을 때 다음으로 버튼 활성화
                if allCategoriesSelected && allTextFieldsFilled {
                    nextButton.isEnabled = true
                    nextButton.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
                } else {
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
                }
            } else if moveInDirectlyButton.isSelected {
                if saleButton.isSelected || jeonseButton.isSelected {
                    // 매물 유형 버튼과 이사 유형 버튼이 선택되었는지 확인
                    let isPropertyTypeSelected = propertyTypeButtons.contains { $0.isSelected }
                    let isMoveTypeSelected = moveTypeButtons.contains { $0.isSelected }
                    
                    // 필드가 비어있는지 확인
                    let threeDisitPriceFieldEmpty = threeDisitPriceField.text?.isEmpty ?? true
                    let fourDisitPriceFieldEmpty = fourDisitPriceField.text?.isEmpty ?? true
                    
                    // 각 버튼 선택 여부와 텍스트 필드 입력 여부에 따라 다음으로 버튼 활성화 여부 결정
                    let allCategoriesSelected = isPropertyTypeSelected && isMoveTypeSelected
                    let allTextFieldsFilled = !threeDisitPriceFieldEmpty || !fourDisitPriceFieldEmpty
                    
                    // 모든 조건이 충족되었을 때 다음으로 버튼 활성화
                    if allCategoriesSelected && allTextFieldsFilled {
                        nextButton.isEnabled = true
                        nextButton.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
                    } else {
                        nextButton.isEnabled = false
                        nextButton.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
                    }
                } else if monthlyRentButton.isSelected {
                    // 매물 유형 버튼과 이사 유형 버튼이 선택되었는지 확인
                    let isPropertyTypeSelected = propertyTypeButtons.contains { $0.isSelected }
                    let isMoveTypeSelected = moveTypeButtons.contains { $0.isSelected }
                    
                    // 필드가 비어있는지 확인
                    let threeDisitPriceFieldEmpty = threeDisitPriceField.text?.isEmpty ?? true
                    let fourDisitPriceFieldEmpty = fourDisitPriceField.text?.isEmpty ?? true
                    let fourDisitMonthlyRentFieldEmpty = fourDisitMonthlyRentField.text?.isEmpty ?? true
                    
                    // 각 버튼 선택 여부와 텍스트 필드 입력 여부에 따라 다음으로 버튼 활성화 여부 결정
                    let allCategoriesSelected = isPropertyTypeSelected && isMoveTypeSelected
                    let allTextFieldsFilled = (!threeDisitPriceFieldEmpty || !fourDisitPriceFieldEmpty) && !fourDisitMonthlyRentFieldEmpty
                    
                    // 모든 조건이 충족되었을 때 다음으로 버튼 활성화
                    if allCategoriesSelected && allTextFieldsFilled {
                        nextButton.isEnabled = true
                        nextButton.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
                    } else {
                        nextButton.isEnabled = false
                        nextButton.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
                    }
                }
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let newPageViewController = OpenNewPage2ViewController()
        newPageViewController.transactionModel = transactionModel // 데이터 전달
        print("Selected Purpose Button Image: \(transactionModel.selectedPurposeButtonImage)")
        print("Selected Property Type Button Image: \(transactionModel.selectedPropertyTypeButtonImage)")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(newPageViewController, animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension OpenNewPageViewController: UITextFieldDelegate {
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
        guard let text = textField.text else { return }
        // 기존의 widthAnchor로 업데이트
        if text.isEmpty {
            for constraint in textField.constraints where constraint.firstAttribute == .width {
                constraint.constant = constant
            }
        } else {
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 모든 조건을 검사하여 버튼 상태 변경
        checkNextButtonActivation()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        // 각 텍스트 필드에 대한 최소, 최대 너비 설정
        let minimumWidth: CGFloat = 30 // 최소 너비
        var maximumWidth: CGFloat = 74 // 네 자릿수 텍스트 필드의 최대 너비

        if textField == threeDisitPriceField {
            maximumWidth = 60 // 세 자릿수 텍스트 필드의 최대 너비
        }
        
        // 텍스트 길이에 따라 적절한 너비 계산
        let size = text.size(withAttributes: [.font: textField.font ?? UIFont.systemFont(ofSize: 17)])
        let calculatedWidth = max(size.width + 20, minimumWidth) // 텍스트 길이와 최소 너비 중 큰 값을 선택
        let finalWidth = min(calculatedWidth, maximumWidth) // 최대 너비 제한

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: textField, constant: finalWidth)

        // 레이아웃 업데이트
        view.layoutIfNeeded()
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // 숫자만 허용, textField에 따라 글자 수 제한
        guard Int(string) != nil || string == "" else { return false }
        if textField == threeDisitPriceField {
            guard textField.text!.count < 3 else { return false }
        } else {
            guard textField.text!.count < 4 else { return false }
        }
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else { return }
        if textField == threeDisitPriceField {
            textField.placeholder = "000"
            updateTextFieldWidthConstraint(for: textField, constant: 60) // 기존 너비로 복원
        } else {
            textField.placeholder = "0000"
            updateTextFieldWidthConstraint(for: textField, constant: 74)
        }
    }
}
