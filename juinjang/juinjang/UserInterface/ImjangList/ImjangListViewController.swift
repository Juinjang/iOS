//
//  ImjangListViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/21/24.
//

import UIKit
import SnapKit
import Then

enum Section: Int, CaseIterable {
    case scrap
    case list
}

class ImjangListViewController: UIViewController {
    
    // 임장 노트가 존재하지 않을 때의 뷰
    let emptyBackgroundView = UIView()
    let emptyLogoImageView = UIImageView()
    let emptyMessageLabel = UILabel()
    let newPageButton = UIButton()
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        container.foregroundColor = ColorStyle.darkGray
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.imagePadding = 2
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.setTitleColor(ColorStyle.darkGray, for: .normal)
        button.setImage(ImageStyle.arrowDown, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        button.tintColor = .white
        return button
    }()
    
    let deleteButton = UIButton()
    
    var isEmpty = false
    
    let imjangTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = ColorStyle.textWhite
        tableView.register(ImjangListHeaderView.self, forHeaderFooterViewReuseIdentifier: ImjangListHeaderView.identifier)
        tableView.register(ScrapTableViewCell.self, forCellReuseIdentifier: ScrapTableViewCell.identifier)
        tableView.register(ImjangNoteTableViewCell.self, forCellReuseIdentifier: ImjangNoteTableViewCell.identifier)
        return tableView
    }()
    
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListDto>
//    private lazy var dataSource = createDataSource()
//    lazy var imjangCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        collectionView.delegate = self
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.register(ImjangNoteCollectionViewCell.self, forCellWithReuseIdentifier: ImjangNoteCollectionViewCell.identifier)
//        collectionView.register(ScrapCollectionViewCell.self, forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
//        collectionView.register(ImjangListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImjangListHeaderView.identifier)
//        return collectionView
//    }()
//    
    
    let stickyfilterBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var tableViewSections = Section.allCases
    var scrapImjangList: [ListDto] = []
    var imjangList: [ListDto] = []

    var menuChildren: [UIMenuElement] = []
    lazy var filterList = Filter.allCases
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        designNavigationBar()
        addSubviews()
        setEmptyConstraints()
        setupConstraints()
        configureTableView()
        designView()
        setFilterData()
