//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/20/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController {
    
    lazy var tableView = SelfSizingTableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
//        $0.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
//        $0.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
//        $0.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
//        $0.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    var imjangId: Int? {
        didSet {
            print("체크리스트 임장아디: \(imjangId)")
            responseQuestion()
        }
    }
    
    var categories: [CheckListResponseDto] = [] {
        didSet {
            print("받은 카테고리 개수 \(categories.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
    }
        
    @objc func didStoppedParentScroll() {
        DispatchQueue.main.async {
            self.tableView.isScrollEnabled = true
        }
    }
    
    // 키보드 내리기
    func hideKeyboardWhenTappedArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        // 테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
            // bottom 어떻게 주어야 할까?
            $0.bottom.equalToSuperview()
        }
    }
    
    // -MARK: API 요청
    func responseQuestion() {
        guard let imjangId = imjangId else {
            print("dddd")
            return }
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[CheckListResponseDto]>.self, api: .showChecklist(imjangId: imjangId)) { response, error in
            if error == nil {
                print(response)
                guard let checkListResponseDto = response?.result else { return }
                print("조회한 카테고리 개수 \(checkListResponseDto.count)")
                self.categories = checkListResponseDto
                self.tableView.reloadData()
//                NotificationCenter.default.post(name: NSNotification.Name("ReloadTableView"), object: nil)
//                self.setData(checkListResponseDto: checkListResponseDto)
            } else {
                guard let error = error else { return }
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
}

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == self.tableView {
                let offset = scrollView.contentOffset.y
                
                // 스크롤이 맨 위에 있을 때만 tableView의 스크롤을 비활성화
                if offset <= 0 {
                    tableView.isScrollEnabled = false
                    NotificationCenter.default.post(name: NSNotification.Name("didStoppedChildScroll"), object: nil)
                } else {
                    tableView.isScrollEnabled = true
                }
            }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return categories.count
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if categories[section].isExpanded {
//            return 1 + categories[section].items.count // 셀이 확장된 경우, 카테고리 셀과 확장된 항목들이 나타남
//        } else {
//            return 1 // 셀이 확장되지 않은 경우, 카테고리 셀만 나타남
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("몇개니\(categories.count)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as? CategoryItemTableViewCell else { return UITableViewCell() }
            
        cell.index = indexPath.row
        cell.category = categories[indexPath.row]
        cell.helperDelegate = self
        cell.configure(checkListResponseDto: categories[indexPath.row])
        return cell

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
//            // 카테고리 셀을 눌렀을 때
//            if indexPath.row == 0 {
//                if categories[indexPath.section].isExpanded == true {
//                    categories[indexPath.section].isExpanded = false
//                    cell.expandButton.setImage(UIImage(named: "contraction-items"), for: .normal)
//                } else {
//                    categories[indexPath.section].isExpanded = true
//                    cell.expandButton.setImage(UIImage(named: "expand-items"), for: .normal)
//                }
//                let section = IndexSet.init(integer: indexPath.section)
//                tableView.reloadSections(section, with: .fade)
//            }
//        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedCalendarTableViewCell {
//            // 확장된 캘린더 셀을 눌렀을 때
//            if let selectedDate = cell.selectedDate {
//                cell.backgroundColor = UIColor(named: "lightOrange")
//            } else {
//            }
//        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedScoreTableViewCell {
//            // 확장 점수 셀을 눌렀을 때
//            if let selectedAnswer = cell.score {
//                cell.backgroundColor = UIColor(named: "lightOrange")
//            } else {
//                // 버튼의 값이 없는 경우
//            }
//        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedTextFieldTableViewCell {
//            // 확장 입력 셀을 눌렀을 때
//            if let inputAnswer = cell.inputAnswer {
//                cell.backgroundColor = UIColor(named: "lightOrange")
//            } else {
//                // 입력한 답변이 없는 경우
//            }
//        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedDropdownTableViewCell {
//            // 확장 드롭다운 셀을 눌렀을 때
//            if let selectedOption = cell.selectedOption {
//                cell.backgroundColor = UIColor(named: "lightOrange")
//            } else {
//                // 선택한 옵션이 없는 경우
//            }
//        }
//
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }
        //
        //        let category = categories[indexPath.section]
        //        let selectedItem = category.items[indexPath.row - 1]
        //
        //        switch selectedItem {
        //        case is CalendarItem:
        //            return 443
        //        case is ScoreItem, is InputItem:
        //            return 98
        //        case is SelectionItem:
        //            return 114
        //        default:
                    return UITableView.automaticDimension
        //        }
        //    }
    }
}

extension CheckListViewController: HelperDelegate {
    func heightChanged(index: Int, value: Bool) {
        categories[index].isExpanded = value
        tableView.performBatchUpdates(nil)
    }
}
