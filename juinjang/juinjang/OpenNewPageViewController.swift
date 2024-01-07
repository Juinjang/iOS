//
//  OpenNewPageViewController.swift
//  juinjang
//
//  Created by 임수진 on 2023/12/30.
//
// TODO: 코드 정리 필요

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
        makeImageView($0, imageName: "apartment")
    }
    
    lazy var villaImageView = UIImageView().then {
        makeImageView($0, imageName: "villa")
    }
    
    lazy var officetelImageView = UIImageView().then {
        makeImageView($0, imageName: "officetel")
    }
    
    lazy var houseImageView = UIImageView().then {
        makeImageView($0, imageName: "house")
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
        let labelsTexts = ["실거래가", "매매가", "보증금", "전세금", "억", "월", "만원", "만원"]
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
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
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
        setupWidgets()
        threeDisitPriceField.delegate = self
        fourDisitPriceField.delegate = self
        fourDisitMonthlyRentField.delegate = self
        checkNextButtonActivation()
        nextButton.isEnabled = false
    }
        
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        let widgets: [UIView] = [purposeLabel, typeLabel, priceLabel, backgroundImageView, priceView, priceView2, nextButton]
        widgets.forEach { view.addSubview($0) }
        setupLayout()
        setButton()
    }
    
    func setupLayout() {
        // 위젯에 관한 Auto Layout 설정
        
        // 배경 ImageView
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // 네비게이션 바 바로 아래에 배치
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.28)
        }
        
        // 거래 목적 Label
        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(21)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalToSuperview().multipliedBy(0.03)
            make.centerX.equalTo(view.snp.centerX).offset(view.bounds.width * -0.35)
        }
        
        // 거래 목적 Stack View
        let purposeButtonsStackView = UIStackView(arrangedSubviews: [realestateInvestmentButton, moveInDirectlyButton])
        
        purposeButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        purposeButtonsStackView.axis = .horizontal
        purposeButtonsStackView.spacing = 8
        
        view.addSubview(purposeButtonsStackView)
        
        purposeButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(purposeLabel.snp.bottom).offset(12)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            make.leading.equalTo(view).offset(24)
        }
        
        // 매물 유형 Label
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(realestateInvestmentButton.snp.bottom).offset(27)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalToSuperview().multipliedBy(0.03)
            make.centerX.equalTo(view.snp.centerX).offset(view.bounds.width * -0.35)
        }
        
        // 매물 유형 Stack View
        let propertyTypeStackView = UIStackView(arrangedSubviews: [apartmentButton, villaButton, officetelButton, houseButton])
        
        propertyTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        propertyTypeStackView.axis = .horizontal
        propertyTypeStackView.spacing = 8
        
        view.addSubview(propertyTypeStackView)
        
        propertyTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(12)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            make.leading.equalTo(view).offset(24)
        }
        
        // 가격 Label
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(propertyTypeStackView.snp.bottom).offset(27)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalToSuperview().multipliedBy(0.03)
            make.centerX.equalTo(view.snp.centerX).offset(view.bounds.width * -0.35)
        }
        
        // 가격 View
        NSLayoutConstraint.activate([
            priceView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            priceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
        
        NSLayoutConstraint.activate([
            priceView2.topAnchor.constraint(equalTo: priceView.bottomAnchor),
            priceView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            priceView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            priceView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
        
        priceView2.isHidden = true
        
        // 입주 유형 Stack View
        moveTypeStackView = UIStackView(arrangedSubviews: [saleButton, jeonseButton, monthlyRentButton])

        moveTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        moveTypeStackView.axis = .horizontal
        moveTypeStackView.spacing = 8
        
        // 매매 버튼이 기본으로 선택되어 있음
        saleButton.isSelected = true

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(arrangedSubviews: [threeDisitPriceField, priceDetailLabels[4], fourDisitPriceField, priceDetailLabels[6]])

        inputPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        inputPriceStackView.axis = .horizontal
        inputPriceStackView.spacing = 5

        priceView.addSubview(inputPriceStackView)

        if let priceDetailLabel = priceDetailLabel {
            NSLayoutConstraint.activate([
                priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
            ])
        }
        
        propertyTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(12)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.07)
            make.leading.equalTo(view).offset(24)
        }
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.translatesAutoresizingMaskIntoConstraints = false
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5
        
        NSLayoutConstraint.activate([
            threeDisitPriceField.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 4),
            threeDisitPriceField.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            fourDisitPriceField.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 4),
            fourDisitPriceField.centerYAnchor.constraint(equalTo: priceView.centerYAnchor)
        ])
        
        // 다음으로 버튼
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.87),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
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
                priceDetailLabel?.removeFromSuperview()
                priceView2.isHidden = true
                priceDetailLabel = priceDetailLabels[0]
                if let priceDetailLabel = priceDetailLabel {
                    priceView.addSubview(priceDetailLabel)
                    priceView.addSubview(inputPriceStackView)
                    NSLayoutConstraint.activate([
                        priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                        priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                        inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                        inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        inputPriceStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
                        inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
                    ])
                }
                NSLayoutConstraint.activate([
                    investorImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -15),
                    investorImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -258.67),
                    investorImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 105)
                ])
                movingUserImageView.removeFromSuperview()
            } else if sender == moveInDirectlyButton {
                transactionModel.selectedPurposeButtonImage = movingUserImageView.image
                backgroundImageView.addSubview(movingUserImageView)
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[1]
                if let priceDetailLabel = priceDetailLabel {
                    priceView.addSubview(priceDetailLabel)
                    NSLayoutConstraint.activate([
                        priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                        priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                        inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                        inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        inputPriceStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
                        inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
                    ])
                }
                NSLayoutConstraint.activate([
                    movingUserImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.84),
                    movingUserImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -255.55),
                    movingUserImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 110)
                ])
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
                backgroundImageView.addSubview(apartmentImageView)
                NSLayoutConstraint.activate([
                    apartmentImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -13),
                    apartmentImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                    apartmentImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 30)
                ])
                villaImageView.removeFromSuperview()
                officetelImageView.removeFromSuperview()
                houseImageView.removeFromSuperview()
            } else if sender == villaButton {
                transactionModel.selectedPropertyTypeButtonImage = villaImageView.image
                backgroundImageView.addSubview(villaImageView)
                NSLayoutConstraint.activate([
                    villaImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.5),
                    villaImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                    villaImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 82)
                ])
                apartmentImageView.removeFromSuperview()
                officetelImageView.removeFromSuperview()
                houseImageView.removeFromSuperview()
            } else if sender == officetelButton {
                transactionModel.selectedPropertyTypeButtonImage = officetelImageView.image
                backgroundImageView.addSubview(officetelImageView)
                NSLayoutConstraint.activate([
                    officetelImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.5),
                    officetelImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                    officetelImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 37)
                ])
                apartmentImageView.removeFromSuperview()
                villaImageView.removeFromSuperview()
                houseImageView.removeFromSuperview()
            } else if sender == houseButton {
                transactionModel.selectedPropertyTypeButtonImage = houseImageView.image
                backgroundImageView.addSubview(houseImageView)
                NSLayoutConstraint.activate([
                    houseImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.84),
                    houseImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -91),
                    houseImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 102)
                ])
                apartmentImageView.removeFromSuperview()
                villaImageView.removeFromSuperview()
                officetelImageView.removeFromSuperview()
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
                if let priceDetailLabel = priceDetailLabel {
                    priceView.addSubview(priceDetailLabel)
                    priceView.addSubview(inputPriceStackView)
                    NSLayoutConstraint.activate([
                        priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                        priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                        inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                        inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        inputPriceStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.1),
                        inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
                    ])
                }
            } else if sender == jeonseButton {
                threeDisitPriceField.text = ""
                fourDisitPriceField.text = ""
                priceView2.isHidden = true
                priceDetailLabel?.removeFromSuperview()
                priceDetailLabel = priceDetailLabels[3]
                if let priceDetailLabel = priceDetailLabel {
                    priceView.addSubview(priceDetailLabel)
                    priceView.addSubview(inputPriceStackView)
                    NSLayoutConstraint.activate([
                        priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                        priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                        inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                        inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        inputPriceStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.1),
                        inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
                    ])
                }
            } else if sender == monthlyRentButton {
                threeDisitPriceField.text = ""
                fourDisitPriceField.text = ""
                fourDisitMonthlyRentField.text = ""
                priceDetailLabel?.removeFromSuperview()
                priceView2.isHidden = false
                priceDetailLabel = priceDetailLabels[2]
                if let priceDetailLabel = priceDetailLabel {
                    priceView.addSubview(priceDetailLabel)
                    priceView.addSubview(inputPriceStackView)
                    NSLayoutConstraint.activate([
                        priceDetailLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        priceDetailLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8),
                        priceDetailLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 24),
                        inputPriceStackView.leadingAnchor.constraint(equalTo: priceDetailLabel.trailingAnchor, constant: 16),
                        inputPriceStackView.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
                        inputPriceStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.1),
                        inputPriceStackView.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 8)
                    ])
                }
                priceView2.addSubview(inputMonthlyRentStackView)
                priceDetailLabel2 = priceDetailLabels[5]
                inputMonthlyRentStackView.addArrangedSubview(fourDisitMonthlyRentField)
                inputMonthlyRentStackView.addArrangedSubview(priceDetailLabels[7])
                if let priceDetailLabel2 = priceDetailLabel2 {
                    priceView2.addSubview(priceDetailLabel2)
                    NSLayoutConstraint.activate([
                        priceDetailLabel2.centerYAnchor.constraint(equalTo: priceView2.centerYAnchor),
                        priceDetailLabel2.topAnchor.constraint(equalTo: priceView2.topAnchor, constant: 8),
                        priceDetailLabel2.leadingAnchor.constraint(equalTo: priceView2.leadingAnchor, constant: 24),
                        inputMonthlyRentStackView.leadingAnchor.constraint(equalTo: priceDetailLabel2.trailingAnchor, constant: 16),
                        inputMonthlyRentStackView.centerYAnchor.constraint(equalTo: priceView2.centerYAnchor),
                        inputMonthlyRentStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.1),
                        inputMonthlyRentStackView.topAnchor.constraint(equalTo: priceView2.topAnchor, constant: 8),
                        fourDisitMonthlyRentField.topAnchor.constraint(equalTo: priceView2.topAnchor, constant: 4),
                        fourDisitMonthlyRentField.centerYAnchor.constraint(equalTo: priceView2.centerYAnchor)
                    ])
                }
            }
            selectedMoveTypeButton = sender.isSelected ? sender : nil
        }
        
        // moveInDirectlyButton을 눌렀을 때 매매, 전세, 월세 버튼을 포함한 moveTypeStackView가 나타남
        if moveInDirectlyButton.isSelected {
            priceView.removeFromSuperview()
            // moveInDirectlyButton이 선택된 상태일 때
            view.addSubview(moveTypeStackView) // moveTypeStackView을 표시
            view.addSubview(priceView)
            view.addSubview(priceView2)
            // moveTypeStackView 제약 조건
            NSLayoutConstraint.activate([
                moveTypeStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
                moveTypeStackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
                moveTypeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ])

            // priceView 제약 조건
            NSLayoutConstraint.activate([
                priceView.topAnchor.constraint(equalTo: moveTypeStackView.bottomAnchor, constant: 12),
                priceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                priceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ])
            
            // priceVeiw 제약 조건
            NSLayoutConstraint.activate([
                priceView2.topAnchor.constraint(equalTo: priceView.bottomAnchor),
                priceView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                priceView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                priceView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ])
        } else {
            // moveInDirectlyButton이 선택되지 않은 상태일 때
            moveTypeStackView.removeFromSuperview() // moveTypeStackView을 숨김
            saleButton.isSelected = true
            jeonseButton.isSelected = false
            monthlyRentButton.isSelected = false
            view.addSubview(priceView)
            NSLayoutConstraint.activate([
                priceView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
                priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                priceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                priceView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ])
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
                    
                    // 필드의 상태를 확인
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
                    
                    // 필드의 상태를 확인
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
