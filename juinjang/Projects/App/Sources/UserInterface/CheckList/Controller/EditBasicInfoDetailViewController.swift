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
import RxRelay

final class EditBasicInfoDetailViewController: BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "정보 수정하기"
    }
    private let noteRepository = NoteRepository()
    private let disposeBag = DisposeBag()
    
    var checkSaveTimeRelay: PublishRelay<Void>?
    
    var postModel: PostCodeResponseModel?
    
    var initialEditModel: EditBasicInfoModel? // 초기 정보 수정 모델
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
    weak var delegate: SendDetailEditData?

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
    private let floorTextField = RoundedPriceTextField(unitType: .floor, placeholder: "00")
    private let pyungTextField = RoundedPriceTextField(unitType: .pyung, placeholder: "000")

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
    
    var addressText: String? {
        didSet {
            addressTextField.text = addressText ?? ""
            setupAddressDetailTextPlaceHolder()
        }
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
        $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    lazy var houseNicknameTextField = UITextField().then {
        let customFont = UIFont.pretendard(size: 16, weight: .medium)
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
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    func configureButton(_ button: UIButton, normalImage: UIImage?, selectedImage: UIImage?, action: Selector) {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
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
    
    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(cancelbuttonDidTap), for: .touchUpInside)
    }
    
    private var initialBuildingName: String = ""
    
    // -MARK: API 요청
    func getImjang() {
        guard let imjangId = imjangId else { return }
        
        noteRepository
            .retrieveNoteDetail(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, response) in
                self.initialEditModel = .init(noteDetailModel: response)
                self.postModel = response.toPostCodeModel
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

        let monthlyRent = monthlyRentPriceString()
        let roadAddress = addressTextField.text ?? ""
        let addressDetail = addressDetailTextField.text ?? ""
        let bindingNickname = houseNicknameTextField.text ?? ""
        let nickname = bindingNickname.isEmpty ? initialBuildingName : bindingNickname
        let floor = floorTextField.text ?? ""
        let pyong = Int(pyungTextField.text ?? "")
        
        let parameter: NoteUpdateRequestDTO = .init(
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
        
        noteRepository
            .updateImjang(
                noteID: imjangId,
                param: parameter
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
    
    private func mergedPriceString(threeDigit: String?, fourDigit: String?) -> String? {
        let hundredMillion = Int(threeDigit?.trimmingCharacters(in: .whitespaces) ?? "")  // 억
        let tenThousand = Int(fourDigit?.trimmingCharacters(in: .whitespaces) ?? "")    // 만원
        
        guard hundredMillion != nil || tenThousand != nil else {
            return nil
        }

        let totalPrice = (hundredMillion ?? 0) * 100_000_000 + (tenThousand ?? 0) * 10_000
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
        addressDetailTextField.delegate = self
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
        initialBuildingName = detailDto.buildingName
        pyungTextField.text = (detailDto.pyong == nil) ? "" : "\(detailDto.pyong ?? 0)"
        floorTextField.text = detailDto.floor ?? ""
        
        if addressTextField.text == "" && addressDetailTextField.text == "" {
            setupAddressDetailTextPlaceHolder()
        }
        
        setPriceTypeButton(priceType: detailDto.priceType)
        setPriceLabel(model: detailDto)
    }
    
    private func resetPriceTypeButton() {
        saleButton.isSelected = false
        jeonseButton.isSelected = false
        monthlyRentButton.isSelected = false
        selectedPriceTypeButton = nil
        selectedPriceType = nil
    }
    
    private func setPriceTypeButton(priceType: String) {
        if priceType == "SALE" {
            saleButton.isSelected = true
            isMoveTypeSelected = saleButton.isSelected
            selectedPriceTypeButton = saleButton.isSelected ? saleButton : nil
            selectedPriceType = 0
            setSaleView()
        } else if priceType == "PULL_RENT" {
            jeonseButton.isSelected = true
            isMoveTypeSelected = jeonseButton.isSelected
            selectedPriceTypeButton = jeonseButton.isSelected ? jeonseButton : nil
            selectedPriceType = 1
            setJeonseView()
        } else if priceType == "MONTHLY_RENT" {
            monthlyRentButton.isSelected = true
            isMoveTypeSelected = monthlyRentButton.isSelected
            selectedPriceTypeButton = monthlyRentButton.isSelected ? monthlyRentButton : nil
            selectedPriceType = 2
            setmonthlyRentView()
        }
    }
    
    private func setupAddressDetailTextPlaceHolder() {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray300,
            .font: customFont
        ]
        let placeHolderText = addressTextField.text == "" ? "도로명 주소를 먼저 입력해 주세요." : "상세 주소"
        addressDetailTextField.isEnabled = !(addressTextField.text == "")
        addressDetailTextField.backgroundColor = addressTextField.text == ""
        ? .gray100
        : .mainWhite
        
        addressDetailTextField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: attributes)
    }
    
    private func setPriceLabel(model: NoteDetailModel) {
        let splitPrice = model.price?.twoSplitAmount()
        let units = splitPrice?.0
        let remainder = splitPrice?.1
        
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
         saveButton,
         cancelButton].forEach { view.addSubview($0) }
        setupLayout()
    }
    
    private func setupLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 주소 Label
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(14)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 주소 TextField
        addressTextField.snp.makeConstraints {
            $0.trailing.equalTo(searchAddressButton.snp.leading).offset(-8)
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
        }
        
        // 주소 검색하기 Button
        searchAddressButton.snp.makeConstraints {
            $0.width.equalTo(109)
            $0.height.equalTo(36)
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

        inputPriceStackView.axis = .horizontal
        inputPriceStackView.spacing = 5

        priceView.addSubview(inputPriceStackView)

        if let priceDetailLabel = priceDetailLabel {
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
            }
        }
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5

        cancelButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.width.equalTo(109)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        saveButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    private func setButton() {
        // 입주 유형 카테고리에 속한 버튼
        priceTypeButtons = [saleButton, jeonseButton, monthlyRentButton]
    }
    
    @objc private func cancelbuttonDidTap(_ sender: UIButton) {
        resetPriceTypeButton()
        getImjang()
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
            selectedPriceType = 0
            setSaleView()
        } else if sender == jeonseButton {
            threeDigitPriceField.text = ""
            fourDigitPriceField.text = ""
            fourDigitMonthlyRentField.text = ""
            selectedPriceType = 1
            setJeonseView()
        } else if sender == monthlyRentButton {
            threeDigitPriceField.text = ""
            fourDigitPriceField.text = ""
            fourDigitMonthlyRentField.text = ""
            selectedPriceType = 2
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
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(priceView2.snp.leading).offset(24)
            }
            inputMonthlyRentStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel2.snp.trailing).offset(16)
                $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.1)
                $0.centerY.equalTo(priceView2.snp.centerY)
            }
            fourDigitMonthlyRentField.snp.makeConstraints {
                $0.centerY.equalTo(priceView2.snp.centerY)
            }
        }
    }
    
    private func checkPriceDetailLabel() {
        if let priceDetailLabel = priceDetailLabel {
            priceView.addSubview(priceDetailLabel)
            priceView.addSubview(inputPriceStackView)
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
                $0.centerY.equalTo(priceView.snp.centerY)
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

            let threeDigitPrice = Int(threeDigitPriceField.text ?? "") ?? 0
            let fourDigitPrice = Int(fourDigitPriceField.text ?? "") ?? 0
            
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
                    monthlyRent: monthlyRentPriceString(),
                    updatedAt: updatedAt,
                    floor: nil,
                    pyong: nil,
                    bcode: nil,
                    sido: nil,
                    sigungu: nil,
                    bname1: nil,
                    bname2: nil
                )
            )
            print("월세는", monthlyRentPriceString() ?? "")
            
            self.checkSaveTimeRelay?.accept(())
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func monthlyRentPriceString() -> String? {
        guard let price = Int(fourDigitMonthlyRentField.text ?? "") else { return nil }
        let priceString = String(price * 10000)
        return priceString
    }
    
    private func isEditedComparedToInitial() -> Bool {
        // 현재 값 스냅샷
        let current = EditBasicInfoModel(
            postModel: postModel,
            address: addressTextField.text,
            addressDetail: addressDetailTextField.text,
            pyung: pyungTextField.text,
            floor: floorTextField.text,
            houseNickname: houseNicknameTextField.text,
            priceType: selectedPriceType,
            threeDigitNumber: threeDigitPriceField.text,
            fourDigitNumber: fourDigitPriceField.text,
            monthlyRent: fourDigitMonthlyRentField.text
        )
        
        // 변경됨 여부(초기값이 없으면 “새 작성”이라 간주해 변경됨 = true)
        guard let initial = initialEditModel else { return true }
        return initial != current
    }
    
    private func isFormInputValid() -> Bool {
        // 공통 필수
        let commonOK =
        !(addressTextField.text.isBlank) &&
        !(addressDetailTextField.text.isBlank) &&
        !(houseNicknameTextField.text.isBlank) &&
        !(pyungTextField.text.isBlank) &&
        !(floorTextField.text.isBlank)
        
        // 금액(억/아래 4자리) : 둘 중 하나라도 1 이상이면 OK
        let three = Int(threeDigitPriceField.text ?? "") ?? 0
        let four  = Int(fourDigitPriceField.text  ?? "") ?? 0
        let priceOK = (three > 0 || four > 0)
        
        // 월세: 월세 타입(2)일 때만 체크 (값이 비어있지 않고 1 이상 권장 시 아래 라인 사용)
        let monthlyOK: Bool = {
            guard selectedPriceType == 2 else { return true }
            // 비어있지 않기만 체크하려면:
            // return !(fourDigitMonthlyRentField.text.isBlank)
            // 1 이상이어야 한다면:
            let monthly = Int(fourDigitMonthlyRentField.text ?? "") ?? 0
            return monthly > 0
        }()
        
        return commonOK && priceOK && monthlyOK
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
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
            guard text.count + string.count - range.length <= 30 else { return false }
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
    
    @objc private func textDidChange(_ textField: UITextField) {
        setupAddressDetailTextPlaceHolder()
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
}

protocol SendDetailEditData: AnyObject {
    func sendDetailData(imjangId: Int, model: NoteDetailModel)
}
