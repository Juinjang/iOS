//
//  ImjangListViewController2.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SkeletonView

protocol SendFilterItemDelegate: AnyObject {
    func sendFilterItem(filter: Filter)
}

protocol DeleteImjangListDelegate: AnyObject {
    func deleteImjangList(_ deleteIdList: [Int])
}

final class ImjangListViewController: BaseViewController {
    
    private let mainView = ImjangListView()
    private let deleteButton = UIButton()   // navigationBar 삭제 버튼
    
    weak var deleteImjangListDelegate: DeleteImjangListDelegate?
    private var scrapImjangList: [ListDto] = [] {
        didSet(oldValue) {
            if oldValue.isEmpty && !scrapImjangList.isEmpty {   // 데이터가 존재하게 됐을 때
                mainView.collectionView.collectionViewLayout = mainView.createCollectionViewLayout(isScrapEmpty: false)
            } else if !oldValue.isEmpty && scrapImjangList.isEmpty {    // 데이터가 존재하지 않게 됐을 때
                mainView.collectionView.collectionViewLayout = mainView.createCollectionViewLayout(isScrapEmpty: true)
            }

        }
    }
    var imjangList: [ListDto] = [] {
        didSet(oldValue) {
            if !oldValue.isEmpty && imjangList.isEmpty {
                mainView.emptyBackgroundView.isHidden = false
                mainView.collectionView.isHidden = true
            } else if oldValue.isEmpty && !imjangList.isEmpty {
                mainView.emptyBackgroundView.isHidden = true
                mainView.collectionView.isHidden = false
            }
        }
    }
    
    private var currentFilter: Filter = .update

    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        setDelegate()
        fetchImjangList(sort: .update, setScrap: true)
        mainView.emptyBackgroundView.isHidden = !imjangList.isEmpty
        mainView.collectionView.isHidden = imjangList.isEmpty
        mainView.newPageButton.addTarget(self, action: #selector(openNewPageVC), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshImjangList), name: .refreshImjangList, object: nil)
    }
    
    override func loadView() {
        view = mainView
    }

    private func setDelegate() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 임장노트"
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage.arrowLeft, style: .plain, target: self, action: #selector(popView))
        let addButtonItem = UIBarButtonItem(image: UIImage.ImjangNote.add, style: .plain, target: self, action: #selector(openNewPageVC))
        let searchButtonItem = UIBarButtonItem(image: UIImage.ImjangList.search, style: .plain, target: self, action: #selector(showSearchVC))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItems = [addButtonItem, searchButtonItem]
    }
}

extension ImjangListViewController: SendFilterItemDelegate {
    func sendFilterItem(filter: Filter) {
        currentFilter = filter
        fetchImjangList(sort: filter)
    }
}

// MARK: - request
extension ImjangListViewController {
    private func fetchImjangList(sort: Filter = .update, setScrap: Bool = false) {
        print(#function)
        showSkeletonView()
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: sort.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                self.imjangList = result.limjangList
                self.setData(scrapedList: result.limjangList)   // 스크랩된것들 scrapList에 추가
                self.mainView.collectionView.reloadData()
            } else {
                print("failedRequest")
            }
        }
    }
    
    private func showSkeletonView() {
        mainView.collectionView.showAnimatedSkeleton(usingColor: .gray100, transition: .crossDissolve(0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.collectionView.stopSkeletonAnimation()
            self.mainView.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }
    
    @objc private func refreshImjangList() {
        print(#function)
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: currentFilter.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                self.imjangList = result.limjangList
                self.setData(scrapedList: result.limjangList)   // 스크랩된것들 scrapList에 추가
                self.mainView.collectionView.reloadData()
            } else {
                print("failedRequest")
            }
        }
    }
    
    // 스크랩 리스트 설정
    func setData(scrapedList: [ListDto]) {
        scrapImjangList = []
        for item in scrapedList {
            if item.isScraped && scrapImjangList.count < 10 {
                scrapImjangList.append(item)
            }
        }
    }
}

extension ImjangListViewController: DeleteImjangListDelegate {
    // 뒤로 가기
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // 새 페이지 만들기
    @objc private func openNewPageVC() {
        let openNewPageVC = OpenNewPageViewController()
        self.navigationController?.pushViewController(openNewPageVC, animated: true)
    }
    
    // 검색 화면으로 이동
    @objc private func showSearchVC() {
        let searchVC = ImjangSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 삭제 화면으로 이동
    @objc private func showDeleteImjangVC() {
        let DeleteImjangVC = DeleteImjangViewController()
        DeleteImjangVC.deleteImjangListDelegate = self
        self.navigationController?.pushViewController(DeleteImjangVC, animated: true)
    }
    
    // 임장노트 나누기 화면으로 이동
    @objc private func showDivideImjangVC() {
        
    }
    
    // 임장노트 화면으로 이동
    private func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId = imjangId, let version = version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .imjangList
//        imjangNoteVC.completionHandler = {
//            self.fetchImjangList()
//        }
        self.navigationController?.pushViewController(imjangNoteVC, animated: true)
    }

    // 삭제할 임장 삭제
    func deleteImjangList(_ deleteIdList: [Int]) {
        deleteImjangListDelegate?.deleteImjangList(deleteIdList)
        imjangList.removeAll { imjang in
            deleteIdList.contains(imjang.limjangId)
        }

        scrapImjangList.removeAll { scrapImjang in
            deleteIdList.contains(scrapImjang.limjangId)
        }
        mainView.collectionView.reloadData()
    }
    
