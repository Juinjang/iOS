import UIKit
import SnapKit
import Then
import Lottie
import Alamofire
struct RefreshTokenResponse: Decodable {
    let code: String
    // 다른 필요한 속성들도 추가할 수 있습니다.
}

class MainViewController: UIViewController {
    
// MARK: - 변수, 상수 설정
    //설정 버튼, 메인 로고, 스피커 버튼
    var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named:"mainLogo")
    }
    
    //배경
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"backgroundshape")
        $0.alpha = 0.0
    }
    
    //테이블 뷰
    let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.id)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.id)
    }
    
    var mainImjangList: [LimjangDto] = []
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshToken()
        UserDefaultManager.shared.userStatus = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 710
        tableView.backgroundColor = .clear
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
       
        designNavigationBar()
        setConstraint()
        callMainImjangRequest()
    }
    
    func callMainImjangRequest() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<RecentUpdatedDto>.self, api: .mainImjang) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
//                print(response)
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
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = mainLogoImageView
        
        // 이미지 로드
        let speaker = UIImage(named:"speaker")

        // UIBarButtonItem 생성 및 이미지 설정
        let speakerButtonItem = UIBarButtonItem(image: speaker, style: .plain, target: self, action: nil)
        speakerButtonItem.tintColor = UIColor(named: "300")
        speakerButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        
        let settingButtonItem = UIBarButtonItem(image: UIImage(named:"setting"), style: .plain, target: self, action: #selector(setttingBtnTap))
        settingButtonItem.tintColor = UIColor(named: "300")
        settingButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = settingButtonItem
        self.navigationItem.rightBarButtonItem = speakerButtonItem
        
    }
    
    func showImjangNoteVC(imjangId: Int?) {
        guard let imjangId = imjangId else { return }
        let imjangNoteVC = ImjangNoteViewController()
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .main
        imjangNoteVC.completionHandler = {
            self.callMainImjangRequest()
        }
        navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
    @objc func newImjangBtnTap() {
        //let vc = OpenNewPageViewController()
        let vc = ImjangNoteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func myImjangBtnTap() {
        let vc = ImjangListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func setttingBtnTap() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//MARK: - 함수 선언
    func refreshToken() {
        let url = "http://juinjang1227.com:8080/api/auth/regenerate-token"
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)", // 현재 Access Token
            "Refresh-Token": "Bearer \(UserDefaultManager.shared.refreshToken)" // Refresh Token
        ]
        
        AF.request(url, method: .post, headers: headers).responseData { response in
            switch response.result {
            case .success(let value):
                if let httpResponse = response.response {
                    print("Status code: \(httpResponse.statusCode)")
                }
                // 응답 데이터 출력
                if let responseString = String(data: value, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                do {
                    let decoder = JSONDecoder()
                    let refreshTokenResponse = try decoder.decode(RefreshTokenResponse.self, from: value)
                    if refreshTokenResponse.code == "TOKEN402" {
                        // "code"가 "TOKEN402"인 경우 로그아웃 함수 호출
                        let settingViewController = SettingViewController()
                        settingViewController.logout()
                    }
                } catch {
//                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func setConstraint() {
        //배경
        backgroundImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(37.82)
            $0.height.equalTo(483.27)
            $0.left.equalToSuperview().offset(-201.08)
        }
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundImageView.alpha = 1.0
        }, completion: nil)
    
        //테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
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
            print("임장 개수: \(mainImjangList.count)")
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
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
        
        print("으아아앙")
        let item = mainImjangList[indexPath.row]
        cell.configureCell(listDto: item)
        
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = mainImjangList[indexPath.row]
        showImjangNoteVC(imjangId: item.limjangId)
    }
}

