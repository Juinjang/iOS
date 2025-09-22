//
//  OpenNewPage2ViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/03.
//

import UIKit
import Then
import SnapKit
import Alamofire
import AmplitudeSwift
import RxSwift

final class OpenNewPage2ViewController: BaseViewController, WarningMessageDelegate {
    var newImjang: PostDto?
    var versionInfo: VersionInfo?
    var imjangId: Int? = nil
    
    private let repository = NoteRepository()
    private let disposeBag = DisposeBag()
    
    var postCodeModel: PostCodeResponseModel? {
        didSet {
            checkNextButtonActivation()
        }
    }
    
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "새 페이지 펼치기"
    }
    
    // -MARK: API 요청
    func createImjang(completionHandler: @escaping (Int?, NetworkError?) -> Void) {
        guard let newImjang = newImjang else { return }
        
        let address = addressTextField.text ?? ""
        let nickname = houseNicknameTextField.text ?? ""
        
        amplitude.track(
            event: BaseEvent(
                eventType: AmpliEventName.button_clicked.rawValue,
                eventProperties: [
                    AmpliEventProp.address_id.rawValue: address,
                    AmpliEventProp.address_name.rawValue: nickname
                ]
            )
        )
        
        // 이전 뷰 컨트롤러에서 가져온 값들을 parameters에 할당
        let parameter = NoteCreateRequestDTO(
            purposeType: newImjang.purposeTypeToString,
            propertyType: newImjang.propertyTypeToString,
            priceType: newImjang.priceTypeToString,
            price: newImjang.price,
            monthlyRent: newImjang.monthlyRent,
            roadAddress: postCodeModel?.address ?? "",
            addressDetail: (addressDetailTextField.text?.isEmpty == false) ? addressDetailTextField.text : nil,
            bcode: postCodeModel?.bcode ?? "",
            nickname: nickname,
            floor: floorTextField.text ?? "",
            pyong: Int(pyungTextField.text ?? "") ?? 0,
            sido: postCodeModel?.sido,
            sigungu: postCodeModel?.sigungu,
            bname1: postCodeModel?.bname1,
            bname2: postCodeModel?.bname2
        )
        
        repository.createNote(
            param: parameter
        ).asObservable()
            .subscribe(with: self) { (self, responseModel) in
                self.imjangId = responseModel.noteId
                completionHandler(responseModel.noteId, nil)
            }
            .disposed(by: disposeBag)
    }
    
    var backgroundImageViewWidthConstraint: NSLayoutConstraint? // 배경 이미지의 너비 제약조건
    var transactionModel = TransactionModel()
    
    func makeImageView(_ imageView: UIImageView, type: OpenNewPageImageType) {
        imageView.image = type.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
    }
    
    lazy var backgroundImageView = UIImageView().then {
        let backgroundImage = UIImage.OpenNewPage.creationBackground
        $0.image = backgroundImage
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
    }
    
    lazy var investorImageView = UIImageView().then {
        makeImageView($0, type: .investor)
    }
    
    lazy var movingUserImageView = UIImageView().then {
        makeImageView($0, type: .userMovingInDirectly)
    }
    
    lazy var apartmentImageView = UIImageView().then {
        makeImageView($0, type: .apartment)
    }
    
    lazy var villaImageView = UIImageView().then {
        makeImageView($0, type: .villa)
    }
    
    lazy var officetelImageView = UIImageView().then {
        makeImageView($0, type: .officetel)
    }
    
    lazy var houseImageView = UIImageView().then {
        makeImageView($0, type: .house)
    }
    
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = .gray600
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }

    lazy var addressLabel = UILabel().then {
        configureLabel($0, text: "주소")
    }
    
    private let pyungLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.fontSize = 18
        $0.text = "층수·평수"
    }
    
    private let floorTextField = RoundedPriceTextField(
        unitType: .floor,
        placeholder: "00"
    )
    
    private let pyungTextField = RoundedPriceTextField(
        unitType: .pyung,
        placeholder: "000"
    )

    lazy var houseNicknameLabel = UILabel().then {
        configureLabel($0, text: "집 별명")
    }
    
    lazy var explanationLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "※ 별명은 나에게만 보여요.")
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
        $0.layer.borderColor = UIColor.gray200.cgColor
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
        $0.layer.borderColor = UIColor.gray200.cgColor
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
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.textColor = .gray500
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
            $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var backButton = UIButton().then {
        $0.setTitle("이전으로", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.isEnabled = false
        
        $0.backgroundColor = .gray300
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    let warningPopup = OpenNewPagePopupViewController()
                    warningPopup.warningDelegate = self
                    warningPopup.modalPresentationStyle = .overCurrentContext
                    self.present(warningPopup, animated: false, completion: nil)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        addressTextField.delegate = self
        addressTextField.isUserInteractionEnabled = false // 사용자 입력 방지
        pyungTextField.delegate = self
        floorTextField.delegate = self
        houseNicknameTextField.delegate = self
        updateImageViewsFromModel()
        setupWidgets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginVC), name: .refreshTokenExpired, object: nil)
        amplitude.track(
            event: BaseEvent(
                eventType: AmpliEventName.page_viewed.rawValue,
                eventProperties: [AmpliEventProp.info_page_2.rawValue:"true"]
            )
        )  // 페이지 진입
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        let widgets: [UIView] = [
            navigationView,
            addressLabel,
            houseNicknameLabel,
            backgroundImageView,
            investorImageView,
            movingUserImageView,
            apartmentImageView,
            villaImageView,
            officetelImageView,
            houseImageView,
            addressTextField,
            searchAddressButton,
            addressDetailTextField,
            pyungLabel,
            floorTextField,
            pyungTextField,
            explanationLabel,
            houseNicknameTextField,
            backButton,
            nextButton]
        widgets.forEach { view.addSubview($0) }
        setupLayout()
    }
    
    func setupLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(46)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 배경 ImageView
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(view.snp.height).multipliedBy(0.28)
        }
        
        // 사람 ImageView
        investorImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-15)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-258.67)
            $0.top.equalTo(backgroundImageView.snp.top).offset(105)
        }
        
        movingUserImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-14.84)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-255.55)
            $0.top.equalTo(backgroundImageView.snp.top).offset(110)
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
        
        // 주소 Label
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(21)
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
        
        
        // 층수 평수 Label
        
        pyungLabel.snp.makeConstraints {
            $0.top.equalTo(addressDetailTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(24)
        }
        
        floorTextField.snp.makeConstraints {
            $0.top.equalTo(pyungLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
        }
        
        pyungTextField.snp.makeConstraints {
            $0.top.equalTo(pyungLabel.snp.bottom).offset(16)
            $0.left.equalTo(floorTextField.snp.right).offset(24)
        }
        

        // 집 별명 Label
        houseNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(floorTextField.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 별명 설명 Label
        explanationLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(82)
            $0.centerY.equalTo(houseNicknameLabel.snp.centerY)
        }
        
        // 집 별명 TextField
        houseNicknameTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(houseNicknameLabel.snp.bottom).offset(12)
        }
        
        // 이전으로 버튼
        backButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.width.equalTo(108)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 다음으로 버튼
        nextButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func updateImageViewsFromModel() {
        hideAllImageViews()
        
        // 사람
        if transactionModel.selectedPurposeButtonImage == investorImageView.image {
            investorImageView.isHidden = false
        } else {
            movingUserImageView.isHidden = false
        }
        // 건물
        if transactionModel.selectedPropertyTypeButtonImage == apartmentImageView.image {
            apartmentImageView.isHidden = false
        } else if transactionModel.selectedPropertyTypeButtonImage == villaImageView.image {
            villaImageView.isHidden = false
        } else if transactionModel.selectedPropertyTypeButtonImage == officetelImageView.image {
            officetelImageView.isHidden = false
        } else {
            houseImageView.isHidden = false
        }
    }
    
    func hideAllImageViews() {
        investorImageView.isHidden = true
        movingUserImageView.isHidden = true
        apartmentImageView.isHidden = true
        villaImageView.isHidden = true
        officetelImageView.isHidden = true
        houseImageView.isHidden = true
    }
    
    func checkNextButtonActivation() {
        // 필드가 비어있거나 공백만으로 구성되어 있는지 확인
        let addressTextFieldEmpty = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let houseNicknameTextFieldEmpty = houseNicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        let floorTextFieldEmpty = floorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let pyungTextFieldEmpty = pyungTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        // 텍스트 필드 입력 여부에 따라 다음으로 버튼 활성화 여부 결정
        let allTextFieldsFilled = !addressTextFieldEmpty && !houseNicknameTextFieldEmpty && !floorTextFieldEmpty && !pyungTextFieldEmpty
        
        // 모든 조건이 충족되었을 때 다음으로 버튼 활성화
        if allTextFieldsFilled {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .gray500
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray300
        }
    }
    
    @objc func searchAddressButtonTapped(_ sender: UIButton) {
        let KakaoZipCodeVC = KakaoZipCodeViewController()
        present(KakaoZipCodeVC, animated: true)
    }
    
    @objc func backToPageTapped(_ sender: UIButton) {
        let warningPopup = OpenNewPagePopupViewController()
        warningPopup.warningDelegate = self
        warningPopup.modalPresentationStyle = .overCurrentContext
        present(warningPopup, animated: false, completion: nil)
    }
    
    func getWarningMessage() -> String {
        if let imjangNoteVC = navigationController?.viewControllers.first(where: { $0 is ImjangListViewController }) {
            // MainViewController -> ImjangListViewController -> OpenNewPageViewController -> OpenNewPage2ViewController: 임장노트에서 생성한 경우
            return "임장노트로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
        } else if let openNewPageVC = navigationController?.viewControllers.first(where: { $0 is OpenNewPageViewController }) {
            // MainViewController -> OpenNewPageViewController -> OpenNewPage2ViewController: 메인에서 생성한 경우
            return "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
        } else {
            // 기본은 메인으로 향하는 걸로 설정
            return "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
        }
    }

    func navigateBack() {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 3 {
            navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }

    @objc func backButtonTapped(_ sender: UIButton) {
        amplitude.track(
            event: BaseEvent(
                eventType: AmpliEventName.page_viewed.rawValue,
                eventProperties: [AmpliEventProp.info_page_2.rawValue:"false"]
            )
        )  // 페이지 진입
        navigationController?.popViewController(animated: true)
    }
    
    override func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            amplitude.track(
                event: BaseEvent(
                    eventType: AmpliEventName.page_viewed.rawValue,
                    eventProperties: [AmpliEventProp.info_page_2.rawValue:"false"]
                )
            )  // 페이지 진입
            navigationController?.popViewController(animated: true)
        }
    }
    
    func determineVersion(purposeType: Int, propertyType: Int) -> Int {
        if purposeType == 0 {
            // 부동산 투자 - version: 0
            return 0
        } else if purposeType == 1 {
            // 직접 입주
            if propertyType == 0 || propertyType == 3 {
                // 아파트, 단독주택 - version: 0
                return 0
            } else if propertyType == 1 || propertyType == 2 {
                // 빌라, 오피스텔 - version: 1
                return 1
            }
        }
        return -1 // 예외 처리
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        createImjang { imjangId, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let imjangId, let newImjang = self.newImjang else { return }
            let version = self.determineVersion(purposeType: newImjang.purposeType, propertyType: newImjang.propertyType)
            let ImjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
            ImjangNoteVC.previousVCType = .createImjangVC
            ImjangNoteVC.imjangId = imjangId
            ImjangNoteVC.versionInfo = self.versionInfo
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(ImjangNoteVC, animated: true)
            
            amplitude.track(event: BaseEvent(eventType: AmpliEventName.page_viewed.rawValue, eventProperties: [
                AmpliEventProp.checklist_page.rawValue: "true"
            ]))
        }
    }
}


extension OpenNewPage2ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // 글자 수 제한
        guard textField.text!.count < 12 else { return false }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 모든 조건을 검사하여 버튼 상태 변경
        checkNextButtonActivation()
    }
}
