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
    }

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
            $0.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        tableView.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        tableView.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        tableView.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        tableView.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        tableView.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
}

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource  {
 
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return 1 + categories[section].items.count // section이 확장된 경우, 카테고리 셀과 확장된 항목들이 나타남
        } else {
            return 1 // section이 확장되지 않은 경우, 카테고리 셀만 나타남
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as? CategoryItemTableViewCell else { return UITableViewCell() }
            
            let category = categories[indexPath.section]
            cell.categoryImage.image = categories[indexPath.section].image
            cell.categoryLabel.text = categories[indexPath.section].name
            
            // section 확장 유무에 따라서 화살표 이미지 변경
            let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
            cell.expandButton.setImage(arrowImage, for: .normal)
            
            let itemcell = ExpandedDropdownTableViewCell()
            itemcell.itemPickerView.isUserInteractionEnabled = true
            
            return cell
            
        } else {
            // 카테고리 셀 클릭 시 펼쳐질 셀
            let category = categories[indexPath.section]
            
            if let calendarItem = category.items[indexPath.row - 1] as? CalendarItem {
                // CalendarItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as? ExpandedCalendarTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = calendarItem.content
                cell.selectedDate = calendarItem.inputDate
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = calendarItem.content
                let savedData = cell.calendarItems[contentKey] // 저장된 날짜를 가져오기
                cell.calendarItems[contentKey] = (inputDate: calendarItem.inputDate, isSelected: savedData?.isSelected ?? false)
                cell.backgroundColor = cell.calendarItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정
                cell.selectedDate = cell.loadSelectedDate() ?? Date()

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] selectedDate in
                    print("Selected Date in TableView:", selectedDate)
                    cell?.saveSelectedDate()
                }
                print("셀에서 가져온 데이터", cell.calendarItems)
                return cell
            } else if let scoreItem = category.items[indexPath.row - 1] as? ScoreItem {
                // ScoreItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as? ExpandedScoreTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = scoreItem.content
                cell.score = scoreItem.score
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = scoreItem.content
                let savedData = cell.scoreItems[contentKey]
                cell.scoreItems[contentKey] = (score: scoreItem.score, isSelected: savedData?.isSelected ?? false)
                cell.backgroundColor = cell.scoreItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 저장된 값이 없으면 기본값으로 설정
                cell.score = cell.loadSelectedScore() ?? String()

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] score in
                    print("Selected button in TableView:", score)
                    cell?.saveSelectedScore()
                }
//                print("셀에서 가져온 데이터", cell.scoreItems)
                return cell
            } else if let inputItem = category.items[indexPath.row - 1] as? InputItem {
                // InputItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as? ExpandedTextFieldTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = inputItem.content
                cell.inputAnswer = inputItem.inputAnswer
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = inputItem.content
                let savedData = cell.inputItems[contentKey]
                cell.inputItems[contentKey] = (inputAnswer: inputItem.inputAnswer, isSelected: savedData?.isSelected ?? false)
                cell.backgroundColor = cell.inputItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 저장된 값이 없으면 기본값으로 설정
                cell.inputAnswer = cell.loadInputAnswer() ?? String()

                // 셀이 선택된 경우 클로저 호출
                cell.inputHandler = { [weak self, weak cell] inputAnswer in
                    print("Inputed answer in TableView:", inputAnswer)
                    cell?.saveInputAnswer()
                }
                
                return cell
            } else if let selectionItem = category.items[indexPath.row - 1] as? SelectionItem {
                // SelectionItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as? ExpandedDropdownTableViewCell else { return UITableViewCell() }

                cell.contentLabel.text = selectionItem.content
                cell.options = selectionItem.options
                cell.selectedOption = selectionItem.selectAnswer
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = selectionItem.content
                let savedData = cell.selectionItems[contentKey]
                cell.selectionItems[contentKey] = (option: selectionItem.selectAnswer, isSelected: savedData?.isSelected ?? false)
                cell.backgroundColor = cell.selectionItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정
                cell.selectedOption = cell.loadSelectedOption() ?? String() // 저장된 값이 없으면 기본값으로 설정

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] selectedOption in
                    print("selected Option in TableView:", selectedOption)
                    cell?.saveSelectedOption()
                }
                return cell
            } 
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category = categories[indexPath.section]
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
            // 카테고리 셀을 눌렀을 때
            if indexPath.row == 0 {
                if categories[indexPath.section].isExpanded == true {
                    categories[indexPath.section].isExpanded = false
                    // 테이블 뷰 리로드
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    categories[indexPath.section].isExpanded = true
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedCalendarTableViewCell {
            // 확장된 캘린더 셀을 눌렀을 때
            if let selectedDate = cell.selectedDate, var item = category.items[indexPath.row - 1] as? CalendarItem {
                item.inputDate = selectedDate
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedScoreTableViewCell {
            // 확장 점수 셀을 눌렀을 때
            if let selectedAnswer = cell.score, var item = category.items[indexPath.row - 1] as? ScoreItem {
                item.score = selectedAnswer
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedTextFieldTableViewCell {
            // 확장 입력 셀을 눌렀을 때
            if let inputAnswer = cell.inputAnswer, var item = category.items[indexPath.row - 1] as? InputItem {
                item.inputAnswer = inputAnswer
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedDropdownTableViewCell {
            // 확장 드롭다운 셀을 눌렀을 때
            if let selectedOption = cell.selectedOption, var item = category.items[indexPath.row - 1] as? SelectionItem {
                item.selectAnswer = selectedOption
                item.isSelected = true
                category.items[indexPath.row - 1] = item
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
