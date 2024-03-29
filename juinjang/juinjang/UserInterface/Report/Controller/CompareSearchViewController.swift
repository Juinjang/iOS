
import UIKit
import Pageboy

class CompareSearchViewController: UIViewController {
    var searchBar = UISearchBar().then{
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.82, height: 0)
        $0.placeholder = "집 별명이나 주소를 검색해보세요"
        $0.searchTextField.font = .pretendard(size: 14, weight: .medium)
        $0.searchTextField.borderStyle = .roundedRect
        $0.searchTextField.clipsToBounds = true
        $0.searchTextField.layer.cornerRadius = 15
    }
    
    let searchedTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        tableView.register(ReportImjangListTableViewCell.self, forCellReuseIdentifier: ReportImjangListTableViewCell.identifier)
        return tableView
    }()
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "투명로고")
    }
    
    let mentLabel = UILabel().then {
        $0.text = "일치하는 매물이 없습니다."
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "450")
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = UIColor(named: "null")
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.isHidden = true
    }
    
    var searchKeyword  = ""
    var searchedImjangList: [ImjangNote] = []
    var totalImjangList = ImjangList.list
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
        backButtonItem.tintColor = UIColor(named: "300")
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.titleView = searchBar
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func applyBtnTap() {
        let vc = ReportViewController()
        vc.tabViewController.index = 1
        vc.tabViewController.compareVC.isCompared = true
        vc.tabViewController.compareVC.compareDataSet2.fillAlpha = CGFloat(0.8)
        vc.tabViewController.compareVC.compareDataSet2.fillColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        searchedImjangList.removeAll()
        searchedTableView.reloadData()
        if searchBar.searchTextField.text == "" {
            searchedTableView.isHidden = true
            applyBtn.isHidden = true
        } else {
            searchedTableView.isHidden = true
            applyBtn.isHidden = true
            searchKeyword = searchBar.text!
            for item in totalImjangList {
                if item.roomName.contains(searchKeyword) || item.location.contains(searchKeyword) {
                    searchedImjangList.append(item)
                    searchedTableView.isHidden = false
                    applyBtn.isHidden = false
                }
            }
            searchedTableView.reloadData()
        }
    }
    
    func setupConstraints() {
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        logoImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(243)
            $0.centerX.equalToSuperview()
        }
        mentLabel.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(37.17)
            $0.centerX.equalToSuperview()
        }
        applyBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designNavigationBar()
        
        view.backgroundColor = .white
        searchBar.delegate = self
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
        
        view.addSubview(logoImageView)
        view.addSubview(mentLabel)
        view.addSubview(searchedTableView)
        view.addSubview(applyBtn)
        applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        searchBar.searchTextField.addTarget(self, action: #selector(CompareSearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        setupConstraints()
    }
}

extension CompareSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedImjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportImjangListTableViewCell.identifier, for: indexPath) as! ReportImjangListTableViewCell
        
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: searchedImjangList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        if cell.isSelect == false {
            cell.isSelect = true
            cell.contentView.backgroundColor = UIColor(named: "main100")
            cell.contentView.layer.borderColor = UIColor(named: "juinjang")?.cgColor
            applyBtn.backgroundColor = UIColor(named: "500")
            applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
        else {
            cell.isSelect = false
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
            applyBtn.backgroundColor = UIColor(named: "null")
            applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        cell.isSelect = false
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
        applyBtn.backgroundColor = UIColor(named: "null")
        applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension CompareSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}


