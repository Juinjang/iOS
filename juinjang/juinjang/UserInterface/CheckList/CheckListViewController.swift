//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/20/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController {
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        $0.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        $0.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        $0.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        $0.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    var CategoryItems: [Category] = []
    
    var checklistManager: ChecklistManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
        // ChecklistManager 초기화
        checklistManager = ChecklistManager(categories: categories)
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
}

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return 1 + categories[section].items.count // 셀이 확장된 경우, 카테고리 셀과 확장된 항목들이 나타남
        } else {
            return 1 // 셀이 확장되지 않은 경우, 카테고리 셀만 나타남
        }
    }
    
    func

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
            
            cell.categoryImage.image = categories[indexPath.section].image
            cell.categoryLabel.text = categories[indexPath.section].name
            
            return cell
            
        } else {
            // 카테고리 셀 클릭 시 펼쳐질 셀
            let category = categories[indexPath.section]
            
            if let calendarItem = category.items[indexPath.row - 1] as? CalendarItem {
                // CalendarItem인 경우
                let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell
                cell.contentLabel.text = calendarItem.content
                cell.selectedDate = calendarItem.inputDate
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = calendarItem.isSelected ? UIColor(named: "lightOrange") : UIColor.white
                cell.selectedDate = selectedDates[indexPath.section]
                
                return cell
            } else if let scoreItem = category.items[indexPath.row - 1] as? ScoreItem {
                // ScoreItem인 경우
                let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                cell.contentLabel.text = scoreItem.content
                cell.score = scoreItem.score
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = scoreItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                            
                return cell
            } else if let inputItem = category.items[indexPath.row - 1] as? InputItem {
                // InputItem인 경우
                let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
                cell.contentLabel.text = inputItem.content
                cell.inputAnswer = inputItem.inputAnswer
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = inputItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                
                return cell
            } else if let selectionItem = category.items[indexPath.row - 1] as? SelectionItem {
                // SelectionItem인 경우
                let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
                cell.contentLabel.text = selectionItem.content
                cell.options = selectionItem.options
                cell.selectedOption = selectionItem.selectAnswer
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = selectionItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                
                return cell
            } 
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
            // 카테고리 셀을 눌렀을 때
            if indexPath.row == 0 {
                if categories[indexPath.section].isExpanded == true {
                    categories[indexPath.section].isExpanded = false
                    cell.expandButton.setImage(UIImage(named: "contraction-items"), for: .normal)
                } else {
                    categories[indexPath.section].isExpanded = true
                    cell.expandButton.setImage(UIImage(named: "expand-items"), for: .normal)
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedCalendarTableViewCell {
            // 확장된 캘린더 셀을 눌렀을 때
            if let selectedDate = cell.selectedDate {
                cell.backgroundColor = UIColor(named: "lightOrange")
            } else {
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedScoreTableViewCell {
            // 확장 점수 셀을 눌렀을 때
            if let selectedAnswer = cell.score {
                cell.backgroundColor = UIColor(named: "lightOrange")
            } else {
                // 버튼의 값이 없는 경우
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedTextFieldTableViewCell {
            // 확장 입력 셀을 눌렀을 때
            if let inputAnswer = cell.inputAnswer {
                cell.backgroundColor = UIColor(named: "lightOrange")
            } else {
                // 입력한 답변이 없는 경우
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedDropdownTableViewCell {
            // 확장 드롭다운 셀을 눌렀을 때
            if let selectedOption = cell.selectedOption {
                cell.backgroundColor = UIColor(named: "lightOrange")
            } else {
                // 선택한 옵션이 없는 경우
            }
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }

        let category = categories[indexPath.section]
        let selectedItem = category.items[indexPath.row - 1]

        switch selectedItem {
        case is CalendarItem:
            return 443
        case is ScoreItem, is InputItem:
            return 98
        case is SelectionItem:
            return 114
        default:
            return UITableView.automaticDimension
        }
    }

}

extension CheckListViewController: HelperDelegate {
    func heightChanged(index: Int, value: Bool) {
        categories[index].isExpanded = value
        tableView.performBatchUpdates(nil)
    }
}
