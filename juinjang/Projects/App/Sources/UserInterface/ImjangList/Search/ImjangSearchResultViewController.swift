//
//  ImjangSearchResultViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import SkeletonView
import SnapKit
import RxSwift

final class ImjangSearchResultViewController: BaseViewController {
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "건물명이나 주소를 검색해 보세요."
        $0.leftItem = [.pop]
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ImjangNoteCollectionViewCell.self)
        collectionView.register(ImjangSkeletonCollectionViewCell.self, forCellWithReuseIdentifier: ImjangSkeletonCollectionViewCell.identifier)
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    private let emptyImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = UIImage.Main.nomaemull
        return emptyImage
    }()
    
    private let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "일치하는 매물이 없어요"
        emptyLabel.font = .pretendard(size: 16, weight: .medium)
        emptyLabel.textColor = .gray400
        return emptyLabel
    }()
    
    var searchKeyword  = ""
    private var searchedImjangList: [NoteDTO] = []
    private var disposeBag = DisposeBag()
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setupConstraints()
        designView()
        addSubView()
        setConstraints()
        bindAction()
        searchRequest()
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchRequest), name: .refreshSearchList, object: nil)
    }
    
    private func bindAction() {
        navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchSummit(let keyword):
                    self.searchBarSearchButtonClicked(keyword: keyword)
                case .searchActive(let isActive):
                    if !isActive {
                        self.searchBarCancelButtonClicked()
                    }
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showSkeletonView() {
        setEmptyView(false)
        collectionView.showAnimatedSkeleton(usingColor: .gray100, transition: .crossDissolve(0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.collectionView.stopSkeletonAnimation()
            self.collectionView.hideSkeleton()
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
        
        // 도메인 분기 처리
        if UserDefaultManager.shared.isOnboarding {
            // 2자 미만 입력 → 검색 미적용
            let trimmed = self.searchKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count >= 2 else { return }
            
            let lowercasedKeyword = trimmed.lowercased()
            let notes = [
                NoteDTO(noteId: 1,
                        purposeType: "RESIDENTIAL_PURPOSE",
                        propertyType: "APARTMENT",
                        priceType: "SALE",
                        name: "우성 아파트",
                        imageUrl: [
                            "https://juinjang-bucket.s3.ap-northeast-2.amazonaws.com/mock/mock_png_1.png",
                            "https://juinjang-bucket.s3.ap-northeast-2.amazonaws.com/mock/mock_png_2.png",
                            "https://juinjang-bucket.s3.ap-northeast-2.amazonaws.com/mock/mock_png_3.png"
                        ],
                        isScraped: true,
                        rate: "4.5",
                        price: "500000000",
                        monthlyRent: nil,
                        pyong: 28,
                        floor: "10",
                        shortAddress: "101동 1001호",
                        address: "서울 송파구 잠실동 101-1")
            ].filter { note in
                // 집 별명
                if note.name.lowercased().contains(lowercasedKeyword) {
                    return true
                }
                
                // 도로명 주소 (옵셔널 안전 처리)
                if let shortAddress = note.shortAddress?.lowercased(),
                   shortAddress.contains(lowercasedKeyword) {
                    return true
                }
                
                if let address = note.address?.lowercased(),
                   address.contains(lowercasedKeyword) {
                    return true
                }
                
                return false
            }
            
            self.searchedImjangList = notes
            self.collectionView.reloadData()
            return
        }
        
        if searchKeyword.count > 0 {
            dependency
                .noteRepository
                .retrieveNoteList(sort: Filter.update.sortValue, keyword: searchKeyword)
                .asObservable()
                .subscribe(with: self) { owner, noteResultDTO in
                    print(noteResultDTO)
                    let notes = noteResultDTO
                    owner.searchedImjangList = notes
                    owner.collectionView.reloadData()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(collectionView)
    }
    
    private func designView() {
        view.backgroundColor = .mainWhite
        navigationView.setSearchTextFieldText(searchKeyword)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        emptyImage.alpha = 0
        emptyLabel.alpha = 0
    }
    
    private func setupConstraints() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(12)
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

extension ImjangSearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchedImjangList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImjangNoteCollectionViewCell.self, for: indexPath)
        cell.configureCell(note: searchedImjangList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imjangId = searchedImjangList[indexPath.row].noteId
        callVersionRequest(imjangId: imjangId) { version in
            if let version = version {
                self.showImjangNoteVC(imjangId: imjangId, version: version)
            } else {
                self.showImjangNoteVC(imjangId: imjangId, version: version)
            }
        }
    }
}

extension ImjangSearchResultViewController {
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

extension ImjangSearchResultViewController {
    func searchBarSearchButtonClicked(keyword: String) {
        if keyword.count < 2 {
            showAlert(title: "경고", message: "2글자 이상 입력해주세요", actionHandler: nil)
            return
        }
        saveSearchKeyword(keyword: keyword)
        searchKeyword = keyword
        searchRequest()
    }
    
    func searchBarCancelButtonClicked() {
        navigationView.setSearchTextFieldText("")
        searchedImjangList = []
        collectionView.reloadData()
    }
}

extension ImjangSearchResultViewController: SkeletonCollectionViewDataSource {
    // skeletonView
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ImjangSkeletonCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        skeletonCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell? {
        let identifier = ImjangSkeletonCollectionViewCell.identifier
        let cell = skeletonView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as! ImjangSkeletonCollectionViewCell
        
        return cell
    }
}

extension ImjangSearchResultViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return selectNoteLayoutSection()
        }
    }
    
    private func selectNoteLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(136))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        return section
    }
}
