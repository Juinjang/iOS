//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 2/19/24.
//
// TODO: 지금 카테고리 별로 분류는 되는데 version이 분류가 안되어있음
import UIKit
import SnapKit
import Alamofire
import RealmSwift

class CheckListViewController: UIViewController  {
    
    var allCategory: [String] = []
    var checkListCategories: [CheckListCategory] = []
    
    var calendarItems: [String: (inputDate: String?, isSelected: Bool)] = [:]
    var scoreItems: [String: (score: String?, isSelected: Bool)] = [:]
    var inputItems: [String: (inputAnswer: String?, isSelected: Bool)] = [:]
    var selectionItems: [String: (option: String?, isSelected: Bool)] = [:]
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }

    var isEditMode: Bool = false // 수정 모드 여부
    var version: Int = 0
    var imjangId: Int? {
        didSet {
            print("체크리스트 \(imjangId)")
            filterVersionAndCategory(isEditMode: isEditMode, version: version) { [weak self] categories in
                self?.showCheckList()
                DispatchQueue.main.async {
                    print("카테고리 개수: \(self?.checkListCategories.count)")
                    print(self?.checkListCategories)
                    self?.tableView.delegate = self
                    self?.tableView.dataSource = self
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        addCheckListModel()
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
        if let isEditMode = notification.object as? Bool {
            print("isEditMode 상태: \(isEditMode)")
            self.isEditMode = isEditMode
            version = 1
            filterVersionAndCategory(isEditMode: isEditMode, version: version) { [weak self] result in
                self?.tableView.reloadData()
            }
        }
    }

    @objc func handleEditButtonTappedNotification() {
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
    
    // -MARK: DB 관리
    func addCheckListModel() {
        // Realm 데이터베이스에 데이터 추가
        do {
            let realm = try Realm()
            
            // CheckListItem가 존재하지 않을 때만 모델 추가
            if realm.objects(CheckListItem.self).isEmpty {
                try realm.write {
                    realm.add(items)
                    realm.add(oneRoomItems)
                    addOptionData()
                    print("CheckListItem DB 생성")
                }
            } else {
                print("CheckListItem 데이터베이스에 이미 데이터가 존재합니다.")
            }
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        } catch let error as NSError {
            print("DB 추가 실패: \(error.localizedDescription)")
            print("에러: \(error)")
        }
    }
    
    // -MARK: 버전 조회
    func filterVersionAndCategory(isEditMode: Bool, version: Int, completion: @escaping ([CheckListItem]) -> Void) {
        do {
            let realm = try Realm()
            var result = realm.objects(CheckListItem.self)
            
            print("체크리스트 버전: \(version)")
            result = result.filter("version == \(version)")
            
            let checkListItems = Array(result)
            
            var uniqueCategories = [String]()
            for item in checkListItems {
                if !allCategory.contains(item.category) {
                    allCategory.append(item.category)
                }
            }

            for category in allCategory {
                // 해당 카테고리에 해당하는 항목들을 필터링하여
                let categoryItems = checkListItems.filter { $0.category == category }
                // checkListCategories에 추가
                self.checkListCategories.append(CheckListCategory(category: category, checkListitem: categoryItems, isExpanded: false))
            }
            completion(checkListItems)
        } catch {
            print("Realm 데이터베이스 접근할 수 없음: \(error)")
            completion([])
        }
    }
    
    func showCheckList() {
        print("호출!")
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[CheckListResponseDto]>.self, api: .showChecklist(imjangId: imjangId)) { response, error in
            if error == nil {
                guard let response = response else { return }
                if let firstCheckList = response.result?.first,
                   let version = firstCheckList.questionDtos.first?.version {
                    self.version = version
                    print(version)
                }
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
    
    func saveAnswer() {
        print("saveAnswer 함수 호출")
        guard let imjangId = imjangId else { return }
        var checkListItems: [CheckListRequestDto] = []
        
        print("토큰값 \(UserDefaultManager.shared.accessToken)")
        
            // 달력
            for (key, value) in self.calendarItems {
                if let questionId = findQuestionId(forQuestion: key, in: checkListCategories) {
                    let parameter = CheckListRequestDto(questionId: questionId, answer: value.inputDate ?? "")
                    checkListItems.append(parameter)
                }
            }

            // 점수형
            for (key, value) in self.scoreItems {
                if let questionId = findQuestionId(forQuestion: key, in: checkListCategories) {
                    let parameter = CheckListRequestDto(questionId: questionId, answer: value.score ?? "")
                    checkListItems.append(parameter)
                }
            }

            // 입력형
            for (key, value) in self.inputItems {
                if let questionId = findQuestionId(forQuestion: key, in: checkListCategories) {
                    let parameter = CheckListRequestDto(questionId: questionId, answer: value.inputAnswer ?? "")
                    checkListItems.append(parameter)
                }
            }

            // 선택형
            for (key, value) in self.selectionItems {
                if let questionId = findQuestionId(forQuestion: key, in: checkListCategories) {
                    let parameter = CheckListRequestDto(questionId: questionId, answer: value.option ?? "")
                    checkListItems.append(parameter)
                }
            }
        
            print(checkListItems)
            
            let parameters: [[String: Any?]] = checkListItems.map {
                var answer: Any? = $0.answer
                if !(answer != nil) {
                    answer = answer
                }
                return ["questionId": $0.questionId, "answer": answer]
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON 데이터:")
                    print(jsonString)

                    let headers: HTTPHeaders = ["Content-Type": "application/json"]
                    let url = JuinjangAPI.saveChecklist(imjangId: imjangId).endpoint
                                
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.post.rawValue
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                                
                    AF.request(request)
                        .responseJSON { response in
                            print("체크리스트 저장 plz")
                            print(response)
                        }
                }
            } catch {
                print("encoding 에러: \(error)")
            }
    }
    
    func findQuestionId(forQuestion question: String, in checkListCategory: [CheckListCategory]) -> Int? {
        
        for category in checkListCategory {
            for item in category.checkListitem {
                if item.question == question {
                    return item.questionId
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
        return isEditMode ? allCategory.count + 1 : allCategory.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !isEditMode {
            return 1
        } else {
            let adjustedSection = isEditMode ? section - 1 : section
            if adjustedSection < 0 || adjustedSection >= checkListCategories.count {
                return 0
            }
            
            if checkListCategories[adjustedSection].isExpanded {
                return 1 + checkListCategories[adjustedSection].checkListitem.count
            } else {
                return 1
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEditMode {
            if indexPath.row == 0 {
                let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
                let items = self.checkListCategories[indexPath.section - 1]
                cell.configure(category: items)
                let arrowImage = items.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                cell.expandButton.setImage(arrowImage, for: .normal)
                
                return cell
            } else {
                let category = checkListCategories[indexPath.section - 1]
                let questionDto = category.checkListitem[indexPath.row - 1]
                
                switch questionDto.answerType {
                case 0:
                    // ScoreItem
                    let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                    cell.configure(with: questionDto, at: indexPath)

                    cell.scoreItems = scoreItems
                    for button in [cell.answerButton1, cell.answerButton2, cell.answerButton3, cell.answerButton4, cell.answerButton5] {
                        button.isEnabled = true
                        button.setImage(UIImage(named: "answer\(button.tag)"), for: .normal)
                    }
                    print("scoreItems 데이터", cell.scoreItems)

                    return cell
                case 1:
                    // SelectionItem
                    let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
                    cell.configure(with: questionDto, at: indexPath)

                    cell.selectionItems = selectionItems
                    cell.itemButton.isUserInteractionEnabled = true
                    print("selectionItems 데이터", cell.selectionItems)
                    
                    return cell
                case 2:
                    // InputItem
                    let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    

                    cell.inputItems = inputItems
                    cell.answerTextField.isEnabled = true
                    print("inputItems 데이터", cell.inputItems)
                    
                    return cell
                case 3:
                    // CalendarItem
                    let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell
                    cell.configure(with: questionDto, at: indexPath)
                    cell.calendarItems = calendarItems
                    let contentKey = category.checkListitem[indexPath.row - 1].question
                    cell.selectionHandler = { [weak self, weak cell] selectedDate in
                        print("Selected Date in TableView:", selectedDate)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyyMMdd"
                        print(dateFormatter.string(from: selectedDate))
                        
                        self?.calendarItems.updateValue((dateFormatter.string(from: selectedDate), true), forKey: contentKey)
                    }

                    
//                    cell.calendarItems = calendarItems
                    
                    print("calendarItems 데이터", calendarItems)
                    
                    return cell
                default:
                    fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                }
            }
        } else {
            if indexPath.section == 0 && !isEditMode {
                // 기한 카테고리 섹션 셀 (NotEnteredCalendarTableViewCell)
                let cell: NotEnteredCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: NotEnteredCalendarTableViewCell.identifier, for: indexPath) as! NotEnteredCalendarTableViewCell
                return cell
            } else {
                // 나머지 섹션 셀
                let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
                let category = checkListCategories[adjustedSection]
                
                if indexPath.row == 0 {
                    let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
    
                    cell.configure(category: category)

                    
                    let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                    cell.expandButton.setImage(arrowImage, for: .normal)
                    
                    return cell
                } else {
                    let questionDto = category.checkListitem[indexPath.row - 1]
                    
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
                    default:
                        fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
            checkListCategories[adjustedSection].isExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }
        
        let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
        guard adjustedSection >= 0 && adjustedSection < checkListCategories.count else {
            return UITableView.automaticDimension
        }
        
        let category = checkListCategories[adjustedSection]
        guard indexPath.row - 1 < category.checkListitem.count else {
            return UITableView.automaticDimension
        }
        
        let questionDto = category.checkListitem[indexPath.row - 1]
        
        switch questionDto.answerType {
        case 0, 2: // ScoreItem, InputItem
            return 98
        case 1: // SelectionItem
            return 114
        case 3: // CalendarItem
            return isEditMode ? 480 : 0
        default:
            return UITableView.automaticDimension
        }
    }

}