//        imjangTableView.reloadData()
        newPageButton.addTarget(self, action: #selector(showNewPageVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callRequest()   // 서버 요청 (total Imjang List)
    }
    
    @objc func showNewPageVC() {
        let openNewPageVC = OpenNewPageViewController()
        navigationController?.pushViewController(openNewPageVC, animated: true)
    }
    
    func callRequest() {
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: Filter.update.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                self.imjangList = result.limjangList
                self.setData(scrapedList: result.limjangList)   // 스크랩된것들 scrapList에 추가
                self.setEmptyUI(isEmpty: self.imjangList.isEmpty)
                self.imjangTableView.reloadData()
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
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
//        applyScrapSnapshot(with: scrapImjangList)
//        imjangTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func configureTableView() {
        imjangTableView.delegate = self
        imjangTableView.dataSource = self
    }
    
    // 검색 화면으로 이동
    @objc func showSearchVC() {
        let searchVC = ImjangSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: - Set Data
    func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: {  (action: UIAction) in
                self.changefilterTitle(filter.title)
                self.callRequestFiltered(sort: filter)
            }))
        }
        filterselectBtn.menu = UIMenu(options: .displayAsPalette, preferredElementSize: .small ,children: menuChildren)
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    
    func changefilterTitle(_ title: String) {
        var config = filterselectBtn.configuration
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        container.foregroundColor = ColorStyle.darkGray
        config?.attributedTitle = AttributedString(title, attributes: container)
        config?.imagePadding = 2
        filterselectBtn.configuration = config
    }
    
    func callRequestFiltered(sort: Filter) {
        
    }
    
    @objc func showDeleteImjangVC() {
        let DeleteImjangVC = DeleteImjangViewController()
        self.navigationController?.pushViewController(DeleteImjangVC, animated: true)
    }
    
    func setScrap(imjangNote: ListDto) {
        if scrapImjangList.count < 10 {
            scrapImjangList.append(imjangNote)
        }
    }
    
    @objc func bookMarkButtonClicked(sender: UIButton) {
        var imjangNote = imjangList[sender.tag]
        scrapRequest(imjangId: imjangNote.limjangId)
    }
    
    @objc func scrapBookMarkButtonClicked(sender: UIButton) {
        var imjangNote = scrapImjangList[sender.tag]
        scrapRequest(imjangId: imjangNote.limjangId)
    }
    
    func scrapRequest(imjangId: Int) {
        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self, api: .scrap(imjangId: imjangId)) { response, error in
            if error == nil {
                guard let response = response else { return }
                print(response.message)
                self.callRequest()
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    @objc func openNewPageVC() {
        let openNewPageVC = OpenNewPageViewController()
        self.navigationController?.pushViewController(openNewPageVC, animated: true)
    }
    
    func showImjangNoteVC(imjangId: Int?) {
        guard let imjangId = imjangId else { return }
        let imjangNoteVC = ImjangNoteViewController()
        imjangNoteVC.imjangId = imjangId
        imjangNoteVC.previousVCType = .imjangList
        imjangNoteVC.completionHandler = {
            self.callRequest()
        }
        self.navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
}

extension ImjangListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y, CGFloat(imjangTableView.tableHeaderView?.frame.minY ?? 181) - 54)
        
        let filterY = scrapImjangList.isEmpty ? 132.0 : 280.0
        // 필터뷰의 시작 Y를 통해 sticky 타이밍을 계산
        let shouldShowSticky = scrollView.contentOffset.y >= filterY
        
        stickyfilterBackgroundView.isHidden = !shouldShowSticky
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    // 헤더의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case Section.scrap.rawValue:
            return 0
        case Section.list.rawValue:
            return 49
        default:
            return 0
        }
    }
    // headerView 정의 (필터뷰)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.list.rawValue {
            guard let imjangListHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ImjangListHeaderView.identifier) as? ImjangListHeaderView else {
                return UIView()
            }

            imjangListHeaderView.deleteButton.addTarget(self, action: #selector(showDeleteImjangVC), for: .touchUpInside)

            return imjangListHeaderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.scrap.rawValue:
            return 1
        case Section.list.rawValue:
            return imjangList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.scrap.rawValue:   // 스크랩 섹션일 때
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScrapTableViewCell.identifier, for: indexPath) as? ScrapTableViewCell else {
                return UITableViewCell()
            }
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.setEmptyUI(isEmpty: scrapImjangList.isEmpty)
            cell.collectionView.reloadData()
            
            return cell
            
        case Section.list.rawValue:    // 전체 리스트 섹션일 때
            let cell = tableView.dequeueReusableCell(withIdentifier: ImjangNoteTableViewCell.identifier, for: indexPath) as! ImjangNoteTableViewCell
            cell.selectionStyle = .none
            cell.configureCell(imjangNote: imjangList[indexPath.row])
            cell.bookMarkButton.tag = indexPath.row
            cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.scrap.rawValue:
            return 252
//            return scrapImjangList.isEmpty ? 114 : 252
        case Section.list.rawValue:
            return 116
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imjangId = imjangList[indexPath.row].limjangId
        showImjangNoteVC(imjangId: imjangId)
    }
}

extension ImjangListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scrapImjangList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as! ScrapCollectionViewCell
        
        cell.bookMarkButton.tag = indexPath.row
        cell.setData(imjangNote: scrapImjangList[indexPath.row])
        cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = scrapImjangList[indexPath.row]
        showImjangNoteVC(imjangId: item.limjangId)
    }
}

extension ImjangListViewController {
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 임장노트"
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
        let addButtonItem = UIBarButtonItem(image: ImageStyle.add, style: .plain, target: self, action: #selector(openNewPageVC))
        let searchButtonItem = UIBarButtonItem(image: ImageStyle.search, style: .plain, target: self, action: #selector(showSearchVC))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItems = [addButtonItem, searchButtonItem]
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func addSubviews() {
//        view.addSubview(imjangTableView)
        view.addSubview(imjangTableView)
        view.addSubview(emptyBackgroundView)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
        
        view.addSubview(stickyfilterBackgroundView)
        stickyfilterBackgroundView.addSubview(filterselectBtn)
        stickyfilterBackgroundView.addSubview(deleteButton)
    }
    
    func designView() {
        view.backgroundColor = UIColor(named: "textWhite")
        
        // 비었을 때 로고 이미지뷰
        emptyLogoImageView.design(image: ImageStyle.logo,
                         contentMode: .scaleAspectFit)
        // 비었을 때 추가 권유 메시지 레이블
        emptyMessageLabel.design(text: "아직 등록된 집이 없어요\n지금 바로 부동산을 추가해 볼까요?",
                                 textColor: ColorStyle.textGray,
                                 font: .pretendard(size: 16, weight: .semiBold),
                                 textAlignment: .center,
                                 numberOfLines: 0)
        emptyMessageLabel.setLineSpacing(spacing: 4)
        emptyMessageLabel.textAlignment = .center
        
        
        // 새 페이지 펼치기 버튼
        newPageButton.design(title: "새 페이지 펼치기",
                             font: .pretendard(size: 16, weight: .semiBold),
                             cornerRadius: 10)
        
        deleteButton.design(image: ImageStyle.trash, backgroundColor: .clear)
        
//        imjangTableView.backgroundColor = .white
    }
    
    func setEmptyUI(isEmpty: Bool) {
        emptyBackgroundView.isHidden = isEmpty ? false : true
        imjangTableView.isHidden = isEmpty ? true : false
    }
    
    func setupConstraints() {
        imjangTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stickyfilterBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(49)
        }
        
        filterselectBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(22)
        }
    }
    
