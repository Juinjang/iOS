import UIKit
import RxRelay
import SnapKit
import Then
import Lottie
import Alamofire
import SkeletonView
import RxSwift
import DomainUsecaseInterfaces

protocol updateNicknameDelegate: AnyObject {
    func updateNickname()
}

final class MainViewController: BaseViewController, DeleteImjangListDelegate {
    private let termsUsecase: TermsUsecaseProtocol
    private let userUsecase: UserUsecaseProtocol
    private let userSettingUsecase: UserSettingsUsecaseProtocol
    private let noteUsecase: NoteUsecaseProtocol
    
    private lazy var navigationView = CenterFlexibleNavigationView(centerView: mainLogoImageView).then {
        $0.leftItem = [.setting]
    }
    
    private var mainLogoImageView = UIImageView().then {
        $0.image = UIImage.Main.logo
    }
    
    //테이블 뷰
    private let tableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.id)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.id)
    }
    
    private var mainImjangList: [MainNoteViewModel] = []
    private var disposeBag = DisposeBag()
    private var isFirstShowing: Bool = true
    
    private let pencilAgreeEventRelay = PublishRelay<Void>()
    
    private var termsPopupViewController: TermsPopupViewController?
    
    init(termsUsecase: TermsUsecaseProtocol,
         userUsecase: UserUsecaseProtocol,
         userSettingUsecase: UserSettingsUsecaseProtocol,
         noteUsecase: NoteUsecaseProtocol) {
        self.termsUsecase = termsUsecase
        self.userUsecase = userUsecase
        self.userSettingUsecase = userSettingUsecase
        self.noteUsecase = noteUsecase
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        checkAndShowTermsPopup()
        checkAndShowPencilShopTermsPopup()
        getProfileInfo()
        bind()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 710
        tableView.backgroundColor = .clear
        view.backgroundColor = .mainWhite
        
        view.add(
            navigationView,
            tableView
        )
       
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginVC), name: .refreshTokenExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callMainImjangRequest), name: .refreshMainImjang, object: nil)
        setConstraint()
        
        callMainImjangRequest()
    }
    
    private func bind() {
        navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .settingButtonTap: owner.setttingBtnTap()
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        pencilAgreeEventRelay
            .subscribe(with: self) { (self, _) in
                self.termsPopupViewController?.didAgreeToTerms()
            }
            .disposed(by: disposeBag)
    }
    
    private func getProfileInfo() {
        userUsecase.retrieveProfileInfo()
            .asObservable()
            .subscribe(with: self) { owner, profileModel in
                userSettingUsecase.updateNickname(profileModel.nickname)
                owner.updateNickname()
            }
            .disposed(by: disposeBag)
    }
    
    private func checkAndShowPencilShopTermsPopup() {
        termsUsecase.fetchPencilShopAgreementStatus()
            .asObservable()
            .subscribe(with: self) { (self, response) in
                let response = PencilShopAgreementViewModel(response)
                
                if !response.status {
                    self.termsPopupViewController = TermsPopupViewController(
                        title: "업데이트된 주인장 앱 이용을 위해\n내용을 확인하고 동의해주세요",
                        titleMain: "내용을 확인하고 동의해주세요",
                        term: "(필수) 연필상점 서비스 이용 및 환불 정책",
                        navigationType: .view(PencilShopTermsViewController(
                            termFileType: .pencilShop,
                            relay: self.pencilAgreeEventRelay,
                            title: "연필상점 서비스 이용 및 환불 정책"
                        ))
                    )
                    
                    self.termsPopupViewController?.button2
                        .rx.throttleTap
                        .subscribe(with: self) { (self, _) in
                            self.termsUsecase
                                .addTermsAgreement(TermsAgreement.init(termsType: "PENCIL_SHOP_SERVICE", isAgreed: true))
                                .asObservable()
                                .subscribe(onNext: { response in
                                        print("동의 완료: \(response)")
                                    }, onError: { error in
                                        self.showAlert(title: "주인장", message: error.localizedDescription, actionHandler: nil)
                                    })
                                .disposed(by: self.disposeBag)
                        }
                        .disposed(by: self.disposeBag)
                    
                    if let viewController = self.termsPopupViewController {
                        self.present(viewController, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkAndShowTermsPopup() {
        userSettingUsecase.loadAgreeVersion()
            .asObservable()
            .subscribe(with: self) { (self, version) in
                // 서버로 이동할 예정
                let currentVersion = "1.1.0"

                if version.compare(currentVersion, options: .numeric) == .orderedAscending {
                    termsPopupViewController = TermsPopupViewController(
                        title: "주인장 앱을 이용하려면\n업데이트 내용을 확인하고 동의해주세요",
                        titleMain: "업데이트 내용을 확인하고 동의해주세요",
                        term: "(필수) 개인정보 수집 및 이용 동의",
                        navigationType: .view(NewTermsViewController())
                    )
                    
                    if let viewController = termsPopupViewController {
                        present(viewController, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    @objc private func callMainImjangRequest() {
        noteUsecase.fetchMainNotes()
            .asObservable()
            .subscribe(with: self) { (self, response) in
                self.isFirstShowing = false
                self.mainImjangList = response.map { MainNoteViewModel($0) }
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func callVersionRequest(imjangId: Int,
                                    completion: @escaping (Int?) -> Void) {
        noteUsecase.fetchMainNoteCheckListVersion(noteID: imjangId)
            .asObservable()
            .subscribe(with: self) { (self, response) in
                completion(response)
            }
            .disposed(by: disposeBag)
    }
    
    private func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId = imjangId,
              let version = version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .main
        navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
    
    @objc private func newPageButtonTapped() {
        let vc = OpenNewPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func myNoteButtonTapped() {
        let vc = ImjangListViewController(dependency: ImjangListViewController.Dependency(noteRepository: NoteRepository()))
        vc.deleteImjangListDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func lookAroundButtonTapped() {
        let lookAroundVC = LookAroundViewController(reactor: LookAroundReactor(dependency: .init(sharedNoteRepository: SharedNoteRepository())))
        lookAroundVC.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(lookAroundVC, animated: true)
    }
    
    @objc private func setttingBtnTap() {
        let settingVC = SettingViewController(
            dependency: SettingViewController.Dependency(
                userRepository: UserRepository()
            )
        )
        settingVC.updateNicknameDelegate = self
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Update Nickname
extension MainViewController: updateNicknameDelegate {
    func updateNickname() {
        if let topCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopTableViewCell {
            userSettingUsecase.loadNickname()
                .asObservable()
                .subscribe(with: self) { (self, response) in
                    topCell.configureNickname(nickname: response)
                }
                .disposed(by: disposeBag)
        }
    }
}

//MARK: - extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier,
                                                           for: indexPath) as? TopTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            cell.newPageButton.addTarget(self, action: #selector(newPageButtonTapped), for: .touchUpInside)
            cell.myNoteButton.addTarget(self, action: #selector(myNoteButtonTapped), for: .touchUpInside)
            cell.lookAroundButton.addTarget(self, action: #selector(lookAroundButtonTapped), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier,
                                                           for: indexPath) as? BottomTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.isSkeletonable = true
            cell.isHidden(mainImjangList.isEmpty, isFirstShowing: isFirstShowing)
            cell.collectionView.reloadData()
    
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        } else {
            return BottomTableViewCell.cellHeight
        }
    }
}
     
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return mainImjangList.count
    }
     
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier,
                                                            for: indexPath) as? BottomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = mainImjangList[indexPath.row]
        cell.configureCell(listDto: item)
        
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let item = mainImjangList[indexPath.row]
        callVersionRequest(imjangId: item.limjangId) { [weak self] version in
            guard let self = self,
                  let version = version else { return }
            showImjangNoteVC(imjangId: item.limjangId, version: version)
        }
    }
    
    func deleteImjangList(_ deleteIdList: [Int]) {
        mainImjangList.removeAll { imjang in
            deleteIdList.contains(imjang.limjangId)
        }
        tableView.reloadData()
    }
}

extension MainViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        BottomCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
