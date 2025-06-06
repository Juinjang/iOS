//
//  DeleteImjangViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import Then
import SnapKit
import Toast
import RxSwift

final class DeleteImjangViewController: BaseViewController {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "삭제할 페이지를 선택해 주세요."
        $0.titleColor = .gray400
    }
    
    private let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: 24)).then {
        $0.text = "삭제할 페이지를 선택해주세요"
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SelectNoteCell.self)
        collectionView.register(DeleteNoteHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private let deleteButtonBackgroundView = UIView().then {
        $0.backgroundColor = .mainWhite
    }
    
    private let deleteButton = UIButton()
    
    private var selectedIndexes: Set<Int> = [] {
        didSet {
            setDeleteButtonDesign()
        }
    }
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
    }
    
    private var imjangList: [NoteDTO] = []
    weak var deleteImjangListDelegate: DeleteImjangListDelegate?
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

        bindAction()
        configureCollectionView()
        configureHierarchy()
        configureLayout()
        configureView()
        retrieveNoteList()
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    private func bindAction() {
        navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.popView()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private  func deleteButtonClicked() {
        let deleteImjangPopupVC = DeleteImjangPopupViewController()
        guard let roomIndex = selectedIndexes.first else { return }
        deleteImjangPopupVC.selectedRoomName = imjangList[roomIndex].name
        deleteImjangPopupVC.selectedCount = selectedIndexes.count
        deleteImjangPopupVC.modalPresentationStyle = .overFullScreen
        
        deleteImjangPopupVC.completionHandler = { [weak self] in
            guard let self else { return }
            let indexs = self.selectedIndexes.sorted(by: <)
            print(indexs)
            var ids: [Int] = []
            for index in indexs {
                ids.append(self.imjangList[index].noteId)
            }
            print(ids)
            self.deleteRequest(imjangIds: ids)
            deleteImjangListDelegate?.deleteImjangList(ids)
        }
        present(deleteImjangPopupVC, animated: false)
    }
    
    private func deleteRequest(imjangIds: [Int]) {
        print(#function, "\(imjangIds)")
        let parameter: [String: Any] = [
            "limjangIdList": imjangIds
        ]
        print(JuinjangAPI.deleteImjangs(imjangIds: imjangIds).header)
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .deleteImjangs(imjangIds: imjangIds), parameter: parameter) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            print(response)
            self.selectedIndexes.removeAll()
            self.view.makeToast("선택된 임장이 삭제되었습니다.", duration: 1.0)
            self.retrieveNoteList()
        }
    }
    
    private func retrieveNoteList() {
        dependency.noteRepository.retrieveNoteList(sort: Filter.update.sortValue, keyword: nil)
            .asObservable()
            .subscribe(with: self) { owner, noteResultDTO in
                print(noteResultDTO)
                let notes = noteResultDTO.notes
                owner.imjangList = notes
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(collectionView)
        view.addSubview(deleteButtonBackgroundView)
        deleteButtonBackgroundView.addSubview(deleteButton)
    }
    
    private func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(deleteButtonBackgroundView.snp.top)
        }
        
        deleteButtonBackgroundView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view)
            $0.height.equalTo(98)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(deleteButtonBackgroundView.snp.top).offset(12)
            $0.horizontalEdges.equalTo(deleteButtonBackgroundView).inset(24)
            $0.bottom.equalTo(deleteButtonBackgroundView.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .mainWhite
        
        deleteButton.design(title: "삭제하기", 
                            font: .pretendard(size: 16, weight: .semiBold),
                            backgroundColor: .null,
                            cornerRadius: 10)
    }
    
    private func setDeleteButtonDesign() {
        deleteButton.backgroundColor = selectedIndexes.count > 0 ? .main : .null
        deleteButton.isEnabled = selectedIndexes.count > 0 ? true : false
    }
    
    @objc private func removeAllCheckButtonClicked(sender: UIButton) {
        if imjangList.isEmpty {
            sender.isSelected = false
            sender.setImage(UIImage.ImjangList.off, for: .normal)
            return
        }
        sender.isSelected.toggle()
        if sender.isSelected == true {
            sender.setImage(UIImage.ImjangList.on, for: .normal)
            self.selectedIndexes = Set(0...imjangList.count - 1)
            collectionView.reloadData()
        } else {
            sender.setImage(UIImage.ImjangList.off, for: .normal)
            self.selectedIndexes.removeAll()
            collectionView.reloadData()
        }
    }
}

extension DeleteImjangViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imjangList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SelectNoteCell.self, for: indexPath)
        if selectedIndexes.contains(indexPath.row) {
            cell.isClicked = true
        } else {
            cell.isClicked = false
        }
        
        cell.isClicked = selectedIndexes.contains(indexPath.row)

        cell.configureCell(note: imjangList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                DeleteNoteHeader.self,
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            
            headerView.selectedCountLabel.text = "\(selectedIndexes.count)개 선택됨"   // 개수 변경 필요
            headerView.selectedCountLabel.textColor = selectedIndexes.count > 0 ? .main : .gray400
            
            headerView.removeAllCheckButton.setImage(selectedIndexes.count == imjangList.count && imjangList.count > 0 ? UIImage.ImjangList.on : UIImage.ImjangList.off, for: .normal)
            headerView.removeAllCheckButton.addTarget(self, action: #selector(removeAllCheckButtonClicked), for: .touchUpInside)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectNoteCell else {
            return
        }
        cell.isClicked.toggle()
        if cell.isClicked == true {
            selectedIndexes.insert(indexPath.row)
        } else {
            selectedIndexes.remove(indexPath.row)
        }
       
        collectionView.reloadData()
    }
}
