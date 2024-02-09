//
//  ImjangListViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/21/24.
//

import UIKit
import SnapKit
import Then

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
        tableView.register(ImjangNoteTableViewCell.self, forCellReuseIdentifier: ImjangNoteTableViewCell.identifier)
        return tableView
    }()
    
    
    let stickyfilterBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var scrapImjangList: [ImjangNote] = [] {
        didSet {
            imjangTableView.invalidateIntrinsicContentSize()
        }
    }
    var imjangList: [ImjangNote] = ImjangList.list
    
    var menuChildren: [UIMenuElement] = []
    lazy var filterList = Filter.allCases
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designNavigationBar()
        addSubviews()
        setEmptyConstraints()
        setupConstraints()
        configureTableView()
        setData()
        designView()
        setFilterData()
        imjangTableView.reloadData()
    }
    
    func setData() {
        for item in imjangList {
            if item.isBookmarked && scrapImjangList.count < 10 {
                scrapImjangList.append(item)
            }
        }
    }
    
    func configureTableView() {
        imjangTableView.delegate = self
        imjangTableView.dataSource = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
                self.callRequestFiltered(sort: filter.title)
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
    
    func callRequestFiltered(sort: String) {
        
    }
    
    @objc func deleteButtonClicked() {
        
    }
    
    @objc func showDeleteImjangVC() {
        let DeleteImjangVC = DeleteImjangViewController()
        self.navigationController?.pushViewController(DeleteImjangVC, animated: true)
    }
    
    @objc func bookMarkButtonClicked(sender: UIButton) {
        var imjangNote = imjangList[sender.tag]
        imjangNote.isBookmarked.toggle()
        if imjangNote.isBookmarked == true {
            if scrapImjangList.count < 10 {
                scrapImjangList.insert(imjangNote, at: 0)
            }
        } 
        imjangList[sender.tag] = imjangNote
        imjangTableView.reloadData()
    }
    
    
    @objc func openNewPageVC() {
        let openNewPageVC = OpenNewPageViewController()
        self.navigationController?.pushViewController(openNewPageVC, animated: true)
    }
    
    @objc func showImjangNoteVC() {
        let imjangNoteVC = ImjangNoteViewController()
        self.navigationController?.pushViewController(imjangNoteVC, animated: true)
    }
    
    @objc func scrapBookMarkButtonClicked(sender: UIButton) {
        sender.isSelected.toggle()
        print(sender.isSelected)
        scrapImjangList.remove(at: sender.tag)
        var imjangNote = imjangList[sender.tag]
        imjangNote.isBookmarked = sender.isSelected
        imjangList[sender.tag] = imjangNote
        imjangTableView.performBatchUpdates(nil)
        imjangTableView.reloadData()
    }
}

extension ImjangListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y, CGFloat(imjangTableView.tableHeaderView?.frame.minY ?? 181) - 54)
        
        let filterY = scrapImjangList.isEmpty ? 132.0 : 296.0
        // 필터뷰의 시작 Y를 통해 sticky 타이밍을 계산
        let shouldShowSticky = scrollView.contentOffset.y >= filterY
        
        stickyfilterBackgroundView.isHidden = !shouldShowSticky
    }
    
    // 헤더의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if scrapImjangList.isEmpty {
            print("비었음")
            return 186
        } else {
            print("안빔")
            return 354
        }
        
    }
    // headerView 정의 (콜렉션뷰, 필터뷰)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let imjangListHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ImjangListHeaderView.identifier) as? ImjangListHeaderView else {
            return UIView()
        }
        imjangListHeaderView.collectionView.delegate = self
        imjangListHeaderView.collectionView.dataSource = self
        imjangListHeaderView.deleteButton.addTarget(self, action: #selector(showDeleteImjangVC), for: .touchUpInside)
        imjangListHeaderView.collectionView.reloadData()
        if scrapImjangList.isEmpty {
            imjangListHeaderView.setFilterView(isEmpty: true)
        }
        else {
            imjangListHeaderView.setFilterView(isEmpty: false)
        }
        print("\(scrapImjangList.count)개")
        print(imjangListHeaderView.bounds.height)
        return imjangListHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImjangNoteTableViewCell.identifier, for: indexPath) as! ImjangNoteTableViewCell
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: imjangList[indexPath.row])
        cell.bookMarkButton.tag = indexPath.row
        cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showImjangNoteVC()
    }
}

extension ImjangListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scrapImjangList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as? ScrapCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        cell.bookMarkButton.tag = indexPath.row
        cell.setData(imjangNote: scrapImjangList[indexPath.row])
        cell.bookMarkButton.addTarget(self, action: #selector(scrapBookMarkButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImjangNoteVC()
    }
}


extension ImjangListViewController {
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "님의 임장노트"     // TODO: - 나중에 nickname 으로 연결
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
        view.addSubview(imjangTableView)
        view.addSubview(emptyBackgroundView)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
        
        if imjangList.isEmpty {
            emptyBackgroundView.isHidden = false
            imjangTableView.isHidden = true
        } else {
            emptyBackgroundView.isHidden = true
            imjangTableView.isHidden = false
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
        
        imjangTableView.backgroundColor = .white
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


#Preview {
    ImjangListViewController()
}
