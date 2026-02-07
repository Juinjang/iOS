//
//  EditBasicInfoViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

import UIKit
import Alamofire
import RxSwift
import SnapKit
import Then
import RxRelay

final class EditBasicInfoViewController: BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "정보 수정하기"
    }
    private let noteRepository = NoteRepository()
    private let disposeBag = DisposeBag()
    
    var checkSaveTimeRelay: PublishRelay<Void>?
    var transactionModel = TransactionModel()
    var imjangId: Int? = nil
    var versionInfo: VersionInfo? = nil
    
    var moveTypeStackView: UIStackView!
    var inputPriceStackView: UIStackView!
    var inputMonthlyRentStackView: UIStackView!
    
    var priceDetailLabel: UILabel?
    var priceDetailLabel2: UILabel?
    
    weak var delegate: SendEditData?
    
    var postModel: PostCodeResponseModel? {
        didSet {
            checkNextButtonActivation()
        }
    }
    
    var initialEditModel: EditBasicInfoModel? // 초기 정보 수정 모델

    let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = .gray600
        label.font = .pretendard(size: 18, weight: .semiBold)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    private func secondConfigureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = .gray500
        label.font = .pretendard(size: 16, weight: .semiBold)
        
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

        let customFont = .pretendard(size: 14, weight: .medium) ?? UIFont.systemFont(ofSize: 14)
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
        
        $0.titleLabel?.font = .pretendard(size: 14, weight: .semiBold)
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
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray300,
            .font: UIFont.pretendard(size: 16, weight: .medium)
        ]
        $0.attributedPlaceholder = NSAttributedString(string: "30자 이내", attributes: attributes)
        $0.layer.backgroundColor = UIColor.mainWhite.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.stroke2.cgColor
        $0.textColor = .gray500
        $0.font = .pretendard(size: 16, weight: .medium)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    lazy var priceView = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100.cgColor
    }
    
    lazy var priceView2 = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100.cgColor
    }
    
    func configurePriceLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 55, height: 22)
        label.textColor = .gray500
        label.font = .pretendard(size: 16, weight: .semiBold)
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
                secondConfigureLabel($0, text: text)
                if text == "실거래가" {
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
    private func getImjang() {
        guard let imjangId = imjangId else { return }
        
        noteRepository
            .retrieveNoteDetail(noteID: imjangId)
            .subscribe(with: self) { (self, response) in
                self.initialEditModel = EditBasicInfoModel(noteDetailModel: response)
                self.postModel = response.toPostCodeModel
                self.setData(detailDto: response)
            }
            .disposed(by: disposeBag)
    }
    
    func modifyImjang(completionHandler: @escaping (NetworkError?) -> Void) {
        guard let imjangId = imjangId else { return }
        
        let price = mergedPriceString(
            threeDigit: threeDigitPriceField.text,
            fourDigit: fourDigitPriceField.text
        )

        let roadAddress = addressTextField.text ?? ""
        let addressDetail = addressDetailTextField.text ?? ""
        let nickname = houseNicknameTextField.text ?? ""
        let floor = floorTextField.text ?? ""
        let pyong = Int(pyungTextField.text ?? "") ?? 0
        
        noteRepository
            .updateImjang(
                noteID: imjangId,
                param: .init(
                    priceType: "MARKET_PRICE",
                    price: price,
                    monthlyRent: nil,
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
                with: self,
                onCompleted: { _ in
                    completionHandler(nil)
                    self.checkSaveTimeRelay?.accept(())
                    
                }, onError: { (self, error) in
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
            .subscribe(with: self) { (self,action) in
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
        pyungTextField.delegate = self
        floorTextField.delegate = self
    }
    
    private func setData(detailDto: NoteDetailModel) {
        addressTextField.text = detailDto.roadAddress ?? ""
        addressDetailTextField.text = detailDto.addressDetail ?? ""
        houseNicknameTextField.text = detailDto.buildingName
        floorTextField.text = detailDto.floor ?? ""
        pyungTextField.text = (detailDto.pyong == nil) ? "" : "\(detailDto.pyong ?? 0)"
        
        if addressTextField.text == "" && addressDetailTextField.text == "" {
            setupAddressDetailTextPlaceHolder()
        }
        
        setPriceLabel(model: detailDto)
        checkNextButtonActivation()
    }
    
    private func setPriceLabel(model: NoteDetailModel) {
        let (units, remainder) = model.price.twoSplitAmount()
        
        threeDigitPriceField.text = units == "0" ? "" : units
        fourDigitPriceField.text = remainder == "0" ? "" : remainder
        
        // 텍스트 필드 너비 설정
        let padding: CGFloat = 20
        let minimumWidth: CGFloat = 30
        let threeDigitPriceFieldMaximumWidth: CGFloat = 63
        let fourDigitPriceFieldMaximumWidth: CGFloat = 79
        
        let threeDigitPriceFieldSize = (threeDigitPriceField.text ?? "").size(forFont: threeDigitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let fourDigitPriceFieldSize = (fourDigitPriceField.text ?? "").size(forFont: fourDigitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding

        // 최대 너비 제한
        let threeDigitPriceFieldFinalWidth: CGFloat = min(max(threeDigitPriceFieldSize, minimumWidth), threeDigitPriceFieldMaximumWidth)
        let fourDigitPriceFieldFinalWidth: CGFloat
        if fourDigitPriceField.text?.isEmpty ?? true {
            fourDigitPriceFieldFinalWidth = fourDigitPriceFieldMaximumWidth
        } else {
            fourDigitPriceFieldFinalWidth = min(max(fourDigitPriceFieldSize, minimumWidth), fourDigitPriceFieldMaximumWidth)
        }

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: threeDigitPriceField, constant: threeDigitPriceFieldFinalWidth)
        updateTextFieldWidthConstraint(for: fourDigitPriceField, constant: fourDigitPriceFieldFinalWidth)
        
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
         pyungLabel,
         floorAndPyungBaseView.with(
            pyungTextField,
            floorTextField
         ),
         explanationLabel,
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
            $0.top.equalTo(navigationView.snp.bottom).offset(14)
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

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(
            arrangedSubviews:
                [threeDigitPriceField,
                 priceDetailLabels[4],
                 fourDigitPriceField,
                 priceDetailLabels[6]])

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
            
            let threeDisitPrice = Int(threeDigitPriceField.text ?? "") ?? 0
            let fourDisitPrice = Int(fourDigitPriceField.text ?? "") ?? 0
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yy.MM.dd"
            let updatedAt = formatter.string(from: now)
            
            delegate?.sendData(
                imjangId: imjangId,
                model: .init(
                    isShared: false,
                    purposeType: "",
                    propertyType: "",
                    priceType: "",
                    buildingName: houseNicknameTextField.text ?? "",
                    images: [],
                    roadAddress: addressTextField.text ?? "",
                    addressDetail: addressDetailTextField.text ?? "",
                    price: String(threeDisitPrice * 100000000 + fourDisitPrice * 10000),
                    monthlyRent: "",
                    updatedAt: updatedAt,
                    floor: "",
                    pyong: 0,
                    bcode: nil,
                    sido: nil,
                    sigungu: nil,
                    bname1: nil,
                    bname2: nil
                )
            )
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupAddressDetailTextPlaceHolder() {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray300,
            .font: customFont
        ]
        let placeHolderText = addressTextField.text == "" ? "도로명 주소를 먼저 입력해 주세요." : "상세 주소"
        addressDetailTextField.backgroundColor = addressDetailTextField.text == ""
        ? .gray100
        : .mainWhite
        
        addressDetailTextField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: attributes)
    }
    
    private func checkNextButtonActivation() {
        let shouldEnable = isFormInputValid() && isEditedComparedToInitial()
        saveButton.isEnabled = shouldEnable
        saveButton.backgroundColor = shouldEnable ? .gray500 : .gray300
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
            priceType: nil,
            threeDigitNumber: threeDigitPriceField.text,
            fourDigitNumber: fourDigitPriceField.text,
            monthlyRent: nil
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
        
        return commonOK && priceOK
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension EditBasicInfoViewController: UITextFieldDelegate {
    func removeAllWidthConstraints(for textField: UITextField) {
        textField.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                textField.removeConstraint(constraint)
            }
        }
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField,
                                        constant: CGFloat) {
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
        
        // 텍스트 길이에 따라 너비 계산
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        let size = newText.size(forFont: textField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
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
        } else if textField == threeDigitPriceField || textField == fourDigitPriceField {
            // 숫자만 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else { return false }
            
            if textField == threeDigitPriceField {
                guard text.count + string.count - range.length <= 3 else { return false }
            } else if textField == fourDigitPriceField {
                guard text.count + string.count - range.length <= 4 else { return false }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else { return }

        if textField == threeDigitPriceField {
            textField.placeholder = "000"
            updateTextFieldWidthConstraint(for: textField, constant: 63) // 기존 너비로 복원
        } else if textField == fourDigitPriceField {
            textField.placeholder = "0000"
            updateTextFieldWidthConstraint(for: textField, constant: 79)
        }
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        setupAddressDetailTextPlaceHolder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkNextButtonActivation()
    }
}

protocol SendEditData: AnyObject {
    func sendData(imjangId: Int, model: NoteDetailModel)
}