    func setEmptyConstraints() {
    
        emptyBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyLogoImageView.snp.makeConstraints {
            $0.centerX.equalTo(emptyBackgroundView)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.4)
            $0.top.equalTo(emptyBackgroundView).offset(UIScreen.main.bounds.height * 0.25)
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(emptyBackgroundView).inset(36)
            $0.top.equalTo(emptyLogoImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.height.equalTo(46)
        }
        
        newPageButton.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(52)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.top.equalTo(emptyMessageLabel.snp.bottom).offset(118)
        }
    }

    
    // 스택뷰 설정
    func setStackView(_ stackView: UIStackView, label: UILabel, image: UIImageView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, imageRight: Bool){
        
        stackView.axis = axis
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        
        if imageRight {
            [label, image].forEach {
                stackView.addArrangedSubview($0)
            }
        } else {
            [image, label].forEach {
                stackView.addArrangedSubview($0)
            }
        }
    }
}


//extension ImjangListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        showImjangNoteVC(imjangId: item.limjangId)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionHeader, indexPath.section == Section.list.rawValue else {
//            fatalError()
//        }
//        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImjangListHeaderView.identifier, for: indexPath) as? ImjangListHeaderView else {
//            return UICollectionReusableView()
//        }
//
//        return headerView
//    }
//
//    func createDataSource() -> DataSource {
//        UICollectionViewDiffableDataSource(collectionView: imjangCollectionView, cellProvider: { (collectionView, indexPath, item) in
//            switch indexPath.section {
//            case Section.scrap.rawValue:
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as? ScrapCollectionViewCell else {
//                    return UICollectionViewCell()
//                }
//
//                cell.setData(imjangNote: item)
//
//                return cell
//            case Section.list.rawValue:
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImjangNoteCollectionViewCell.identifier, for: indexPath) as? ImjangNoteCollectionViewCell else {
//                    return UICollectionViewCell()
//                }
//                print("sdnadjfablsfd으멍나ㅠㄹㅁㅇ노류머ㅗ닝ㄹ")
//                cell.configureCell(imjangNote: item)
//                cell.bookMarkButton.tag = indexPath.row
//                cell.bookMarkButton.addTarget(self, action: #selector(self.bookMarkButtonClicked), for: .touchUpInside)
//
//                return cell
//            default:
//                return UICollectionViewCell()
//            }
//        })
//    }
//
//
//    private func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            // 섹션에 따라 다른 레이아웃을 설정
//            let sectionKind = Section.allCases[sectionIndex]
//            switch sectionKind {
//            case .scrap:
//                return self.createScrapLayout()
//            case .list:
//                return self.createListLayout()
//            }
//        }
//        return layout
//    }
//
//    func createScrapLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(252))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        return section
//    }
//
//    func createListLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
//                                               heightDimension: .absolute(106))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(49))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [sectionHeader]
//        return section
//    }
//    func applyScrapSnapshot(with listDto: [ListDto]) {
//        var snapShot = NSDiffableDataSourceSnapshot<Section, ListDto>()
//        snapShot.appendSections([.scrap])
//        snapShot.appendItems(listDto, toSection: .scrap)
//        dataSource.apply(snapShot, animatingDifferences: false)
//    }
//
//    func applySnapshot(with listDto: [ListDto]) {
//        var snapShot = NSDiffableDataSourceSnapshot<Section, ListDto>()
//        snapShot.appendSections([.list])
//        snapShot.appendItems(listDto)
//        dataSource.apply(snapShot, animatingDifferences: false)
//    }
//}
