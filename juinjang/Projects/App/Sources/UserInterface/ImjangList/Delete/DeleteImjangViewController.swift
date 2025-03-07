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

final class DeleteImjangViewController: BaseViewController {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: 24)).then {
        $0.text = "삭제할 페이지를 선택해주세요"
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    
    let deleteImjangTableView = UITableView()
    let deleteButtonBackgroundView = UIView().then {
        $0.backgroundColor = .mainWhite
    }
    let deleteButton = UIButton()
    
    var selectedIndexes: Set<Int> = [] {
        didSet {
            setDeleteButtonDesign()
        }
    }
    
    var imjangList: [ListDto] = []
    weak var deleteImjangListDelegate: DeleteImjangListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        configureTableView()
        configureHierarchy()
        configureLayout()
        configureView()
        callRequest()
//        deleteImjangTableView.reloadData()
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc private  func deleteButtonClicked() {
        let deleteImjangPopupVC = DeleteImjangPopupViewController()
        guard let roomIndex = selectedIndexes.first else { return }
        deleteImjangPopupVC.selectedRoomName = imjangList[roomIndex].nickname
        deleteImjangPopupVC.selectedCount = selectedIndexes.count
        deleteImjangPopupVC.modalPresentationStyle = .overFullScreen
        
        deleteImjangPopupVC.completionHandler = { [weak self] in
            guard let self else { return }
            let indexs = self.selectedIndexes.sorted(by: <)
            print(indexs)
            var ids: [Int] = []
            for index in indexs {
                ids.append(self.imjangList[index].limjangId)
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
            self.callRequest()
        }
    }
    
    private func callRequest() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: Filter.update.sortValue)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let result = response.result else { return }
            self.imjangList = result.limjangList
            print(self.imjangList.count)
            self.deleteImjangTableView.reloadData()
        }
    }
    
    private func configureTableView() {
        deleteImjangTableView.delegate = self
        deleteImjangTableView.dataSource = self
        deleteImjangTableView.rowHeight = 116
        deleteImjangTableView.separatorStyle = .none
        deleteImjangTableView.showsVerticalScrollIndicator = false
        deleteImjangTableView.allowsMultipleSelection = true
        deleteImjangTableView.sectionHeaderTopPadding = 0
        deleteImjangTableView.register(DeleteImjangTableHeaderView.self, forHeaderFooterViewReuseIdentifier: DeleteImjangTableHeaderView.identifier)
        deleteImjangTableView.register(DeleteImjangNoteTableViewCell.self, forCellReuseIdentifier: DeleteImjangNoteTableViewCell.identifier)
    }
    
    // 네비게이션 바 디자인
    private func designNavigationBar() {
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black

        let backButtonItem = UIBarButtonItem(image: UIImage.arrowLeft, style: .plain, target: self, action: #selector(popView))
      
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(deleteImjangTableView)
        view.addSubview(deleteButtonBackgroundView)
        deleteButtonBackgroundView.addSubview(deleteButton)
    }
    
    private func configureLayout() {
        deleteImjangTableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
            deleteImjangTableView.reloadData()
        } else {
            sender.setImage(UIImage.ImjangList.off, for: .normal)
            self.selectedIndexes.removeAll()
            deleteImjangTableView.reloadData()
        }
    }
}

extension DeleteImjangViewController: UITableViewDelegate, UITableViewDataSource {
    // 헤더의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DeleteImjangTableHeaderView.identifier) as? DeleteImjangTableHeaderView else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.selectedCountLabel.text = "\(selectedIndexes.count)개 선택됨"   // 개수 변경 필요
        headerView.selectedCountLabel.textColor = selectedIndexes.count > 0 ? .main : .gray400
        
        headerView.removeAllCheckButton.setImage(selectedIndexes.count == imjangList.count && imjangList.count > 0 ? UIImage.ImjangList.on : UIImage.ImjangList.off, for: .normal)
        headerView.removeAllCheckButton.addTarget(self, action: #selector(removeAllCheckButtonClicked), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeleteImjangNoteTableViewCell.identifier, for: indexPath) as? DeleteImjangNoteTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
    
        if selectedIndexes.contains(indexPath.row) {
            cell.isClicked = true
        } else {
            cell.isClicked = false
        }
        
        cell.isClicked = selectedIndexes.contains(indexPath.row)

        cell.configureCell(imjangNote: imjangList[indexPath.row])
        cell.checkImageView.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DeleteImjangNoteTableViewCell else {
            return
        }
        cell.isClicked.toggle()
        if cell.isClicked == true {
            selectedIndexes.insert(indexPath.row)
        } else {
            selectedIndexes.remove(indexPath.row)
        }
        
        deleteImjangTableView.reloadData()
    }
}
