import UIKit
import SnapKit
import Then
import Lottie


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
    
    @objc func newImjangBtnTap() {
        let vc = OpenNewPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func myImjangBtnTap() {
        let vc = ImjangListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setttingBtnTap() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//MARK: - 함수 선언
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

//MARK: - extension
extension MainViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as? TopTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.newImjangButton.addTarget(self, action: #selector(newImjangBtnTap), for: .touchUpInside)
            cell.myNoteButton.addTarget(self, action: #selector(myImjangBtnTap), for: .touchUpInside)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomTableViewCell", for: indexPath) as? BottomTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard let tableViewCell = cell as? BottomTableViewCell else {
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}
     
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return 5
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell", for: indexPath) as?
                BottomCollectionViewCell else{
            return UICollectionViewCell()
     }
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
}