    private func setScrap(imjangNote: ListDto) {
        if scrapImjangList.count < 10 {
            scrapImjangList.append(imjangNote)
        }
    }
    
    private func cancelScrap(imjangId: Int) {
        if let index = scrapImjangList.firstIndex(where: { $0.limjangId == imjangId }) {
            scrapImjangList.remove(at: index)
        }

        setIsScrap(imjangId: imjangId, isScraped: false)
        mainView.collectionView.reloadData()
    }

    private func setScrap(imjangId: Int) {
        setIsScrap(imjangId: imjangId, isScraped: true)

        guard let imjang = getImjang(imjangId: imjangId) else { return }
        scrapImjangList.insert(imjang, at: 0)
        mainView.collectionView.reloadData()
    }
    
    private func getImjang(imjangId: Int) -> ListDto? {
        if let index = imjangList.firstIndex(where: { $0.limjangId == imjangId }) {
            let imjang = imjangList[index]
            return imjang
        }
        return nil
    }

    private func setIsScrap(imjangId: Int, isScraped: Bool) {
        if let imjangIndex = imjangList.firstIndex(where: { $0.limjangId == imjangId }) {
            var imjang = imjangList[imjangIndex]
            imjang.isScraped = isScraped
            imjangList[imjangIndex] = imjang
        }
    }

    private func scrapRequest(imjangId: Int) {
        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self, api: .scrap(imjangId: imjangId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let response = response else { return }
            print(response.message)
        }
    }
        
    private func cancelScrapRequest(imjangId: Int) {
        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self, api: .cancelScrap(imjangId: imjangId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            print(response.message)
        }
    }

    private func callVersionRequest(imjangId: Int, completion: @escaping (Int?) -> Void) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if error == nil {
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
            } else {
                guard let error else {
                    completion(nil)
                    return
                }
                print("failedRequest")
                completion(nil)
            }
        }
    }
    
    // 전체 리스트 - 북마크 버튼 클릭 시
    @objc private func bookMarkButtonClicked(sender: UIButton) {
        let imjangNote = imjangList[sender.tag]
        let imjangId = imjangNote.limjangId
        if imjangNote.isScraped {   // 이미 스크랩 되어있으면 스크랩 취소
            cancelScrap(imjangId: imjangId)
            cancelScrapRequest(imjangId: imjangId)
        } else {
            setScrap(imjangId: imjangId)
            scrapRequest(imjangId: imjangId)
        }
    }
    
    // 스크랩 - 북마크 버튼 클릭 시
    @objc private func scrapBookmarkButtonClicked(sender: UIButton) {
        let imjangNote = scrapImjangList[sender.tag]
        let imjangId = imjangNote.limjangId
        if imjangNote.isScraped {   // 이미 스크랩 되어있으면 스크랩 취소
            cancelScrap(imjangId: imjangId)
            cancelScrapRequest(imjangId: imjangId)
        } else {
            setScrap(imjangId: imjangId)
            scrapRequest(imjangId: imjangId)
        }
    }
}

// MARK: - CollectionView Delegate
extension ImjangListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imjangSection = Section(rawValue: section) {
            switch imjangSection {
            case .scrap:
                return scrapImjangList.count
            case .list:
                return imjangList.count
            }
        } else {
            return 0
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imjangSection = Section(rawValue: indexPath.section) {
            switch imjangSection {
            case .scrap:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as? ScrapCollectionViewCell else { return UICollectionViewCell() }
                
                let item = scrapImjangList[indexPath.item]
                cell.setData(imjangNote: item)
                cell.bookMarkButton.tag = indexPath.row
                cell.bookMarkButton.addTarget(self, action: #selector(scrapBookmarkButtonClicked), for: .touchUpInside)
                
                return cell
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImjangNoteCollectionViewCell.identifier, for: indexPath) as? ImjangNoteCollectionViewCell else { return UICollectionViewCell() }
                
                let item = imjangList[indexPath.item]
                cell.bookMarkButton.tag = indexPath.row
                cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
                cell.configureCell(imjangNote: item)
                
                return cell
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imjangSection = Section(rawValue: indexPath.section) {
            switch imjangSection {
            case .scrap:
                let item = scrapImjangList[indexPath.row]
                callVersionRequest(imjangId: item.limjangId) { [weak self] version in
                guard let self else { return }
                    if let version = version {
                      self.showImjangNoteVC(imjangId: item.limjangId, version: version)
                    } else {
                      self.showImjangNoteVC(imjangId: item.limjangId, version: version)
                    }
                }
            case .list:
                let imjangId = imjangList[indexPath.row].limjangId
                callVersionRequest(imjangId: imjangId) { [weak self] version in
                    guard let self else { return }
                    if let version = version {
                        showImjangNoteVC(imjangId: imjangId, version: version)
                    } else {
                        showImjangNoteVC(imjangId: imjangId, version: version)
                    }
                }
            }
        } else {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .scrap:
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ScrapCellEmptyBackground.identifier, for: indexPath) as? ScrapCellEmptyBackground else {
                        return UICollectionReusableView()
                    }
                    
                    return header
                }
            case .list:
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImjangListHeader.identifier, for: indexPath) as? ImjangListHeader else {
                        return UICollectionReusableView()
                    }
                    header.deleteButton.addTarget(self, action: #selector(showDeleteImjangVC), for: .touchUpInside)
                    header.sendFilterItemDelegate = self
                    
                    header.shareButton.addTarget(self, action: #selector(showDivideImjangVC), for: .touchUpInside)
                    
                    return header
                }
            }
        }
        return UICollectionReusableView()
    }
}
