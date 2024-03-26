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

class DeleteImjangViewController: UIViewController {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: 24)).then {
        $0.text = "삭제할 페이지를 선택해주세요"
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = ColorStyle.textGray
        $0.textAlignment = .center
    }
    
    let deleteImjangTableView = UITableView()
    let deleteButtonBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    let deleteButton = UIButton()
    
    var selectedIndexes: Set<Int> = [] {
        didSet {
            setDeleteButtonDesign()
        }
    }
    
    var imjangList: [ListDto] = []
    
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
    
    @objc func deleteButtonClicked() {
        let deleteImjangPopupVC = DeleteImjangPopupViewController()
        guard let roomIndex = selectedIndexes.first else { return }
        deleteImjangPopupVC.selectedRoomName = imjangList[roomIndex].nickname
        deleteImjangPopupVC.selectedCount = selectedIndexes.count
        deleteImjangPopupVC.modalPresentationStyle = .overFullScreen
        
        deleteImjangPopupVC.completionHandler = {
            let indexs = self.selectedIndexes.sorted(by: <)
            print(indexs)
            var ids: [Int] = []
            for index in indexs {
                ids.append(self.imjangList[index].limjangId)
            }
            print(ids)
            self.deleteRequest(imjangIds: ids)
        }
        present(deleteImjangPopupVC, animated: false)
    }
    
    func deleteRequest(imjangIds: [Int]) {
        print(#function, "\(imjangIds)")
        let parameter: [String: Any] = [
            "limjangIdList": imjangIds
        ]
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .deleteImjangs(imjangIds: imjangIds), parameter: parameter) { response, error in
            if error == nil {
                guard let response = response else { return }
                print(response)
                self.selectedIndexes.removeAll()
                self.view.makeToast("선택된 임장이 삭제되었습니다.", duration: 1.0)
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
    
    func callRequest() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: Filter.update.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
//                print(result)
                self.imjangList = result.limjangList
                print(self.imjangList.count)
                self.deleteImjangTableView.reloadData()
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
    
    func configureTableView() {
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
    func designNavigationBar() {
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black

        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
      
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(deleteImjangTableView)
        view.addSubview(deleteButtonBackgroundView)
        deleteButtonBackgroundView.addSubview(deleteButton)
    }
    
    func configureLayout() {
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
    
    func configureView() {
        view.backgroundColor = .white
        
        deleteButton.design(title: "삭제하기", 
                            font: .pretendard(size: 16, weight: .semiBold),
                            backgroundColor: ColorStyle.null,
                            cornerRadius: 10)
    }
    
    func setDeleteButtonDesign() {
        deleteButton.backgroundColor = selectedIndexes.count > 0 ? ColorStyle.mainOrange : ColorStyle.null
        deleteButton.isEnabled = selectedIndexes.count > 0 ? true : false
    }
    
    @objc func removeAllCheckButtonClicked(sender: UIButton) {
        if imjangList.isEmpty {
            sender.isSelected = false
            sender.setImage(ImageStyle.off, for: .normal)
            return
        }
        sender.isSelected.toggle()
        if sender.isSelected == true {
            sender.setImage(ImageStyle.on, for: .normal)
            self.selectedIndexes = Set(0...imjangList.count - 1)
            deleteImjangTableView.reloadData()
        } else {
            sender.setImage(ImageStyle.off, for: .normal)
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
        headerView.selectedCountLabel.textColor = selectedIndexes.count > 0 ? ColorStyle.mainOrange : ColorStyle.textGray
        
        headerView.removeAllCheckButton.setImage(selectedIndexes.count == imjangList.count && imjangList.count > 0 ? ImageStyle.on : ImageStyle.off, for: .normal)
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
