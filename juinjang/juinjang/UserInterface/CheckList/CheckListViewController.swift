//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 2/19/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController {
    
    var calendarItems: [String: (inputDate: Date, isSelected: Bool)] = [:]
    var scoreItems: [String: (score: String, isSelected: Bool)] = [:]
    var inputItems: [String: (inputAnswer: String, isSelected: Bool)] = [:]
    var selectionItems: [String: (option: String, isSelected: Bool)] = [:]
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }

    var isEditMode: Bool = true // 수정 모드 여부
    
    var imjangId: Int? {
        didSet {
            print("체크리스트 \(imjangId)")
            responseQuestion { [weak self] updatedCategories in
                DispatchQueue.main.async {
                    self?.categories = updatedCategories
                    print("api 요청 후 카테고리 개수: \(self?.categories.count)")
                    self?.tableView.delegate = self
                    self?.tableView.dataSource = self
                    self?.tableView.reloadData()
                }
            }
        }
    }

    var categories: [CheckListResponseDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
        registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditModeChange(_:)), name: Notification.Name("EditModeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditButtonTappedNotification), name: NSNotification.Name("EditButtonTapped"), object: nil)
        
    }
    
    @objc func handleEditModeChange(_ notification: Notification) {
        if let userInfo = notification.userInfo, let isEditMode = userInfo["isEditMode"] as? Bool {
            tableView.reloadData()
            print("isEditMode 상태: \(isEditMode)")
            tableView.reloadData()
        }
    }
    
    @objc func handleEditButtonTappedNotification() {
        print("체크리스트 저장 좀 하고 싶다")
        saveAnswer()
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
    
    // -MARK: API 요청
    func responseQuestion(completion: @escaping ([CheckListResponseDto]) -> Void) {
        guard let imjangId = imjangId else { return }
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[CheckListResponseDto]>.self, api: .showChecklist(imjangId: imjangId)) { response, error in
            if error == nil {
                print(response)
                // 수정 모드가 아닌 경우 category가 0인 것은 필터링
                guard let checkListResponseDto = response?.result?.compactMap({
                    $0.filterCategoryZero(isEditMode: self.isEditMode)
                }) else {
                    return
                }
                
                print("조회한 카테고리 개수 \(checkListResponseDto.count)")
                completion(checkListResponseDto)
            } else {
                guard let error = error else { return }
                self.handleNetworkError(error)
            }
        }
    }
    
    func saveAnswer() {
        print("saveAnswer 함수 호출")
        guard let imjangId = imjangId else { return }
        var parameters: [[String: Any]] = []
        
        print("토큰값 \(UserDefaultManager.shared.accessToken)")
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[CheckListResponseDto]>.self, api: .showChecklist(imjangId: imjangId)) { response, error in
            guard let checkListResponse = response else {
                // 실패 시 에러 처리
                print("실패: \(error?.localizedDescription ?? "error")")
                return
            }

            // 달력
            for (key, value) in self.calendarItems {
                if let questionId = self.findQuestionId(forQuestion: key, in: checkListResponse) {
                    // Date를 String으로 변환
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let dateString = dateFormatter.string(from: value.inputDate)
                    
                    let parameter = ["questionId": questionId, "answer": dateString]
                    parameters.append(parameter)
                }
            }

            // 점수형
            for (key, value) in self.scoreItems {
                if let questionId = self.findQuestionId(forQuestion: key, in: checkListResponse) {
                    let parameter = ["questionId": questionId, "answer": value.score]
                    parameters.append(parameter)
                }
            }

            // 입력형
            for (key, value) in self.inputItems {
                if let questionId = self.findQuestionId(forQuestion: key, in: checkListResponse) {
                    let parameter = ["questionId": questionId, "answer": value.inputAnswer]
                    parameters.append(parameter)
                }
            }

            // 선택형
            for (key, value) in self.selectionItems {
                if let questionId = self.findQuestionId(forQuestion: key, in: checkListResponse) {
                    let parameter = ["questionId": questionId, "answer": value.option]
                    parameters.append(parameter)
                }
            }
            
            print(parameters)

            JuinjangAPIManager.shared.postCheckListItem(type: BaseResponse<ResultDto>.self, api: .saveChecklist(imjangId: imjangId), parameters: parameters) { response, error in
                if error == nil {
                    guard let response = response else { return }
                    print(response)
                } else {
                    guard let error = error else { return }
                    print(error)
                    print("API 응답 디코딩 실패: \(error.localizedDescription)")
                    self.handleNetworkError(error)
                }
            }
        }
    }
    
    func findQuestionId(forQuestion question: String, in checkListResponse: BaseResponse<[CheckListResponseDto]>) -> Int? {
        guard let result = checkListResponse.result else {
            return nil
        }
        
        for category in result {
            for questionDto in category.questionDtos {
                if questionDto.question == question {
                    return questionDto.questionId
                }
            }
        }
        return nil
    }
    
    func handleNetworkError(_ error: NetworkError) {
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

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
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
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isEditMode ? 0 : 1 // 수정 모드일 때 기한 카테고리 섹션은 없음
        } else {
            if categories[section - 1].isExpanded! {
                return 1 + categories[section - 1].questionDtos.count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("어디일까요 \(indexPath)")
        
        if isEditMode {
            if indexPath.row == 0 {
                let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
                
                let category = categories[indexPath.section - 1]
                cell.configure(checkListResponseDto: category)
                let arrowImage = category.isExpanded! ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                cell.expandButton.setImage(arrowImage, for: .normal)
                
                return cell
            }
            else {
                let category = categories[indexPath.section - 1]
                let questionDto = category.questionDtos[indexPath.row - 1]
                
                switch questionDto.answerType {
                case 0:
                    // ScoreItem
                    let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    cell.categories = categories
                    
                    // 데이터 모델에서 저장된 값으로 셀 구성
                    let contentKey = category.questionDtos[indexPath.row - 1].question
                    cell.backgroundColor = cell.scoreItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                    // 셀이 선택된 경우 클로저 호출
                    cell.selectionHandler = { [weak self, weak cell] score in
                        print("Selected button in TableView:", score)
                        self?.scoreItems.updateValue((score, true), forKey: contentKey)
                    }
                    cell.scoreItems = scoreItems
                    print("scoreItems 데이터", cell.scoreItems)

                    return cell
                case 1:
                    // SelectionItem
                    let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    cell.categories = categories
                    
                    // 데이터 모델에서 저장된 값으로 셀 구성
                    let contentKey = category.questionDtos[indexPath.row - 1].question
                    cell.backgroundColor = cell.selectionItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                    // 셀이 선택된 경우 클로저 호출
                    cell.selectionHandler = { [weak self, weak cell] selectedOption in
                        print("selected Option in TableView:", selectedOption)
                        self?.selectionItems.updateValue((selectedOption, true), forKey: contentKey)
                    }
                    cell.selectionItems = selectionItems
                    print("selectionItems 데이터", cell.selectionItems)
                    
                    return cell
                case 2:
                    // InputItem
                    let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    cell.categories = categories
                    
                    // 데이터 모델에서 저장된 값으로 셀 구성
                    let contentKey = category.questionDtos[indexPath.row - 1].question
                    cell.backgroundColor = cell.inputItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                    // 셀이 선택된 경우 클로저 호출
                    cell.inputHandler = { [weak self, weak cell] inputAnswer in
                        print("Inputed answer in TableView:", inputAnswer)
                        self?.inputItems.updateValue((inputAnswer, true), forKey: contentKey)
                    }
                    
                    cell.inputItems = inputItems
                    print("inputItems 데이터", cell.inputItems)
                    
                    return cell
                case 3:
                    // CalendarItem
                    let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    cell.categories = categories
                    
                    // 데이터 모델에서 저장된 값으로 셀 구성
                    let contentKey = category.questionDtos[indexPath.row - 1].question
                    cell.backgroundColor = cell.calendarItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                    // 셀이 선택된 경우 클로저 호출
                    cell.selectionHandler = { [weak self, weak cell] selectedDate in
                        print("Selected Date in TableView:", selectedDate)
                        self?.calendarItems.updateValue((selectedDate, true), forKey: contentKey)
                    }
                    
                    cell.calendarItems = calendarItems
                    print("calendarItems 데이터", calendarItems)
                    
                    return cell
                default:
                    fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                }
            }
        } else {
            if indexPath.section == 0 {
                // 기한 카테고리 섹션 셀 (NotEnteredCalendarTableViewCell)
                let cell: NotEnteredCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: NotEnteredCalendarTableViewCell.identifier, for: indexPath) as! NotEnteredCalendarTableViewCell
                return cell
            } else {
                // 나머지 섹션 셀
                if indexPath.row == 0 {
                    let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
                    
                    let category = categories[indexPath.section - 1]
                    cell.configure(checkListResponseDto: category)
                    
                    let arrowImage = category.isExpanded! ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                    cell.expandButton.setImage(arrowImage, for: .normal)
                    
                    return cell
                }
                else {
                    let category = categories[indexPath.section - 1]
                    let questionDto = category.questionDtos[indexPath.row - 1]
                    
                    switch questionDto.answerType {
                    case 0:
                        // ScoreItem
                        let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                        cell.configure(with: questionDto, at: indexPath)
                        // 보기 모드인 경우, 선택 상태에 따라 배경색 설정
                        cell.backgroundColor = UIColor(named: "gray0")
                        cell.contentLabel.textColor = UIColor(named: "lightGray")
                        for button in [cell.answerButton1, cell.answerButton2, cell.answerButton3, cell.answerButton4, cell.answerButton5] {
                            button.isEnabled = false
                            button.setImage(UIImage(named: "enabled-answer\(button.tag)"), for: .normal)
                        }
                        
                        return cell
                    case 1:
                        // SelectionItem
                        let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
                        cell.configure(with: questionDto, at: indexPath)
                        // 보기 모드인 경우, 선택 상태에 따라 배경색 설정
                                            cell.backgroundColor = UIColor(named: "gray0")
                                            cell.contentLabel.textColor = UIColor(named: "lightGray")
                                            cell.itemButton.isUserInteractionEnabled = false
                        return cell
                    case 2:
                        // InputItem
                        let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
                        cell.configure(with: questionDto, at: indexPath)
                        // 보기 모드인 경우, 선택 상태에 따라 배경색 설정
                                            cell.backgroundColor = UIColor(named: "gray0")
                                            cell.contentLabel.textColor = UIColor(named: "lightGray")
                                            cell.answerTextField.backgroundColor = UIColor(named: "shadowGray")
                                            cell.answerTextField.isEnabled = false
                        return cell
                    case 3:
                        // CalendarItem
                        let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell
                        cell.configure(with: questionDto, at: indexPath)
                        // 보기 모드인 경우, 선택 상태에 따라 배경색 설정
                        return cell
                    default:
                        fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
            // 카테고리 셀을 눌렀을 때
            if indexPath.row == 0 {
                if categories[indexPath.section - 1].isExpanded == true {
                    categories[indexPath.section - 1].isExpanded = false
                } else {
                    categories[indexPath.section - 1].isExpanded = true
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }
        
        let category = categories[indexPath.section - 1]
        let questionDto = category.questionDtos[indexPath.row - 1]
        
        switch questionDto.answerType {
        case 0, 2: // ScoreItem, InputItem
            return 98
        case 1: // SelectionItem
            return 114
        case 3: // CalendarItem
            return 480
        default:
            return UITableView.automaticDimension
        }
    }
}
