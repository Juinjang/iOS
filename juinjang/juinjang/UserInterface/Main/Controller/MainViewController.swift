import UIKit
import SnapKit
import Then
import Lottie
import Alamofire
import FirebaseAnalytics
import SkeletonView

protocol updateNicknameDelegate: AnyObject {
    func updateNickname()
}

final class MainViewController: BaseViewController, DeleteImjangListDelegate {
    
    
// MARK: - 변수, 상수 설정
    //설정 버튼, 메인 로고, 스피커 버튼
    private var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named:"mainLogo")
    }
    
    //테이블 뷰
    private let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.id)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.id)
    }
    
    private var mainImjangList: [LimjangDto] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면 전환 이벤트 로깅
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: "MainScreen", // 추적할 화면 이름
            AnalyticsParameterScreenClass: "MainViewController" // 클래스 이름
        ])
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
    
        super.viewDidLoad()
        checkAndShowTermsPopup()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 710
        tableView.backgroundColor = .clear
        view.backgroundColor = .mainWhite
        
        view.addSubview(tableView)
       
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginVC), name: .refreshTokenExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callMainImjangRequest), name: .refreshMainImjang, object: nil)
        designNavigationBar()
        setConstraint()
        callMainImjangRequest()
        checkAndUpdateIfNeeded()
        print("메인화면에서 이메일 출력 : \(UserDefaultManager.shared.email)")
    }
    
    private func checkAndShowTermsPopup() {
        print("약관 동의 버전은????\(UserDefaultManager.shared.agreeVersion)")
        let currentVersion = "1.1.0"
        if UserDefaultManager.shared.agreeVersion.compare(currentVersion, options: .numeric) == .orderedAscending {
            let termsPopupVC = TermsPopupViewController()
            termsPopupVC.modalPresentationStyle = .overFullScreen
            termsPopupVC.modalTransitionStyle = .crossDissolve
            present(termsPopupVC, animated: false, completion: nil)
        }
    }
    
    @objc private func callMainImjangRequest() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<RecentUpdatedDto>.self, api: .mainImjang) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                print(response)
                self.mainImjangList = result.recentUpdatedList
                self.tableView.reloadData()
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    private func callVersionRequest(imjangId: Int, completion: @escaping (Int?) -> Void) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if error == nil {
                guard let result = detailDto else {
                    completion(nil)
                    return
                }
                if let detailDto = result.result {
                    let checkListVersion = detailDto.checkListVersion
                    if checkListVersion == "LIMJANG" {
                        completion(0)
                    } else if checkListVersion == "NON_LIMJANG" {
                        completion(1)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                guard let error else {
                    completion(nil)
                    return
                }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
                completion(nil)
            }
        }
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = mainLogoImageView
        
        // 이미지 로드
//        let speaker = UIImage(named:"speaker")
//
//        // UIBarButtonItem 생성 및 이미지 설정
//        let speakerButtonItem = UIBarButtonItem(image: speaker, style: .plain, target: self, action: nil)
//        speakerButtonItem.tintColor = ColorStyle.darkGray
//        speakerButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        
        let settingButtonItem = UIBarButtonItem(image: UIImage(named:"setting"), style: .plain, target: self, action: #selector(setttingBtnTap))
        settingButtonItem.tintColor = .gray450
        settingButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = settingButtonItem
//        self.navigationItem.rightBarButtonItem = speakerButtonItem
    }
    
    private func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId = imjangId, let version = version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .main
        navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
    @objc private func newImjangBtnTap() {
        let vc = OpenNewPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func myImjangBtnTap() {
        let vc = ImjangListViewController()
        vc.deleteImjangListDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func setttingBtnTap() {
        let vc = SettingViewController()
        vc.updateNicknameDelegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setConstraint() {
        //테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Update Nickname
extension MainViewController: updateNicknameDelegate {
    func updateNickname() {
        if let topCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopTableViewCell {
            topCell.configureNickname()
        }
    }
}

//MARK: - extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as? TopTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            cell.newImjangButton.addTarget(self, action: #selector(newImjangBtnTap), for: .touchUpInside)
            cell.myNoteButton.addTarget(self, action: #selector(myImjangBtnTap), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as? BottomTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.isSkeletonable = true
            
            cell.isHidden(mainImjangList.isEmpty)
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        } else {
            return BottomTableViewCell.cellHeight
        }
    }
}
     
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainImjangList.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = mainImjangList[indexPath.row]
        cell.configureCell(listDto: item)
        
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = mainImjangList[indexPath.row]
        callVersionRequest(imjangId: item.limjangId) { version in
            if let version = version {
                self.showImjangNoteVC(imjangId: item.limjangId, version: version)
            } else {
                self.showImjangNoteVC(imjangId: item.limjangId, version: version)
            }
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
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        BottomCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}


// MARK: 앱 업데이트 안내 팝업
extension MainViewController {
    
    // 앱 스토어 최신 정보 확인
    private func requestLatestVersion(completion: @escaping (String?) -> Void){
        guard let url = URL(string: APIKey.appStoreVersionURL), let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                completion(nil)
                return
            }
            completion(appStoreVersion)
        }.resume()
    }
   
    //버전 업데이트 체크
    private func checkAndUpdateIfNeeded() {
        requestLatestVersion { [weak self] marketingVersion in
            guard let self else { return }
            
            guard let marketingVersion = marketingVersion, let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                print("앱스토어 버전을 찾지 못했습니다.")
                return
            }
            
            print("앱스토어 버전은 \(marketingVersion)")
            print("현재 기기 버전은 \(currentAppVersion)")
            
            if compareVersion(currentVersion: currentAppVersion, marketVersion: marketingVersion) {
                DispatchQueue.main.async {
                    self.showUpdateAlert()
                }
            } else {
                print("현재 최신 버전입니다.")
            }
        }
    }
    
    // 업데이트 해야되면 true 반환
    private func compareVersion(currentVersion: String, marketVersion: String) -> Bool {
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let marketVersionArray = marketVersion.split(separator: ".").map { $0 }
        
        // 1.1.2 < 2.0.0
        if currentVersionArray[0] < marketVersionArray[0] {
            return true
        } else if currentVersionArray[0] == marketVersionArray[0] && currentVersionArray[1] < marketVersionArray[1] { // 1.2.0 < 1.3.0
            return true
        } else if currentVersionArray[0] == marketVersionArray[0] && currentVersionArray[1] == marketVersionArray[1] && currentVersionArray[2] < marketVersionArray[2] {    // 1.2.2 < 1.2.3
            return true
        } else {
            return false
        }
    }
    
    private func showUpdateAlert() {
            
        // 커스텀 뷰 인스턴스 생성
        let updateAlertView = UpdateAlertView(frame: CGRect(x: 0, y: 0, width: 342, height: 325))
        updateAlertView.center = view.center
        
        // 커스텀 뷰 배경에 어두운 배경 추가 (배경 어두운 색을 두고 뷰만 강조)
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        view.addSubview(dimmingView)
        view.addSubview(updateAlertView)
        
        // 업데이트 버튼 클릭 시 동작 정의
        updateAlertView.updateButtonTappedAction = { [weak self] in
            guard let self else { return }
            openAppStore()
        }
        
        // 닫기 버튼 클릭 시 동작 정의
        updateAlertView.closeButtonTappedAction = {
            dimmingView.removeFromSuperview()
            updateAlertView.removeFromSuperview()
        }
    }

    // 앱 스토어로 이동
    private func openAppStore() {
        guard let url = URL(string: APIKey.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
