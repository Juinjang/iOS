//
//  ImjangListViewController2.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SkeletonView
import RxSwift

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
    
    private var scrapImjangList: [NoteDTO] = [] {
        didSet(oldValue) {
            if oldValue.isEmpty && !scrapImjangList.isEmpty {   // 데이터가 존재하게 됐을 때
                mainView.collectionView.collectionViewLayout = mainView.createCollectionViewLayout(isScrapEmpty: false)
            } else if !oldValue.isEmpty && scrapImjangList.isEmpty {    // 데이터가 존재하지 않게 됐을 때
                mainView.collectionView.collectionViewLayout = mainView.createCollectionViewLayout(isScrapEmpty: true)
            }
        }
    }
        
    var imjangList: [NoteDTO] = [] {
        didSet(oldValue) {
            if !oldValue.isEmpty && imjangList.isEmpty {
                mainView.collectionView.isHidden = true
            } else if oldValue.isEmpty && !imjangList.isEmpty {
                mainView.collectionView.isHidden = false
            }
        }
    }

    
    private var currentFilter: MyNoteFilter = .updated
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
        let onboardingRepository: OnboardingRepositoryProtocol
    }
    
    private let dependency: Dependency
    private var disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setDelegate()
        fetchImjangList(sort: .updated, setScrap: true)
        mainView.collectionView.isHidden = imjangList.isEmpty
        mainView.newPageButton.addTarget(self, action: #selector(navigateToAddNewNoteVC), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshImjangList), name: .refreshImjangList, object: nil)
    }
    
    override func loadView() {
        view = mainView
    }

    private func setDelegate() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func bind() {
        mainView.navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .popButtonTap:
                    self.popView()
                case .searchButtonTap:
                    self.showSearchVC()
                case .addButtonTap:
                    self.navigateToAddNewNoteVC()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - request
extension ImjangListViewController {
    private func fetchImjangList(sort: MyNoteFilter = .updated, setScrap: Bool = false) {
        setLoading(isShow: true)

        if UserDefaultManager.shared.isOnboarding {
            dependency
                .onboardingRepository
                .retrieveMyNotes()
                .asObservable()
                .catch { [weak self] error in
                    self?.setLoading(isShow: false)
                    self?.showAlert(title: "에러", message: error.localizedDescription, actionHandler: nil)
                    return .empty()
                }
                .subscribe(with: self) { (self, response) in
                    self.mainView.setupEmptyView(isEmpty: response.isEmpty)
                    self.imjangList = response
                    self.setData(scrapedList: response)   // 스크랩된것들 scrapList에 추가
                    self.mainView.hasResults(!self.imjangList.isEmpty)
                    self.mainView.collectionView.reloadData()
                    self.setLoading(isShow: false)
                }
                .disposed(by: disposeBag)
            
            return
        }
        
        print(#function)
        dependency
            .noteRepository
            .retrieveNoteList(sort: sort.parameterValue, keyword: "")
            .asObservable()
            .catch { [weak self] error in
                self?.setLoading(isShow: false)
                self?.showAlert(title: "에러", message: error.localizedDescription, actionHandler: nil)
                return .empty()
            }
            .subscribe(with: self) { owner, noteResultDTO in
                print(noteResultDTO)
                let notes = noteResultDTO
                owner.mainView.setupEmptyView(isEmpty: notes.isEmpty)
                owner.imjangList = notes
                owner.setData(scrapedList: notes)   // 스크랩된것들 scrapList에 추가
                owner.mainView.hasResults(!self.imjangList.isEmpty)
                owner.mainView.collectionView.reloadData()
                owner.setLoading(isShow: false)
            }
            .disposed(by: self.disposeBag)
        
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
        
        dependency
            .noteRepository
            .retrieveNoteList(
                sort: currentFilter.parameterValue,
                keyword: ""
            )
            .asObservable()
            .subscribe(with: self) { (self, response) in
                self.imjangList = response
                self.mainView.setupEmptyView(isEmpty: response.isEmpty)
                self.setData(scrapedList: response)   // 스크랩된것들 scrapList에 추가
                self.mainView.collectionView.reloadData()
                self.mainView.hasResults(!self.imjangList.isEmpty)
            }
            .disposed(by: disposeBag)
    }
    
    // 스크랩 리스트 설정
    func setData(scrapedList: [NoteDTO]) {
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
    @objc private func navigateToAddNewNoteVC() {
        let viewController = AddNewNoteViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 검색 화면으로 이동
    @objc private func showSearchVC() {
        let searchVC = ImjangSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 삭제 화면으로 이동
    @objc private func showDeleteImjangVC() {
        // 온보딩 분기처리
        if UserDefaultManager.shared.isOnboarding {
            present(SignUpBottomSheetView(), animated: true)
            return
        }
        
        let DeleteImjangVC = DeleteImjangViewController(
            dependency: DeleteImjangViewController.Dependency(
                noteRepository: NoteRepository()
            )
        )
        DeleteImjangVC.deleteImjangListDelegate = self
        self.navigationController?.pushViewController(DeleteImjangVC, animated: true)
    }
    
    @objc private func showShareSelectVC() {
        // 온보딩 분기처리
        if UserDefaultManager.shared.isOnboarding {
            present(SignUpBottomSheetView(), animated: true)
            return
        }
        
        let viewController = ShareSelectViewController(
            reactor: .init(
                dependency: .init(
                    noteRepository: NoteRepository(),
                    userRepository: UserRepository()
                )
            )
        )
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 임장노트 화면으로 이동
    private func showImjangNoteVC(imjangId: Int?, version: Int?) {
        guard let imjangId = imjangId, let version = version else { return }
        let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .imjangList
        self.navigationController?.pushViewController(imjangNoteVC, animated: true)
    }

    // 삭제할 임장 삭제
    func deleteImjangList(_ deleteIdList: [Int]) {
        deleteImjangListDelegate?.deleteImjangList(deleteIdList)
        imjangList.removeAll { imjang in
            deleteIdList.contains(imjang.noteId)
        }

        scrapImjangList.removeAll { scrapImjang in
            deleteIdList.contains(scrapImjang.noteId)
        }

        mainView.collectionView.reloadData()
        mainView.hasResults(!imjangList.isEmpty)
    }
    
    private func setScrap(imjangNote: NoteDTO) {
        if scrapImjangList.count < 10 {
            scrapImjangList.append(imjangNote)
        }
    }
    
    private func cancelScrap(noteId: Int) {
        if let index = scrapImjangList.firstIndex(where: { $0.noteId == noteId }) {
            scrapImjangList.remove(at: index)
        }

        setIsScrap(noteId: noteId, isScraped: false)
        mainView.collectionView.reloadData()
    }

    private func setScrap(noteId: Int) {
        setIsScrap(noteId: noteId, isScraped: true)

        guard let imjang = getImjang(noteId: noteId) else { return }
        scrapImjangList.insert(imjang, at: 0)
        mainView.collectionView.reloadData()
    }
    
    private func getImjang(noteId: Int) -> NoteDTO? {
        if let index = imjangList.firstIndex(where: { $0.noteId == noteId }) {
            let imjang = imjangList[index]
            return imjang
        }
        return nil
    }

    private func setIsScrap(noteId: Int, isScraped: Bool) {
        if let imjangIndex = imjangList.firstIndex(where: { $0.noteId == noteId }) {
            var imjang = imjangList[imjangIndex]
            imjang.isScraped = isScraped
            imjangList[imjangIndex] = imjang
        }
    }

    private func scrapRequest(imjangId: Int) {
        // 온보딩 분기처리
        guard (!UserDefaultManager.shared.isOnboarding) else { return }

        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self,
                                            api: .scrap(imjangId: imjangId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let response = response else { return }
            print(response.message)
        }
    }
        
    private func cancelScrapRequest(noteId: Int) {
        // 온보딩 분기처리
        guard (!UserDefaultManager.shared.isOnboarding) else { return }
        
        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self, api: .cancelScrap(imjangId: noteId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            print(response.message)
        }
    }

    private func callVersionRequest(imjangId: Int,
                                    completion: @escaping (Int?) -> Void) {
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
        let noteId = imjangNote.noteId
        if imjangNote.isScraped {   // 이미 스크랩 되어있으면 스크랩 취소
            cancelScrap(noteId: noteId)
            cancelScrapRequest(noteId: noteId)
        } else {
            setScrap(noteId: noteId)
            scrapRequest(imjangId: noteId)
        }
    }
    
    // 스크랩 - 북마크 버튼 클릭 시
    @objc private func scrapBookmarkButtonClicked(sender: UIButton) {
        let imjangNote = scrapImjangList[sender.tag]
        let noteId = imjangNote.noteId
        if imjangNote.isScraped {   // 이미 스크랩 되어있으면 스크랩 취소
            cancelScrap(noteId: noteId)
            cancelScrapRequest(noteId: noteId)
        } else {
            setScrap(noteId: noteId)
            scrapRequest(imjangId: noteId)
        }
    }
}

// MARK: - CollectionView Delegate
extension ImjangListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imjangSection = Section(rawValue: indexPath.section) {
            switch imjangSection {
            case .scrap:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as? ScrapCollectionViewCell else { return UICollectionViewCell() }
                
                let item = scrapImjangList[indexPath.item]
                cell.setData(note: item)
                cell.bookMarkButton.tag = indexPath.row
                cell.bookMarkButton.addTarget(self, action: #selector(scrapBookmarkButtonClicked), for: .touchUpInside)
                
                return cell
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImjangNoteCollectionViewCell.identifier, for: indexPath) as? ImjangNoteCollectionViewCell else { return UICollectionViewCell() }
                
                let item = imjangList[indexPath.item]
                cell.bookMarkButton.tag = indexPath.row
                cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
                cell.configureCell(note: item)
                
                return cell
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let imjangSection = Section(rawValue: indexPath.section) {
            switch imjangSection {
            case .scrap:
                let item = scrapImjangList[indexPath.row]
                
                // 온보딩 분기처리
                if UserDefaultManager.shared.isOnboarding {
                    self.showImjangNoteVC(imjangId: item.noteId, version: 0)
                    return
                }
                
                callVersionRequest(imjangId: item.noteId) { [weak self] version in
                guard let self else { return }
                    if let version = version {
                      self.showImjangNoteVC(imjangId: item.noteId, version: version)
                    } else {
                      self.showImjangNoteVC(imjangId: item.noteId, version: version)
                    }
                }
            case .list:
                let imjangId = imjangList[indexPath.row].noteId
                // 온보딩 분기처리
                if UserDefaultManager.shared.isOnboarding {
                    self.showImjangNoteVC(imjangId: imjangId, version: 0)
                    return
                }
                
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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
                    header.bindAction()
                    header.deleteButton.addTarget(self, action: #selector(showDeleteImjangVC), for: .touchUpInside)
                    header.shareButton.addTarget(self, action: #selector(showShareSelectVC), for: .touchUpInside)
                    header.filterActionRelay
                        .subscribe(with: self) { owner, action in
                            // 온보딩 분기처리
                            guard (!UserDefaultManager.shared.isOnboarding) else { return }
                            print(action)
                            switch action {
                            case .updated:
                                owner.currentFilter = .updated
                                owner.fetchImjangList(sort: .updated)
                            case .created:
                                owner.currentFilter = .created
                                owner.fetchImjangList(sort: .created)
                            case .star:
                                owner.currentFilter = .star
                                owner.fetchImjangList(sort: .star)
                            }
                        }
                        .disposed(by: header.disposeBag)
            
                    return header
                }
            }
        }
        return UICollectionReusableView()
    }
}
