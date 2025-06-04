//
//  ImjangSearchResultViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import SkeletonView
import RxSwift
import SnapKit
import Then

final class ImjangSearchResultViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let navigationView = SearchNavigationView().then {
        $0.leftItem = [.pop]
        $0.searchPlaceHolder = "집 별명이나 주소를 검색해보세요"
    }
    
    private let noteRepository = NoteRepository()
    
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
    var searchedImjangList: [MyImjangResponseDTO] = []
    
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
            noteRepository.retrieveNoteList(sort: "UPDATED", keyword: searchKeyword)
                .asObservable()
                .subscribe(with: self) { (self, response) in
                    self.searchedImjangList = response
                    self.searchedTableView.reloadData()
                }
                .disposed(by: disposeBag)
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
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        navigationView.itemActionRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)

                case .searchSummit(keyword: let keyword):
                    if keyword.count < 2 {
                        self.showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
                        return
                    }
                    self.saveSearchKeyword(keyword: keyword)
                    self.searchKeyword = keyword
                    self.searchRequest()
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureHierarchy() {
        view.add(navigationView, searchedTableView)
    }

    private func designView() {
        view.backgroundColor = .mainWhite
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
        
        emptyImage.alpha = 0
        emptyLabel.alpha = 0
    }

    private func setupConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
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
        let imjangId = searchedImjangList[indexPath.row].noteId
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
