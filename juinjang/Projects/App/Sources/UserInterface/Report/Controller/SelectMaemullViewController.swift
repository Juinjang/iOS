//
//  SelectMaemullViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import Then
import SnapKit
import Alamofire
import RxSwift

protocol SendCompareImjangData{
    func sendData(isSelected: Bool, compareImjangId: Int,  compareImjangName: String)
}

final class SelectMaemullViewController : BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "비교할 매물 고르기"
        $0.rightItem = [.search]
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SelectNoteCell.self)
        collectionView.register(SelectMaemullHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    private let btnBackGroundView = UIView().then{
        $0.backgroundColor = .mainWhite
    }
    
    private let applyButton = UIButton().then{
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.isEnabled = false
    }
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    private var disposeBag = DisposeBag()
    
    private var menuChildren: [UIMenuElement] = []
    private lazy var filterList = Filter.allCases
    private var imjangList: [NoteDTO] = []
    var imjangId: Int
    var comparedImjangId : Int = 0
    private var comparedName : String = ""
    var delegate: SendCompareImjangData?
    
    private var selectedIndex: Int? {
        didSet {
            setApplyButtonEnabled(isEnabled: selectedIndex != nil)
        }
    }
    
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
        navigationController?.isNavigationBarHidden = true
        bindAction()
        retrieveNoteList(excludingId: imjangId)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .mainWhite
        configureHierarchy()
        setConstraint()
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.backBtnTap()
                case .searchButtonTap: owner.searchBtnTap()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setApplyButtonEnabled(isEnabled: Bool) {
        applyButton.backgroundColor = isEnabled ? .gray500 : .null
        applyButton.isEnabled = isEnabled
    }
    
    private func retrieveNoteList(sort: MyNoteFilter = .updated, excludingId: Int) {
        print(#function)
        dependency.noteRepository.retrieveNoteList(sort: sort.parameterValue, keyword: nil)
            .asObservable()
            .subscribe(with: self) { owner, noteResultDTO in
                let notes = noteResultDTO.notes
                let filteredList = notes.filter { item in
                    return item.noteId != excludingId
                }
                owner.imjangList = filteredList
                owner.setEmptyUI(isEmpty: self.imjangList.isEmpty)
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    func setEmptyUI(isEmpty: Bool) {
        collectionView.isHidden = isEmpty ? true : false
    }
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(collectionView)
        
        view.addSubview(btnBackGroundView)
        btnBackGroundView.addSubview(applyButton)
    }
    
    private func setConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        btnBackGroundView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(97)
        }
        
        applyButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(btnBackGroundView.snp.top)
        }
    }
    
    @objc func backBtnTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchBtnTap() {
        let searchVC = CompareSearchViewController(
            dependency: CompareSearchViewController.Dependency(
                noteRepository: NoteRepository()
            ),
            imjangId: imjangId
        )
        searchVC.delegate = self.delegate as? SendSearchCompareImjangData
        navigationController?.pushViewController(searchVC, animated: true)
        applyButton.backgroundColor = .null
    }
    
    @objc func applyButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let selectedIndex else { return }
        let compareNote = imjangList[selectedIndex]
        let canApply = compareNote.rate != "0.0" && compareNote.rate != nil
        if canApply {
            delegate?.sendData(isSelected: true, compareImjangId: comparedImjangId, compareImjangName: comparedName)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.view.makeToast("미평가된 매물은 비교하기 어려워요 :(", duration: 1.0)
        }
    }
}

extension SelectMaemullViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SelectNoteCell.self, for: indexPath)
      
        cell.configureCell(note: imjangList[indexPath.row])
        if let selectedIndex {
            if selectedIndex == indexPath.row {
                cell.isClicked = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let compareImjangId = imjangList[indexPath.row].noteId
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectNoteCell else { return }
        
        if cell.isSelected {
            cell.isClicked = true
            selectedIndex = indexPath.item
            comparedName = imjangList[indexPath.row].name
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(SelectMaemullHeader.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            header.bindAction()
            header.filterActionRelay
                .subscribe(with: self) { owner, action in
                    print(action)
                    switch action {
                    case .updated:
                        owner.retrieveNoteList(sort: .updated, excludingId: owner.imjangId)
                    case .created:
                        owner.retrieveNoteList(sort: .created, excludingId: owner.imjangId)
                    case .star:
                        owner.retrieveNoteList(sort: .star, excludingId: owner.imjangId)
                    }
                }
                .disposed(by: header.disposeBag)
            
            return header
        }
        return UICollectionReusableView()
    }
}

extension SelectMaemullViewController {
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
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(50)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
