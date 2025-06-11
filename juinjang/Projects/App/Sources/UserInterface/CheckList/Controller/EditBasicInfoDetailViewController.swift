//
//  EditBasicInfoDetailViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

import UIKit
import SnapKit
import Then
import Alamofire
import RxSwift

final class EditBasicInfoDetailViewController: BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "정보 수정하기"
    }
    private let noteRepository = NoteRepository()
    private let disposeBag = DisposeBag()
    
    var postModel: PostCodeResponseModel? {
        didSet {
            checkNextButtonActivation()
        }
    }
    
    var transactionModel = TransactionModel()
    var imjangId: Int? = nil
    var versionInfo: VersionInfo? = nil
    var selectedPriceType: Int?
    
    var priceTypeButtons: [UIButton] = [] // "가격 유형"을 나타내는 선택지
    var selectedPriceTypeButton: UIButton? // 가격 유형 카테고리의 버튼
    var isMoveTypeSelected: Bool = false
    
    var moveTypeStackView: UIStackView!
    var inputPriceStackView: UIStackView!
    var inputMonthlyRentStackView: UIStackView!
    
    var priceDetailLabel: UILabel?
    var priceDetailLabel2: UILabel?
    var delegate: SendDetailEditData?

    let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = .gray600
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    private func secondConfigureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = .gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var addressLabel = UILabel().then {
        configureLabel($0, text: "주소")
    }
    
    private let pyungLabel = DSLabel(.title).then {
        $0.fontSize = 18
        $0.fontColor = .gray600
        $0.text = "층수·평수"
    }
    
    private let floorAndPyungBaseView = UIView().then {
        $0.backgroundColor = .gray100
    }
    private let floorTextField = RoundedPriceTextField(unitType: .floor, placeHolder: "00")
    private let pyungTextField = RoundedPriceTextField(unitType: .pyung, placeHolder: "000")

    lazy var houseNicknameLabel = UILabel().then {
        configureLabel($0, text: "집 별명")
    }
    
    lazy var priceLabel = UILabel().then {
        configureLabel($0, text: "가격")
    }
    
    lazy var explanationLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "※ 별명은 리스트 구분을 위해 쓰여요.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.3, range: NSRange(location: 0, length: attributedString.length)) // 글자 간격 설정

        let customFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let scaledFont = fontMetrics.scaledFont(for: customFont)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: scaledFont, range: NSRange(location: 0, length: attributedString.length))
        
        $0.attributedText = attributedString
        $0.textColor = .main
        $0.translatesAutoresizingMaskIntoConstraints = false

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        $0.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    lazy var addressTextField = UITextField().then {
        $0.layer.backgroundColor = UIColor.gray100.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.stroke2.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    lazy var searchAddressButton = UIButton().then {
        $0.setTitle("주소 검색하기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        
        $0.backgroundColor = .gray430
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(searchAddressButtonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    lazy var addressDetailTextField = UITextField().then {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray300,
                .font: customFont
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "상세 주소", attributes: attributes)
            $0.layer.backgroundColor = UIColor.mainWhite.cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.stroke2.cgColor
            $0.textColor = .gray500
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
    }
    
    lazy var houseNicknameTextField = UITextField().then {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray300,
                .font: customFont
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "12자 이내", attributes: attributes)
        $0.layer.backgroundColor = UIColor.mainWhite.cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.stroke2.cgColor
        $0.textColor = .gray500
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
            $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var saleButton = UIButton().then {
        configureButton($0,
                        normalImage: UIImage.OpenNewPage.saleButton,
                        selectedImage: UIImage.OpenNewPage.saleSelectedButton, action: #selector(buttonPressed))
    }
    
    lazy var jeonseButton = UIButton().then {
        configureButton($0,
                        normalImage: UIImage.OpenNewPage.jeonseButton,
                        selectedImage: UIImage.OpenNewPage.jeonseSelectedButton,
                        action: #selector(buttonPressed))
    }
    
    lazy var monthlyRentButton = UIButton().then {
        configureButton($0,
                        normalImage: UIImage.OpenNewPage.monthlyrentButton,
                        selectedImage: UIImage.OpenNewPage.monthlyrentSelectedButton,
                        action: #selector(buttonPressed))
    }
    
    lazy var priceView = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var priceView2 = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePriceLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 55, height: 22)
        label.textColor = .gray500
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var priceDetailLabels: [UILabel] = {
        let labelsTexts = [
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
                secondConfigureLabel($0, text: text)
                if text == "매매가" {
                    priceDetailLabel = $0
                    priceView.addSubview($0)
                }
            }
        }
    }()
    
    lazy var threeDigitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor.stroke2.cgColor
        $0.layer.cornerRadius = 15
        $0.textAlignment = .center
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "000",
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = .main
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
    
    lazy var fourDigitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor.stroke2.cgColor
        $0.layer.cornerRadius = 15
        $0.textAlignment = .center
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = .main
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
    
    lazy var fourDigitMonthlyRentField = UITextField().then {
        $0.layer.backgroundColor = UIColor.stroke2.cgColor
        $0.layer.cornerRadius = 15
        $0.textAlignment = .center
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = .main
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
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        
        $0.backgroundColor = .gray500
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    // -MARK: API 요청
    func getImjang() {
        guard let imjangId = imjangId else { return }
        
        noteRepository
            .retrieveNoteDetail(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, response) in
                self.setData(detailDto: response)
            }
            .disposed(by: disposeBag)
    }
    
    func modifyImjang(completionHandler: @escaping (NetworkError?) -> Void) {
        guard let imjangId = imjangId else { return }
        
        // -MARK: 매매-전세-월세 선택값 가져오기
        var selectedPriceType: String = ""
        if saleButton.isSelected == true {
            selectedPriceType = "SALE"
        } else if jeonseButton.isSelected == true {
            selectedPriceType = "PULL_RENT"
        } else if monthlyRentButton.isSelected == true {
            selectedPriceType = "MONTHLY_RENT"
        }
        
        let price = mergedPriceString(
            threeDigit: threeDigitPriceField.text,
            fourDigit: fourDigitPriceField.text
        )

        let monthlyRent = fourDigitMonthlyRentField.text ?? ""
        let roadAddress = addressTextField.text ?? ""
        let addressDetail = addressDetailTextField.text ?? ""
        let nickname = houseNicknameTextField.text ?? ""
        let floor = floorTextField.text ?? ""
        let pyong = Int(pyungTextField.text ?? "") ?? 0
        
        noteRepository
            .updateImjang(
                noteID: imjangId,
                param: .init(
                    priceType: selectedPriceType,
                    price: price,
                    monthlyRent: monthlyRent,
                    roadAddress: roadAddress,
                    addressDetail: addressDetail,
                    bcode: postModel?.bcode ?? "",
                    nickname: nickname,
                    floor: floor,
                    pyong: pyong,
                    sido: postModel?.sido,
                    sigungu: postModel?.sigungu,
                    bname1: postModel?.bname1,
                    bname2: postModel?.bname2
                )
            )
            .subscribe(
                onCompleted: {
                    completionHandler(nil)
                },
                onError: { error in
                    print("Modify Imjang Request Error")
                    completionHandler(error as? NetworkError)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func mergedPriceString(threeDigit: String?, fourDigit: String?) -> String {
        let hundredMillion = Int(threeDigit?.trimmingCharacters(in: .whitespaces) ?? "") ?? 0  // 억
        let tenThousand = Int(fourDigit?.trimmingCharacters(in: .whitespaces) ?? "") ?? 0     // 만원

        let totalPrice = hundredMillion * 100_000_000 + tenThousand * 10_000
        return String(totalPrice)
    }
    
    override func viewDidLoad() {
        getImjang()
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        setDelegate()
        setNavigationBar()
        addressTextField.isUserInteractionEnabled = false // 사용자 입력 방지
        setupWidgets()
    }
    
    private func setNavigationBar() {
        navigationView.itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setDelegate() {
        addressTextField.delegate = self
        houseNicknameTextField.delegate = self
        threeDigitPriceField.delegate = self
        fourDigitPriceField.delegate = self
        fourDigitMonthlyRentField.delegate = self
        pyungTextField.delegate = self
        floorTextField.delegate = self
    }
    
    private func setData(detailDto: NoteDetailModel) {
        addressTextField.text = detailDto.roadAddress ?? ""
        addressDetailTextField.text = detailDto.addressDetail ?? ""
        houseNicknameTextField.text = detailDto.buildingName
        pyungTextField.text = (detailDto.pyong == nil) ? "" : "\(detailDto.pyong ?? 0)"
        floorTextField.text = detailDto.floor ?? ""
        setPriceTypeButton(priceType: detailDto.priceType)
        setPriceLabel(model: detailDto)
        checkNextButtonActivation()
    }
    
    private func setPriceTypeButton(priceType: String) {
        if priceType == "SALE" {
            saleButton.isSelected = true
            isMoveTypeSelected = saleButton.isSelected
            selectedPriceTypeButton = saleButton.isSelected ? saleButton : nil
            setSaleView()
        } else if priceType == "PULL_RENT" {
            jeonseButton.isSelected = true
            isMoveTypeSelected = jeonseButton.isSelected
            selectedPriceTypeButton = jeonseButton.isSelected ? jeonseButton : nil
            setJeonseView()
        } else if priceType == "MONTHLY_RENT" {
            monthlyRentButton.isSelected = true
            isMoveTypeSelected = monthlyRentButton.isSelected
            selectedPriceTypeButton = monthlyRentButton.isSelected ? monthlyRentButton : nil
            setmonthlyRentView()
        }
    }
    
    private func setPriceLabel(model: NoteDetailModel) {
        let (units, remainder) = model.price.twoSplitAmount()
        
        if model.monthlyRent == nil {
            // 전세 or 매매
            threeDigitPriceField.text = units
            fourDigitPriceField.text = remainder == "0" ? "" : remainder
            fourDigitMonthlyRentField.text = ""
        } else {
            // 월세
            threeDigitPriceField.text = units == "0" ? "" : units
            fourDigitPriceField.text = remainder
            fourDigitMonthlyRentField.text = model.monthlyRent?.oneSplitAmount() ?? ""
        }
        
        // 텍스트 필드 너비 설정
        let padding: CGFloat = 20
        let minimumWidth: CGFloat = 30
        let threeDigitPriceFieldMaximumWidth: CGFloat = 63
        let fourDigitPriceFieldMaximumWidth: CGFloat = 79
        
        let threeDigitPriceFieldSize = sizeForText(text: threeDigitPriceField.text ?? "", font: threeDigitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let fourDigitPriceFieldSize = sizeForText(text: fourDigitPriceField.text ?? "", font: fourDigitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let fourDigitMonthlyRentFieldSize = sizeForText(text: fourDigitMonthlyRentField.text ?? "", font: fourDigitMonthlyRentField.font ?? UIFont.systemFont(ofSize: 17)).width + padding

        // 최대 너비 제한
        let threeDigitPriceFieldFinalWidth: CGFloat = min(max(threeDigitPriceFieldSize, minimumWidth), threeDigitPriceFieldMaximumWidth)
        let fourDigitMonthlyRentFieldSizeFinalWidth: CGFloat = min(max(fourDigitMonthlyRentFieldSize, minimumWidth), fourDigitPriceFieldMaximumWidth)
        let fourDigitPriceFieldFinalWidth: CGFloat
        if fourDigitPriceField.text?.isEmpty ?? true {
            fourDigitPriceFieldFinalWidth = fourDigitPriceFieldMaximumWidth
        } else {
            fourDigitPriceFieldFinalWidth = min(max(fourDigitPriceFieldSize, minimumWidth), fourDigitPriceFieldMaximumWidth)
        }

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: threeDigitPriceField, constant: threeDigitPriceFieldFinalWidth)
        updateTextFieldWidthConstraint(for: fourDigitPriceField, constant: fourDigitPriceFieldFinalWidth)
        updateTextFieldWidthConstraint(for: fourDigitMonthlyRentField, constant: fourDigitMonthlyRentFieldSizeFinalWidth)
        
        view.layoutIfNeeded()
    }
    
    private func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        [navigationView,
         addressLabel,
         houseNicknameLabel,
         addressTextField,
         searchAddressButton,
         addressDetailTextField,
         explanationLabel,
         pyungLabel,
         floorAndPyungBaseView.with(
            floorTextField,
            pyungTextField
         ),
         houseNicknameTextField,
         priceLabel,
         priceView,
         priceView2,
         saveButton].forEach { view.addSubview($0) }
        setupLayout()
    }
    
    private func setupLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 주소 Label
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 주소 TextField
        addressTextField.snp.makeConstraints {
            $0.width.equalTo(225)
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
        }
        
        // 주소 검색하기 Button
        searchAddressButton.snp.makeConstraints {
            $0.width.equalTo(109)
            $0.height.equalTo(36)
            $0.leading.equalTo(addressTextField.snp.trailing).offset(8)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
        }
        
        // 상세주소 TextField
        addressDetailTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(searchAddressButton.snp.bottom).offset(8)
        }
        
        
        // 층수 평수
        pyungLabel.snp.makeConstraints {
            $0.top.equalTo(addressDetailTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(24)
        }
        
        floorAndPyungBaseView.snp.makeConstraints {
            $0.top.equalTo(pyungLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview()
        }
        
        floorTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        pyungTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(floorTextField.snp.right).offset(24)
        }

        // 집 별명 Label
        houseNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(floorAndPyungBaseView.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 별명 설명 Label
        explanationLabel.snp.makeConstraints {
            $0.leading.equalTo(houseNicknameLabel.snp.trailing).offset(1)
            $0.centerY.equalTo(houseNicknameLabel.snp.centerY)
        }
        
        // 집 별명 TextField
        houseNicknameTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(houseNicknameLabel.snp.bottom).offset(12)
        }
        
        // 가격 Label
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(houseNicknameTextField.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 입주 유형 Stack View
        moveTypeStackView = UIStackView(
            arrangedSubviews:
                [saleButton,
                 jeonseButton,
                 monthlyRentButton])
        
        moveTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        moveTypeStackView.axis = .horizontal
        moveTypeStackView.spacing = 8
        
        view.addSubview(moveTypeStackView)
        
        moveTypeStackView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 가격 View
        priceView.snp.makeConstraints {
            $0.top.equalTo(moveTypeStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.isHidden = true

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(
            arrangedSubviews:
                [threeDigitPriceField,
                 priceDetailLabels[3],
                 fourDigitPriceField,
                 priceDetailLabels[5]])

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
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.translatesAutoresizingMaskIntoConstraints = false
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5
    
        // 가격 입력 받는 TextField
        threeDigitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }

        fourDigitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }

        // 저장 버튼
        saveButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.centerX.equalTo(view.snp.centerX).offset(58.5)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }
    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    private func setButton() {
        // 입주 유형 카테고리에 속한 버튼
        priceTypeButtons = [saleButton, jeonseButton, monthlyRentButton]
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        guard !sender.isSelected else { return } // 이미 선택된 버튼이면 아무 동작도 하지 않음
        
        // 매물 유형 카테고리의 버튼일 경우
        if let selectedButton = selectedPriceTypeButton, selectedButton != sender {
            // 이전에 선택된 버튼이 있고 새로운 버튼과 다른 경우에는 이전 버튼의 선택을 해제
            selectedButton.isSelected = false
        }

        // 해당 버튼의 선택 여부를 반전
        sender.isSelected = !sender.isSelected
        isMoveTypeSelected = sender.isSelected

        // 버튼에 따라 가격 View 표시
        if sender == saleButton {
            threeDigitPriceField.text = ""
            fourDigitPriceField.text = ""
            fourDigitMonthlyRentField.text = ""
            setSaleView()
        } else if sender == jeonseButton {
            threeDigitPriceField.text = ""
            fourDigitPriceField.text = ""
            fourDigitMonthlyRentField.text = ""
            setJeonseView()
        } else if sender == monthlyRentButton {
            threeDigitPriceField.text = ""
            fourDigitPriceField.text = ""
            fourDigitMonthlyRentField.text = ""
            setmonthlyRentView()
        }
        selectedPriceTypeButton = sender.isSelected ? sender : nil
        
        // 텍스트 필드 관련
        view.endEditing(true)
        
        updateTextFieldWidthConstraint(for: threeDigitPriceField, constant: 63)
        updateTextFieldWidthConstraint(for: fourDigitPriceField, constant: 79)
        updateTextFieldWidthConstraint(for: fourDigitMonthlyRentField, constant: 79)
    }
    
    private func setSaleView() {
        priceView2.isHidden = true
        priceDetailLabel?.removeFromSuperview()
        priceDetailLabel = priceDetailLabels[0]
        checkPriceDetailLabel()
    }
    
    private func setJeonseView() {
        priceView2.isHidden = true
        priceDetailLabel?.removeFromSuperview()
        priceDetailLabel = priceDetailLabels[2]
        checkPriceDetailLabel()
    }

    private func setmonthlyRentView() {
        priceDetailLabel?.removeFromSuperview()
        priceView2.isHidden = false
        priceDetailLabel = priceDetailLabels[1]
        checkPriceDetailLabel()
        priceView2.addSubview(inputMonthlyRentStackView)
        priceDetailLabel2 = priceDetailLabels[4]
        inputMonthlyRentStackView.addArrangedSubview(fourDigitMonthlyRentField)
        inputMonthlyRentStackView.addArrangedSubview(priceDetailLabels[6])
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
            fourDigitMonthlyRentField.snp.makeConstraints {
                $0.top.equalTo(priceView2.snp.top).offset(4)
                $0.centerY.equalTo(priceView2.snp.centerY)
            }
        }
    }
    
    private func checkPriceDetailLabel() {
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
    
    @objc private func searchAddressButtonTapped(_ sender: UIButton) {
        let KakaoZipCodeVC = KakaoZipCodeViewController()
        present(KakaoZipCodeVC, animated: true)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        modifyImjang { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self else { return }
            guard let imjangId, let version = versionInfo?.version else { return }
            let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)

            let threeDigitPrice = Int(threeDigitPriceField.text ?? "") ?? 0
            let fourDigitPrice = Int(fourDigitPriceField.text ?? "") ?? 0
            var priceList = [String(threeDigitPrice * 100000000 + fourDigitPrice * 10000)]
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yy.MM.dd"
            let updatedAt = formatter.string(from: now)
            
            var priceType: String = ""
            
            if saleButton.isSelected {
                priceType = "매매" // 매매
            } else if jeonseButton.isSelected {
                priceType = "전세" // 전세
            } else if monthlyRentButton.isSelected {
                priceType = "월세" // 월세
            }
            
            delegate?.sendDetailData(
                imjangId: imjangId,
                model: .init(
                    isShared: false,
                    purposeType: "",
                    propertyType: "",
                    priceType: priceType,
                    buildingName: houseNicknameTextField.text ?? "",
                    images: [],
                    roadAddress: addressTextField.text ?? "",
                    addressDetail: addressDetailTextField.text ?? "",
                    price: String(threeDigitPrice * 100000000 + fourDigitPrice * 10000),
                    monthlyRent: fourDigitMonthlyRentField.text ?? "",
                    updatedAt: updatedAt,
                    floor: "",
                    pyong: 0
                )
            )
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkNextButtonActivation() {
        // 필드가 비어있거나 공백만으로 구성되어 있는지 확인
        let addressTextFieldEmpty = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let houseNicknameTextFieldEmpty = houseNicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        // 필드가 비어있는지 확인
        let threeDigitPriceFieldEmpty = threeDigitPriceField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let fourDigitPriceFieldEmpty = fourDigitPriceField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        let pyungFieldEmpty = pyungTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let floorFieldEmpty = floorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        // 가격이 0으로 시작하지 않는지 확인
        let fourDigitPriceDoesNotStartWithZero = fourDigitPriceField.text?.first != "0"
        
        let fourDigitPriceFieldState = !fourDigitPriceFieldEmpty && fourDigitPriceDoesNotStartWithZero
        let pyungAndFloorFieldState = !pyungFieldEmpty && !floorFieldEmpty
        

        // 텍스트 필드 입력 여부에 따라 다음으로 버튼 활성화 여부 결정
        let allTextFieldsFilled = !addressTextFieldEmpty && !houseNicknameTextFieldEmpty &&  fourDigitPriceFieldState && pyungAndFloorFieldState
        
        // 모든 조건이 충족되었을 때 다음으로 버튼 활성화
        if allTextFieldsFilled {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .gray500
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .gray300
        }
    }
}


extension EditBasicInfoDetailViewController: UITextFieldDelegate {
    func removeAllWidthConstraints(for textField: UITextField) {
        textField.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                textField.removeConstraint(constraint)
            }
        }
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
        removeAllWidthConstraints(for: textField)
        let widthConstraint = textField.widthAnchor.constraint(equalToConstant: constant)
        widthConstraint.isActive = true
        textField.superview?.layoutIfNeeded()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        // 각 텍스트 필드에 대한 최소, 최대 너비 설정
        let minimumWidth: CGFloat = 30 // 최소 너비
        let padding: CGFloat = 20
        var maximumWidth: CGFloat = 79 // 네 자릿수 텍스트 필드의 최대 너비

        if textField == threeDigitPriceField {
            maximumWidth = 63 // 세 자릿수 텍스트 필드의 최대 너비
        }
        
        // 텍스트 길이에 따라 적절한 너비 계산
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        let size = sizeForText(text: newText, font: textField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let calculatedWidth = max(size, minimumWidth) // 텍스트 길이와 최소 너비 중 큰 값을 선택
        let finalWidth = min(calculatedWidth, maximumWidth) // 최대 너비 제한

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: textField, constant: finalWidth)

        // 레이아웃 업데이트
        view.layoutIfNeeded()
        
        // 백스페이스 처리
        if string.isEmpty {
            return true
        }
        
        // textField에 따라 글자 수 제한
        if textField == houseNicknameTextField {
            guard text.count + string.count - range.length <= 12 else { return false }
        } else if textField == threeDigitPriceField || textField == fourDigitPriceField || textField == fourDigitMonthlyRentField {
            // 숫자만 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else { return false }
            
            if textField == threeDigitPriceField {
                guard text.count + string.count - range.length <= 3 else { return false }
            } else if textField == fourDigitPriceField || textField == fourDigitMonthlyRentField {
                guard text.count + string.count - range.length <= 4 else { return false }
            }
        }
        return true
    }
    
    private func sizeForText(text: String, font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: fontAttributes)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else { return }
        if textField == threeDigitPriceField {
            textField.placeholder = "000"
            updateTextFieldWidthConstraint(for: textField, constant: 63) // 기존 너비로 복원
        } else if textField == fourDigitPriceField || textField == fourDigitMonthlyRentField {
            textField.placeholder = "0000"
            updateTextFieldWidthConstraint(for: textField, constant: 79)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkNextButtonActivation()
    }
}

protocol SendDetailEditData {
    func sendDetailData(imjangId: Int, model: NoteDetailModel)
}
