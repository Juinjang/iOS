//
//  ImjangSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/24/24.
//

import UIKit
import Then
import SnapKit

final class ImjangSearchViewController: BaseViewController {
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.82, height: 0))
        searchBar.placeholder = "집 별명이나 주소를 검색해보세요"
        searchBar.searchTextField.font = .pretendard(size: 14, weight: .medium)
        searchBar.searchTextField.borderStyle = .roundedRect
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 15
//        searchBar.setImage(ImageStyle.search, for: .clear, state: .normal)
        return searchBar
    }()
    
    let imjangSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = ColorStyle.textWhite
        tableView.sectionHeaderTopPadding = 12
        tableView.register(SearchKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchKeywordHeaderView.identifier)
        tableView.register(RecentSearchKeywordTableViewCell.self, forCellReuseIdentifier: RecentSearchKeywordTableViewCell.identifier)
        return tableView
    }()
    
    var searchedKeywordList: [String] = [] {
        didSet {
            if searchedKeywordList.isEmpty {
                imjangSearchTableView.isHidden = true
            } else {
                imjangSearchTableView.isHidden = false
                imjangSearchTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        configureHierarchy()
        hideKeyboardWhenTappedAround()
        setDelegate()
        setupConstraints()
        designView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeywordList()
    }
    
    private func setKeywordList() {
        searchedKeywordList = UserDefaultManager.shared.searchKeywords
        imjangSearchTableView.reloadData()
    }
    
    private func setDelegate() {
        searchBar.delegate = self
        imjangSearchTableView.delegate = self
        imjangSearchTableView.dataSource = self
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ searchBar.resignFirstResponder()
//    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
        let searchTextFieldItem = UIBarButtonItem(customView: searchBar)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchTextFieldItem
    }
    
    private func configureHierarchy() {
        view.addSubview(imjangSearchTableView)
    }
    
    private func designView() {
        view.backgroundColor = ColorStyle.textWhite
        imjangSearchTableView.backgroundColor = .white
    }
    
    private func setupConstraints() {
        imjangSearchTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func showSearchResultVC(keyword: String) {
        let SearchResultVC = ImjangSearchResultViewController()
        SearchResultVC.searchKeyword = keyword
        navigationController?.pushViewController(SearchResultVC, animated: true)
    }

    private func saveSearchKeyword(keyword: String) {
        var keywordArray = UserDefaultManager.shared.searchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            if keywordArray.count < 3 {
                keywordArray.insert(keyword, at: 0)
            } else {
                keywordArray.removeLast()
                keywordArray.insert(keyword, at: 0)
            }
        }
        
        UserDefaultManager.shared.searchKeywords = keywordArray
    }
    
    @objc func removeAllKeyword() {
        UserDefaultManager.shared.ud.removeObject(forKey: UserDefaultManager.UDKey.searchKeywords.rawValue)
        searchedKeywordList = []
    }
    
    @objc func removeKeyword(sender: UIButton) {
        var keywords = UserDefaultManager.shared.searchKeywords
        let removeKeyword = searchedKeywordList[sender.tag]
        if let index = keywords.firstIndex(where: { $0 == removeKeyword }) {
            keywords.remove(at: index)
            searchedKeywordList = keywords
            UserDefaultManager.shared.searchKeywords = keywords
            imjangSearchTableView.reloadData()
        }
    }
    
}

extension ImjangSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text!
        let trimmedKeyword = keyword.trimmingCharacters(in: [" "])
        if trimmedKeyword.count < 2 {
            showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
            searchBar.text = ""
            return
        }
        if searchedKeywordList.count < 3 {
            searchedKeywordList.append(trimmedKeyword)
        }
        saveSearchKeyword(keyword: trimmedKeyword)
        searchBar.text = ""
        view.endEditing(true)
        showSearchResultVC(keyword: trimmedKeyword)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension ImjangSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let searchKeywordHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchKeywordHeaderView.identifier) as? SearchKeywordHeaderView else {
            return UIView()
        }
        searchKeywordHeaderView.removeAllButton.addTarget(self, action: #selector(removeAllKeyword), for: .touchUpInside)
        return searchKeywordHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchKeywordTableViewCell.identifier, for: indexPath) as! RecentSearchKeywordTableViewCell
        
        cell.setData(keyword: searchedKeywordList[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(removeKeyword), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = searchedKeywordList[indexPath.row]
        saveSearchKeyword(keyword: keyword)
        showSearchResultVC(keyword: keyword)
    }
}
