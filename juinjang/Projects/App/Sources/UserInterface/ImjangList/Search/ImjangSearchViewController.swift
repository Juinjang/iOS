//
//  ImjangSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/24/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ImjangSearchViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let navigationView = SearchNavigationView().then {
        $0.leftItem = [.pop]
        $0.searchPlaceHolder = "집 별명이나 주소를 검색해보세요"
    }
    
    let imjangSearchTableView: UITableView = {
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
        imjangSearchTableView.delegate = self
        imjangSearchTableView.dataSource = self
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        navigationView.itemActionRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)

                case .searchSummit(keyword: let keyword):
                    let trimmedKeyword = keyword.trimmingCharacters(in: [" "])
                    if trimmedKeyword.count < 2 {
                        self.showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
                        return
                    }
                    if self.searchedKeywordList.count < 3 {
                        self.searchedKeywordList.append(trimmedKeyword)
                    }
                    self.saveSearchKeyword(keyword: trimmedKeyword)
                    self.showSearchResultVC(keyword: trimmedKeyword)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureHierarchy() {
        view.add(navigationView, imjangSearchTableView)
    }
    
    private func designView() {
        view.backgroundColor = .mainWhite
        imjangSearchTableView.backgroundColor = .mainWhite
    }
    
    private func setupConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imjangSearchTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
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
