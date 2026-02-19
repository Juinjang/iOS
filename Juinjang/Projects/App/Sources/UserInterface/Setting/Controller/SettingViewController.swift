//
//  SettingViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/9/24.
//

import UIKit
import Then
import SnapKit
import Alamofire
import RxSwift
import Kingfisher

struct YourResponseModel: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultModel?
}

struct ResultModel: Codable {
    let nickname: String
    let email: String
    let provider: String
    let image: String
}

protocol LogoutDelegate: AnyObject {
    func logout()
}

final class SettingViewController : BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LogoutDelegate {
    static let id = "SettingViewController"
    
    private let userRepository = UserRepository()
    private let navigationView = DefaultNavigationView().then {
        $0.title = "설정"
        $0.leftItem = [.pop]
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //MARK: - 프로필 사진, 닉네임
    private let profileImageView = UIImageView().then {
        $0.image = UIImage.Setting.profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 33
        $0.clipsToBounds = true
    }
    private let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.main, for: .normal)
        $0.titleLabel?.font = .pretendard(size: 14, weight: .medium)
    } //수정 버튼 눌렀을 때 갤러리 들어가게
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
    }
    private let nicknameValueLabel = UILabel().then {
        $0.text = UserDefaultManager.shared.nickname
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray500
    }
    private let nicknameTextField = UITextField().then {
        $0.backgroundColor = .mainWhite
        $0.returnKeyType = .done
        $0.placeholder = "8자 이내"
        $0.text = UserDefaultManager.shared.nickname
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    private let nicknameWarnImageView = UIImageView().then {
        $0.image = UIImage.Setting.warn
    }
    private let nicknameWarnLabel = UILabel().then {
        $0.text = "닉네임은 8자 이내로 입력해 주세요."
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .main
    }
    private let nicknameSameWarnLabel = UILabel().then {
        $0.text = "동일한 닉네임이 존재해요"
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .main
    }
    
    private let saveButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("변경", for: .normal)
        $0.backgroundColor = .gray450
        $0.titleLabel?.font = .pretendard(size: 14, weight: .semiBold)
    }
    private let line1 = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let oneLineIntroTextFieldView = SettingEditableFieldView(
        title: "한줄소개",
        defaultPlaceholder: "한줄소개를 입력해 보세요",
        editingPlaceholder: "20자 이내",
        warnningText: "20자 이내로 입력해 주세요.",
        maxTextCount: 20
    )
    
    //MARK: - 로그인 정보
    private let logInfoLabel = UILabel().then {
        $0.text = "로그인 정보"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
    }
    
    private let loginImageView = UIImageView().then {
        if UserDefaultManager.shared.isKakaoLogin {
            $0.image = UIImage.Setting.KAKAO
        } else {
            $0.image = UIImage.SignUp.appleLogo
        }
    }
    
    private let logInfoMailLabel = UILabel().then {
        $0.text = "\(UserDefaultManager.shared.email)"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray500
    }
    
    private lazy var line2 = makeSeparatorView()
    
    // 연필상점
    private lazy var pencilShopButton = makeButton(title: "연필상점", image: .pencil24)
    
    private lazy var line3 = makeSeparatorView()
    
    private lazy var useButton = makeButton(title: "이용약관", image: .Setting.documentText)
    
    private lazy var qnaButton = makeButton(title: "자주 묻는 질문", image: .Setting.documentText)
    
    private lazy var line4 = makeSeparatorView()
    
    //MARK: - 로그아웃, 계정삭제
    private lazy var logoutButton = makeButton(title: "로그아웃", color: .main)
    
    private lazy var line5 = makeSeparatorView()
    
    private let backgroundView = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var withdrawalButton = makeButton(title: "계정 삭제하기", color: .gray400)
    
    private let onboardingLabel = DSLabel(.h4).then {
        $0.fontColor = .black
        $0.text = "든든한 임장 기록 도우미\n주인장이랑 함께해요"
        $0.numberOfLines = 2
        $0.fontAlignment = .left
    }
    
    private lazy var loginButton = UIButton().then {
        $0.backgroundColor = .main
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("로그인/회원가입", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    struct Dependency {
        let userRepository: UserRepositoryProtocol
    }
    
    private let dependency: Dependency
    weak var updateNicknameDelegate: updateNicknameDelegate?
    private var disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        
        retrieveProfileInfo()
        loadProfileImage()
        logoutButton.contentHorizontalAlignment = .left
        
        bindAction()
        addTarget()
        configureHierarchy()
        setConstraint()
        
        if (!UserDefaultManager.shared.isOnboarding) {
            userRepository
                .retrieveProfileInfo()
                .subscribe(with: self) { (self, model) in
                    self.oneLineIntroTextFieldView.text = model.introduction ?? ""
                }
                .disposed(by: disposeBag)
        }
        
        oneLineIntroTextFieldView
            .saveButtonDidTapRelay
            .subscribe(with: self) { (self, text) in
                self.userRepository.updateProfileIntroduction(text: text)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onCompleted: { [weak self] in
                            self?.oneLineIntroTextFieldView.text = text
                        },
                        onError: { [weak self] error in
                            self?.showAlert(title: "주인장", message: "한줄소개 변경 실패", actionHandler: nil)
                        }
                    )
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func retrieveProfileInfo() {
        guard (!UserDefaultManager.shared.isOnboarding) else { return }
        dependency.userRepository.retrieveProfileInfo()
            .asObservable()
            .subscribe(with: self) { owner, profileModel in
                print(profileModel)
                owner.nicknameValueLabel.text = profileModel.nickname
                owner.logInfoMailLabel.text = profileModel.email
                
                if let profileImage = profileModel.image, let url = URL(string: profileImage) {
                    owner.profileImageView.kf.setImage(with: url)
                }
                
                owner.loginImageView.image = profileModel.provider == "KAKAO"
                ? UIImage.Setting.KAKAO : UIImage.SignUp.appleLogo
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .popButtonTap:
                    owner.backBtnTap()
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        pencilShopButton.rx.throttleTap
            .subscribe(with: self) { owner, action in
                owner.showPencilShopVC()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - 함수
    func addTarget() {
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(SettingViewController.textFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(tapChangeButton), for: .touchUpInside)
        useButton.addTarget(self, action: #selector(showUseSelectVC), for: .touchUpInside)
        qnaButton.addTarget(self, action: #selector(showQnAVC), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTap), for: .touchUpInside)
        withdrawalButton.addTarget(self, action: #selector(showAccountDeleteVC), for: .touchUpInside)
    }
    
    private func showPencilShopVC() {
        let pencilShopVC = PencilShopViewController(
            reactor: PencilShopReactor(
                dependency: PencilShopReactor.Dependency(
                    inAppPurchaseService: InAppPurchaseService(pencilShopRepository: PencilShopRepository()),
                    pencilShopRepository: PencilShopRepository(),
                    userRepository: UserRepository()
                )
            )
        )
        navigationController?.pushViewController(pencilShopVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            saveProfileImage(pickedImage)
            uploadImage(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        JuinjangAPIManager.shared.uploadProfileImage(image: image, type: BaseResponse<EditProfileImageDto>.self, api: .editProfileImage) { response, error in
            if error == nil {
                guard let response else {
                    print("Edit Profile Image Response is Emtpy")
                    return
                }
                print(response.result?.image ?? "")
            } else {
                print("Edit Profile Image Error")
            }
        }
    }
    private func loadProfileImage() {
        if let savedImage = UserDefaultManager.shared.profileImage {
            profileImageView.image = savedImage
        }
    }
    private func saveProfileImage(_ image: UIImage) {
        UserDefaultManager.shared.profileImage = image
    }
    
    func logout() {
        print(#function)
        JuinjangAPIManager.shared.postData(type: BaseResponseStringOptionalResult.self, api: .logout, parameter: [:]) { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlert(title: "로그아웃 에러", message: "로그아웃에 실패하였습니다.\n 다시 시도해주세요.", actionHandler: nil)
                return
            }
            
            guard let self else { return }
            guard let response = response else { return }
            if response.isSuccess {   // 로그아웃 성공
                print("로그아웃 성공")
                UserDefaultManager.shared.removeUserInfo()
                changeLoginVC()
            } else {
                showAlert(title: "로그아웃 에러", message: "로그아웃에 실패하였습니다.\n 다시 시도해주세요.", actionHandler: nil)
            }
        }
    }
    
    @objc private func edit() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func showUseSelectVC(_ sender: Any) {
        let vc = UseSelectViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func showQnAVC(_ sender: Any) {
        let vc = QnAViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func logoutButtonTap() {
        let popupViewController = LogoutPopupViewController(name: UserDefaultManager.shared.nickname, email: logInfoMailLabel.text!, ment: "계정에서 로그아웃할까요?")
        popupViewController.logoutDelegate = self
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    @objc private func showAccountDeleteVC(_ sender: Any) {
        let vc = AccountDeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func tapChangeButton(_ sender: Any) {
        switch saveButton.titleLabel?.text {
        case "변경":
            nicknameTextField.text = nicknameValueLabel.text
            saveButton.setTitle("저장", for: .normal)
            saveButton.backgroundColor = .main
            view.addSubview(nicknameTextField)
            nicknameTextField.delegate = self
            view.addSubview(line1)
            nicknameTextField.snp.makeConstraints{
                $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
                $0.left.equalToSuperview().offset(24)
                $0.width.equalTo(264)
                $0.height.equalTo(23)
            }
            line1.snp.makeConstraints{
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(3)
                $0.left.equalToSuperview().offset(24)
                $0.width.equalTo(264)
                $0.height.equalTo(1)
            }
        case "취소":
            saveButton.setTitle("변경", for: .normal)
            nicknameTextField.removeFromSuperview()
            line1.removeFromSuperview()
        default:    // 저장
            if nicknameTextField.text == UserDefaultManager.shared.nickname {
                self.saveButton.setTitle("변경", for: .normal)
                self.saveButton.backgroundColor = .gray450
                self.nicknameTextField.removeFromSuperview()
            } else {
                let text = nicknameTextField.text ?? ""
                if (text.trimmingCharacters(in: [" "]).isEmpty) {
                    showAlert(title: "닉네임 입력", message: "한 글자 이상 입력해주세요", actionHandler: nil)
                    return
                }
                nicknameTextField.endEditing(true)
            }
        }
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        if nicknameTextField.text!.count < 8 {
            nicknameWarnLabel.removeFromSuperview()
            nicknameWarnImageView.removeFromSuperview()
            nicknameSameWarnLabel.removeFromSuperview()
            nicknameWarnImageView.removeFromSuperview()
            if nicknameTextField.text?.count == 0 {
                saveButton.setTitle("취소", for: .normal)
                saveButton.backgroundColor = .gray450
            }
            else {
                saveButton.setTitle("저장", for: .normal)
                saveButton.backgroundColor = .main
            }
        }
    }
    
    @objc private func backBtnTap() {
        updateNicknameDelegate?.updateNickname()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        present(SignUpViewController(.present), animated: true)
    }
    
    private func sendNickName(nickname: String) {
        let parameters: [String: Any] = [
            "nickname": nickname
        ]
        
        JuinjangAPIManager.shared.postData(type: BaseResponse<NicknameDto>.self, api: .saveNickname, parameter: parameters) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response = response else { return }
                
                switch response.code {
                case "NICKNAME4002":
                    view.addSubview(nicknameWarnImageView)
                    view.addSubview(nicknameSameWarnLabel)
                    nicknameWarnImageView.snp.makeConstraints {
                        $0.top.equalTo(self.line1.snp.bottom).offset(9)
                        $0.left.equalToSuperview().offset(24)
                        $0.height.equalTo(16)
                    }
                    nicknameSameWarnLabel.snp.makeConstraints{
                        $0.top.equalTo(self.line1.snp.bottom).offset(9)
                        $0.left.equalTo(self.nicknameWarnImageView.snp.right).offset(3)
                    }
                case "COMMON200":
                    saveButton.setTitle("변경", for: .normal)
                    saveButton.backgroundColor = .gray450
                    nicknameTextField.removeFromSuperview()
                    line1.removeFromSuperview()
                    nicknameWarnLabel.removeFromSuperview()
                    nicknameWarnImageView.removeFromSuperview()
                    nicknameValueLabel.text = nicknameTextField.text
                    UserDefaultManager.shared.nickname = nickname
                    nicknameSameWarnLabel.removeFromSuperview()
                    nicknameWarnImageView.removeFromSuperview()
                default:
                    nicknameSameWarnLabel.removeFromSuperview()
                    nicknameWarnImageView.removeFromSuperview()
                }
                
            } else {
                guard let error else { return }
                print("failedRequest", error)
            }
        }
    }
    
    private func configureHierarchy() {
        // 온보딩 분기처리
        if UserDefaultManager.shared.isOnboarding {
            view.add(navigationView, onboardingLabel, loginButton)
            return
        }
        view.add(navigationView, scrollView)
        scrollView.addSubview(contentView)
        
        contentView.add(
            profileImageView,
            editButton,
            nicknameLabel,
            nicknameValueLabel,
            saveButton,
            line1,
            oneLineIntroTextFieldView,
            logInfoLabel,
            loginImageView,
            logInfoMailLabel,
            line2,
            pencilShopButton,
            line3,
            useButton,
            qnaButton,
            line4,
            logoutButton,
            line5,
            withdrawalButton
        )
    }
    
    private func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 온보딩 분기처리
        if UserDefaultManager.shared.isOnboarding {
            onboardingLabel.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(32)
                $0.left.equalToSuperview().offset(24)
            }
            
            loginButton.snp.makeConstraints {
                $0.top.equalTo(onboardingLabel.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(52)
            }
            
            return
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(withdrawalButton.snp.bottom).offset(20)
        }
        
        profileImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(66)
        }
        editButton.snp.makeConstraints{
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(editButton.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
        }
        nicknameValueLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
        }
        saveButton.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(29)
            $0.width.equalTo(64)
        }
        
        oneLineIntroTextFieldView.snp.makeConstraints {
            $0.top.equalTo(saveButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(21)
            $0.height.equalTo(68)
        }
        
        logInfoLabel.snp.makeConstraints {
            $0.top.equalTo(oneLineIntroTextFieldView.snp.bottom).offset(29)
            $0.leading.equalToSuperview().offset(24)
        }
        loginImageView.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        logInfoMailLabel.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(10)
            $0.leading.equalTo(loginImageView.snp.trailing).offset(8)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(logInfoMailLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        pencilShopButton.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        line3.snp.makeConstraints { make in
            make.top.equalTo(pencilShopButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(4)
        }
        
        useButton.snp.makeConstraints {
            $0.top.equalTo(line3.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        qnaButton.snp.makeConstraints {
            $0.top.equalTo(useButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        line4.snp.makeConstraints {
            $0.top.equalTo(qnaButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(line4.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        line5.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.top.equalTo(line5.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }
    
    private func makeButton(title: String, color: UIColor = .gray500, image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.pretendard(size: 16, weight: .semiBold),
                .foregroundColor: color
            ]))
        if let image {
            config.image = image
            config.imagePadding = 8
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 24, bottom: 18, trailing: 24)
        config.background.backgroundColor = .clear
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        return button
    }
}

//MARK: - Extension
extension SettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard nicknameTextField.text!.count < 8
        else {
            view.addSubview(nicknameWarnImageView)
            view.addSubview(nicknameWarnLabel)
            nicknameWarnImageView.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalToSuperview().offset(24)
                $0.height.equalTo(16)
            }
            nicknameWarnLabel.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalTo(nicknameWarnImageView.snp.right).offset(3)
            }
            return false
        }
        
        nicknameWarnLabel.removeFromSuperview()
        nicknameWarnImageView.removeFromSuperview()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        if (text.trimmingCharacters(in: [" "]).isEmpty) {
            showAlert(title: "닉네임 입력", message: "한 글자 이상 입력해주세요", actionHandler: nil)
            return
        }
        
        sendNickName(nickname: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTextField.endEditing(true)
        return true
    }
}
