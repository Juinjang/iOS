//
//  ImjangSearchResultViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import SkeletonView

final class ImjangSearchResultViewController: BaseViewController {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.82, height: 0))
        searchBar.placeholder = "집 별명이나 주소를 검색해보세요"
        searchBar.searchTextField.font = .pretendard(size: 14, weight: .medium)
        searchBar.searchTextField.borderStyle = .roundedRect
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 15
        return searchBar
    }()
    
    let searchedTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainWhite
        tableView.register(ImjangNoteTableViewCell.self, forCellReuseIdentifier: ImjangNoteTableViewCell.identifier)
        tableView.isSkeletonable = true
        return tableView
    }()
    
    let emptyImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = UIImage.Main.nomaemull
        return emptyImage
    }()
    
    let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "일치하는 매물이 없어요"
        emptyLabel.font = .pretendard(size: 16, weight: .medium)
        emptyLabel.textColor = .gray400
        return emptyLabel
    }()
    
    var searchKeyword  = ""
    var searchedImjangList: [ListDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        configureHierarchy()
        setupConstraints()
        designView()
        addSubView()
        setConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchRequest), name: .refreshSearchList, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchRequest()
    }
    
    private func showSkeletonView() {
        setEmptyView(false)
        searchedTableView.showAnimatedSkeleton(usingColor: .gray100, transition: .crossDissolve(0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.searchedTableView.stopSkeletonAnimation()
            self.searchedTableView.hideSkeleton()
            self.setEmptyView(self.searchedImjangList.isEmpty)
        }
    }
    
    private func setEmptyView(_ isEmpty: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.emptyImage.alpha = isEmpty ? 1 : 0
            self.emptyLabel.alpha = isEmpty ? 1 : 0
        }
    }
    
    @objc private func searchRequest() {
        showSkeletonView()
        if searchKeyword.count > 0 {
            JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .searchImjang(keyword: searchKeyword)) { [weak self] response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let response, let result = response.result else { return }
                guard let self else { return }
                searchedImjangList = result.limjangList
                searchedTableView.reloadData()
            }
        }
    }
    
    // MARK: - addSubView()
    private func addSubView() {
        [emptyImage, emptyLabel].forEach {
            view.addSubview($0)
        }
    }
    
    // 결과가 없을 때 배경
    private func setConstraints() {
        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.height.equalTo(108.83)
            $0.width.equalTo(105.56)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImage.snp.bottom).offset(34.17)
            $0.height.equalTo(22)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage.arrowLeft, style: .plain, target: self, action: #selector(popView))
        let searchTextFieldItem = UIBarButtonItem(customView: searchBar)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchTextFieldItem
    }
    
    private func configureHierarchy() {
        view.addSubview(searchedTableView)
    }

    private func designView() {
        view.backgroundColor = .mainWhite
        searchBar.text = searchKeyword
        searchBar.delegate = self
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
        
        emptyImage.alpha = 0
        emptyLabel.alpha = 0
    }

    private func setupConstraints() {
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func saveSearchKeyword(keyword: String) {
        var keywordArray = UserDefaultManager.shared.searchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            if keywordArray.count < 3 {
                keywordArray.insert(keyword, at: 0)
            }
        }
        
        UserDefaultManager.shared.searchKeywords = keywordArray
    }
    
    private func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId, let version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .searchedImjangList
        self.navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
}

extension ImjangSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedImjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImjangNoteTableViewCell.identifier, for: indexPath) as! ImjangNoteTableViewCell
        
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: searchedImjangList[indexPath.row])
        cell.bookMarkButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imjangId = searchedImjangList[indexPath.row].limjangId
        callVersionRequest(imjangId: imjangId) { version in
            if let version = version {
                self.showImjangNoteVC(imjangId: imjangId, version: version)
            } else {
                self.showImjangNoteVC(imjangId: imjangId, version: version)
            }
        }
    }
    
    private func callVersionRequest(imjangId: Int, completion: @escaping (Int?) -> Void) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
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
        }
    }
}

extension ImjangSearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text.count < 2 {
            showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
            return
        }
        saveSearchKeyword(keyword: text)
        searchKeyword = text
        searchRequest()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedImjangList = []
        searchedTableView.reloadData()
    }
}


extension ImjangSearchResultViewController: SkeletonTableViewDataSource {
    // skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ImjangSkeletonTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return ImjangSkeletonTableViewCell()
    }
}
