//
//  NotEnteredCheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

import UIKit
import SnapKit

class NotEnteredCheckListViewController: UIViewController {
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    var imjangId: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
        registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
    }
    
    @objc
    func didStoppedParentScroll() {
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
            $0.height.equalTo(698)
//            $0.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        tableView.register(NotEnteredCalendarTableViewCell.self, forCellReuseIdentifier: NotEnteredCalendarTableViewCell.identifier)
        tableView.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        tableView.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        tableView.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        tableView.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        tableView.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    var selectedDates: [Date?] = Array(repeating: nil, count: 2)
}

extension NotEnteredCheckListViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //        + enabledCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // 기한 카테고리 섹션은 항상 1 반환
        } else {
            //            if enabledCategories[section - 1].isExpanded {
            //                return 1 + enabledCategories[section - 1].items.count
            //            } else {
            //                return 1
            //            }
        }
        //    }
        
        //        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            //            if indexPath.section == 0 {
        //            // 기한 카테고리 섹션의 셀 처리 (NotEnteredCalendarTableViewCell)
        //            let cell: NotEnteredCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: NotEnteredCalendarTableViewCell.identifier, for: indexPath) as! NotEnteredCalendarTableViewCell
        //            return cell
        //            } else {
        // 나머지 섹션의 셀 처리
        //                if indexPath.row == 0 {
        //                    let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
        
        //                let category = enabledCategories[indexPath.section - 1]
        //                cell.categoryImage.image = enabledCategories[indexPath.section - 1].image
        //                cell.categoryLabel.text = enabledCategories[indexPath.section - 1].name
        
        //                let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
        //                cell.expandButton.setImage(arrowImage, for: .normal)
        
        //                    return cell
        //                } else {
        //                let category = enabledCategories[indexPath.section - 1]
        //                let selectedItem = category.items[indexPath.row - 1]
        
        //                if let scoreItem = category.items[indexPath.row - 1] as? ScoreItem {
        // ScoreItem인 경우
        //                    let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
        //                    cell.contentLabel.text = scoreItem.content
        //                    cell.score = scoreItem.score
        //                    // 선택 상태에 따라 배경색 설정
        //                    cell.backgroundColor = UIColor(named: "gray0")
        //                    cell.contentLabel.textColor = UIColor(named: "lightGray")
        //                    for button in [cell.answerButton1, cell.answerButton2, cell.answerButton3, cell.answerButton4, cell.answerButton5] {
        //                        button.isEnabled = false
        //                        button.setImage(UIImage(named: "enabled-answer\(button.tag)"), for: .normal)
        //                    }
        ////                    cell.backgroundColor = scoreItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
        //
        //                    return cell
        //                } else if let inputItem = category.items[indexPath.row - 1] as? InputItem {
        // InputItem인 경우
        //                    let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
        //                    cell.contentLabel.text = inputItem.content
        //                    cell.inputAnswer = inputItem.inputAnswer
        // 선택 상태에 따라 배경색 설정
        //                    cell.backgroundColor = UIColor(named: "gray0")
        //                    cell.contentLabel.textColor = UIColor(named: "lightGray")
        //                    cell.answerTextField.backgroundColor = UIColor(named: "shadowGray")
        //                    cell.answerTextField.isEnabled = false
        ////                    cell.backgroundColor = inputItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
        //
        //                    return cell
        //                } else if let selectionItem = category.items[indexPath.row - 1] as? SelectionItem {
        //                    // SelectionItem인 경우
        //                    let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
        //                    cell.contentLabel.text = selectionItem.content
        //                    cell.options = selectionItem.options
        //                    cell.selectedOption = selectionItem.selectAnswer
        //                    // 선택 상태에 따라 배경색 설정
        //                    cell.backgroundColor = UIColor(named: "gray0")
        //                    cell.contentLabel.textColor = UIColor(named: "lightGray")
        //                    cell.itemButton.isUserInteractionEnabled = false
        ////                    cell.backgroundColor = selectionItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
        //
        //                    return cell
        //                }
        //        }
        //                        return UITableViewCell()
        //            }
        //    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
                // 카테고리 셀을 눌렀을 때
                //            if indexPath.row == 0 {
                //                if enabledCategories[indexPath.section - 1].isExpanded == true {
                //                    enabledCategories[indexPath.section - 1].isExpanded = false
                //                } else {
                //                    enabledCategories[indexPath.section - 1].isExpanded = true
                //                }
                //                let section = IndexSet.init(integer: indexPath.section)
                //                tableView.reloadSections(section, with: .fade)
                //            }
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard indexPath.row != 0 else {
                // 카테고리 셀의 높이
                return 63
            }
            
            //        let category = enabledCategories[indexPath.section - 1]
            //        let selectedItem = category.items[indexPath.row - 1]
            
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
        }
        //    }
        return 5
    }
}
