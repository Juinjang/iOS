
import UIKit
import Pageboy
import Toast

protocol SendSearchCompareImjangData{
    func sendData(isSelected: Bool, compareImjangId: Int,  compareImjangName: String)
}

final class CompareSearchViewController: BaseViewController {
    
    var delegate: SendSearchCompareImjangData?
    
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
        $0.image = UIImage.Main.nomaemull
    }
    
    let mentLabel = UILabel().then {
        $0.text = "일치하는 매물이 없습니다."
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray400
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.isHidden = true
    }
    
    var searchKeyword  = ""
    var searchedImjangList: [ListDto] = []
    var imjangList: [ListDto] = []
    var imjangId: Int
    var comparedImjangId : Int = 0
    var comparedName : String = ""
    var scoreStates: [UIButton: Bool] = [:]
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage.arrowLeft, style: .plain, target: self, action: #selector(popView))
        backButtonItem.tintColor = .gray450
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.titleView = searchBar
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func applyBtnTap(_ sender: UIButton) {
        let moveTo = scoreStates[sender] ?? false
        if moveTo {
            delegate?.sendData(isSelected: true, compareImjangId: comparedImjangId, compareImjangName: comparedName)
            
            if let navigationController = self.navigationController {
                // comparesearchviewcontroller에서 실행
                if let ReportViewController = navigationController.viewControllers.first(where: { $0 is ReportViewController }) {
                    navigationController.popToViewController(ReportViewController, animated: true)
                }
            }
        } else {
            self.view.makeToast("미평가된 매물은 비교하기 어려워요 :(", duration: 1.0)
        }
    }
    
    @objc private func textFieldDidChange(_ sender: Any?) {
        searchedImjangList.removeAll()
        searchedTableView.reloadData()
        if searchBar.searchTextField.text == "" {
            searchedTableView.isHidden = true
            applyBtn.isHidden = true
        } else {
            searchedTableView.isHidden = true
            applyBtn.isHidden = true
            searchKeyword = searchBar.text!
            for item in imjangList {
                if item.nickname.contains(searchKeyword) || item.address.contains(searchKeyword) {
                    searchedImjangList.append(item)
                    searchedTableView.isHidden = false
                    applyBtn.isHidden = false
                }
            }
            searchedTableView.reloadData()
        }
    }
    
    private func callRequest(sort: Filter = .update, setScrap: Bool = false, excludingId: Int? = nil) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: sort.sortValue)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let result = response.result else { return }
            
            let filteredList = result.limjangList.filter { item in
                if let excludingId = excludingId {
                    return item.limjangId != excludingId
                }
                return true
            }
            
            self.imjangList = filteredList
            self.setEmptyUI(isEmpty: self.imjangList.isEmpty)
            self.searchedTableView.reloadData()
        }
    }
    private func setEmptyUI(isEmpty: Bool) {
        //emptyBackgroundView.isHidden = isEmpty ? false : true
        searchedTableView.isHidden = isEmpty ? true : false
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func setupConstraints() {
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
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest(setScrap: true, excludingId: imjangId)
        designNavigationBar()
        
        view.backgroundColor = .mainWhite
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
        hideKeyboardWhenTappedAround()
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
        print(searchedImjangList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let compareImjangId = searchedImjangList[indexPath.row].limjangId
        comparedImjangId = compareImjangId
        
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        comparedName = cell.roomNameLabel.text ?? "error"
        
        if cell.isSelect == false {
            cell.isSelect = true
            cell.contentView.backgroundColor = .main100
            cell.contentView.layer.borderColor = UIColor.main.cgColor
            print("id : \(compareImjangId)")
            applyBtn.backgroundColor = .gray500
            if let score = cell.scoreLabel.text {
                let moveTo = (score != "0.0")
                scoreStates[applyBtn] = moveTo
            }
            applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
        else {
            cell.isSelect = false
            cell.contentView.backgroundColor = .mainWhite
            cell.contentView.layer.borderColor = UIColor.stroke.cgColor
            applyBtn.backgroundColor = .null
            applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        cell.isSelect = false
        cell.contentView.backgroundColor = .mainWhite
        cell.contentView.layer.borderColor = UIColor.stroke.cgColor
        applyBtn.backgroundColor = .null
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


