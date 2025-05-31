//
//  ImjangSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/24/24.
//

import UIKit
import Then
import RxSwift
import SnapKit

final class ImjangSearchViewController: BaseViewController {
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "건물명이나 주소를 검색해 보세요."
        $0.leftItem = [.pop]
    }
    
    private let imjangSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .mainWhite
        tableView.sectionHeaderTopPadding = 12
        tableView.register(SearchKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchKeywordHeaderView.identifier)
        tableView.register(RecentSearchKeywordTableViewCell.self, forCellReuseIdentifier: RecentSearchKeywordTableViewCell.identifier)
        return tableView
    }()
    
    private var searchedKeywordList: [String] = [] {
        didSet {
            if searchedKeywordList.isEmpty {
                imjangSearchTableView.isHidden = true
            } else {
                imjangSearchTableView.isHidden = false
                imjangSearchTableView.reloadData()
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        designNavigationBar()
        navigationController?.isNavigationBarHidden = true
        configureHierarchy()
//        hideKeyboardWhenTappedAround()
        setDelegate()
        setupConstraints()
        designView()
        bindAction()
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
        imjangSearchTableView.delegate = self
        imjangSearchTableView.dataSource = self
    }
    
//    private func hideKeyboardWhenTappedAround() {
////        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
    
    private func bindAction() {
        navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchSummit(let keyword):
                    self.searchBarSearchButtonClicked(keyword: keyword)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }

    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // 네비게이션 바 디자인
//    private func designNavigationBar() {
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//        self.navigationController?.navigationBar.tintColor = .black
//
//        // UIBarButtonItem 생성 및 이미지 설정
//        let backButtonItem = UIBarButtonItem(image: UIImage.arrowLeft, style: .plain, target: self, action: #selector(popView))
//        let searchTextFieldItem = UIBarButtonItem(customView: searchBar)
//    
//        // 네비게이션 아이템에 백 버튼 아이템 설정
//        self.navigationItem.leftBarButtonItem = backButtonItem
//        self.navigationItem.rightBarButtonItem = searchTextFieldItem
//    }
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(imjangSearchTableView)
    }
    
    private func designView() {
        view.backgroundColor = .mainWhite
        imjangSearchTableView.backgroundColor = .mainWhite
    }
    
    private func setupConstraints() {
        navigationView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        imjangSearchTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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

extension ImjangSearchViewController {
    func searchBarSearchButtonClicked(keyword: String) {
        let trimmedKeyword = keyword.trimmingCharacters(in: [" "])
        if trimmedKeyword.count < 2 {
            showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
        
            return
        }
        if searchedKeywordList.count < 3 {
            searchedKeywordList.append(trimmedKeyword)
        }
        saveSearchKeyword(keyword: trimmedKeyword)
        view.endEditing(true)
        showSearchResultVC(keyword: trimmedKeyword)
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
