//
//  ViewController.swift
//  Juinjang
//
//  Created by 박도연 on 12/29/23.
//

import UIKit
import SnapKit
import Then


class MainViewController: UIViewController {
// MARK: - 변수, 상수 설정
    //설정 버튼, 메인 로고, 스피커 버튼
    var settingButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"setting"), for: .normal)
        $0.addTarget(self, action: #selector(setBtnTap), for: .touchUpInside)
    }
    @objc
    func setBtnTap() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named:"mainLogo")
    }
    var speakerButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"speaker"), for: .normal)
    }
    
    //배경
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"backgroundshape")
        $0.alpha = 0.0
    }
    
    //테이블 뷰
    let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.identifier)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.identifier)
    }
    
    @objc
    func newImjangBtnTap() {
        let vc = OpenNewPageViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc
    func myImjangBtnTap() {
        let vc = ReportViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
//MARK: - 함수 선언
    func setConstraint() {
        //설정 버튼, 메인 로고, 스피커 버튼
        settingButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.16)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(26.73)
        }
        mainLogoImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.height.equalTo(21)
            $0.centerX.equalToSuperview()
        }
        speakerButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.16)
            $0.height.width.equalTo(24)
            $0.right.equalToSuperview().inset(26.55)
        }
        
        //배경
        backgroundImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(37.82)
            $0.left.right.equalToSuperview()
        }
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundImageView.alpha = 1.0
        }, completion: nil)
    
        //테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(46.16)
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
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(settingButton)
        view.addSubview(speakerButton)
        view.addSubview(mainLogoImageView)
        view.addSubview(tableView)
        setConstraint()
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
