
import UIKit
import Toast
import SnapKit
import RxSwift

protocol SendSearchCompareImjangData{
    func sendData(isSelected: Bool, compareImjangId: Int,  compareImjangName: String)
}

final class CompareSearchViewController: BaseViewController {
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "건물명이나 주소를 검색해 보세요."
        $0.leftItem = [.pop]
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SelectNoteCell.self)
        return collectionView
    }()
    
    private let emptyImageView = UIImageView().then {
        $0.image = UIImage.Main.nomaemull
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "일치하는 매물이 없어요"
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = .gray300
    }
    
    private let buttonBackgroundView = UIView().then {
        $0.backgroundColor = .mainWhite
    }
    
    private let applyButton = UIButton().then{
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.isHidden = true
    }
    
    var searchKeyword  = ""
    var searchedImjangList: [NoteDTO] = []
    var imjangList: [NoteDTO] = []
    var imjangId: Int
    var comparedImjangId : Int = 0
    var comparedName : String = ""
    
    private var selectedIndex: Int? {
        didSet {
            setApplyButtonEnabled(isEnabled: selectedIndex != nil)
        }
    }
    
    var delegate: SendSearchCompareImjangData?
    private var disposeBag = DisposeBag()
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency, imjangId: Int) {
        self.dependency = dependency
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveNoteList(excludingId: imjangId)
        
        view.backgroundColor = .mainWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        configureHierarchy()
        setupConstraints()
        bindAction()
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func applyButtonTapped(_ sender: UIButton) {
        guard let selectedIndex else { return }
        let compareNote = imjangList[selectedIndex]
        let canApply = compareNote.rate != "0.0" && compareNote.rate != nil
    
        if canApply {
            delegate?.sendData(isSelected: true, compareImjangId: comparedImjangId, compareImjangName: comparedName)
            
            if let navigationController = self.navigationController {
                // comparesearchviewcontroller에서 실행
                if let ReportViewController = navigationController.viewControllers.first(where: { $0 is ReportViewController }) {
                    navigationController.popToViewController(ReportViewController, animated: true)
                }
            }
        } else {
            self.view.makeToast("미평가된 매물은 비교하기 어려워요 :(", duration: 1.0)
        }
    }
    
    private func setApplyButtonEnabled(isEnabled: Bool) {
        applyButton.backgroundColor = isEnabled ? .gray500 : .null
        applyButton.isEnabled = isEnabled
    }
    
    private func bindAction() {
        navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchSummit(let keyword):
                    self.searchBarSearchButtonClicked(searchKeyword: keyword)
                case .searchActive(let isActive):
                    if !isActive {
                        self.searchBarCancelButtonClicked()
                    }
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func searchBarCancelButtonClicked() {
        navigationView.setSearchTextFieldText("")
        searchedImjangList = []
        collectionView.reloadData()
        collectionView.isHidden = true
        applyButton.isHidden = true
    }
    
    private func searchBarSearchButtonClicked(searchKeyword: String) {
        print(searchKeyword)
        searchedImjangList.removeAll()
        selectedIndex = nil
        collectionView.reloadData()
        if searchKeyword.isEmpty {
            setEmptyUI(isEmpty: true)
        } else {
            setEmptyUI(isEmpty: true)
            for item in imjangList {
                if item.name.contains(searchKeyword) {
                    searchedImjangList.append(item)
                    setEmptyUI(isEmpty: false)
                } else {
                    if let address = item.roadAddress {
                        if address.contains(searchKeyword) {
                            searchedImjangList.append(item)
                            setEmptyUI(isEmpty: false)
                        }
                    }
                }
            }
            collectionView.reloadData()
        }
    }
    
    private func retrieveNoteList(sort: MyNoteFilter = .updated, excludingId: Int) {
        dependency.noteRepository.retrieveNoteList(sort: sort.parameterValue, keyword: "")
            .asObservable()
            .subscribe(with: self) { owner, noteResultDTO in
                let notes = noteResultDTO
                let filteredList = notes.filter { item in
                    return item.noteId != excludingId
                }
                owner.imjangList = filteredList
                owner.setEmptyUI(isEmpty: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setEmptyUI(isEmpty: Bool) {
        collectionView.isHidden = isEmpty
        applyButton.isHidden = isEmpty
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: buttonBackgroundView.frame.height,
            right: 0
        )
    }
    
    private func configureHierarchy() {
        view.add(
            navigationView,
            emptyImageView,
            emptyLabel,
            collectionView,
            buttonBackgroundView.with(applyButton)
        )
    }
    
    private func setupConstraints() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(23)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-65)
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints{
            $0.top.equalTo(emptyImageView.snp.bottom).offset(37.17)
            $0.centerX.equalToSuperview()
        }
        
        buttonBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        applyButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
}

extension CompareSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedImjangList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SelectNoteCell.self, for: indexPath)
      
        cell.configureCell(note: searchedImjangList[indexPath.row])
        if let selectedIndex {
            if selectedIndex == indexPath.row {
                cell.isClicked = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let compareImjangId = searchedImjangList[indexPath.row].noteId
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectNoteCell else { return }
        
        if cell.isSelected {
            cell.isClicked = true
            selectedIndex = indexPath.item
            comparedName = searchedImjangList[indexPath.row].name
            comparedImjangId = compareImjangId
        } else {
            cell.isClicked = false
            setApplyButtonEnabled(isEnabled: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectNoteCell else { return }
        
        cell.isClicked = false
        setApplyButtonEnabled(isEnabled: false)
    }
}

extension CompareSearchViewController {
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
        
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        return section
    }
}
