//
//  ExpandedCalendarTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit
import FSCalendar

class ExpandedCalendarTableViewCell: UITableViewCell {
    
    var selectedDate: Date?
    var monthPosition: FSCalendarMonthPosition?
    var question: CheckListItem?
    var imjangId: Int?
    
    override func prepareForReuse() {
        super.prepareForReuse()

        // 셀 내용 초기화
        selectedDate = nil

        // 달력 초기화
        calendar.deselect(calendar.selectedDate ?? Date())
        calendar.setCurrentPage(today, animated: false)

        // 테두리 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        for nonSelectedCell in nonSelectedCells {
            nonSelectedCell.layer.borderWidth = 0.0
        }

        // 배경색 초기화
        backgroundColor = .white
        questionImage.image = UIImage(named: "question-image")
    }
    
    // 선택된 날짜를 외부로 전달하는 콜백 클로저
    var selectionHandler: ((Date) -> Void)?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    // 달력
    lazy var calendar = FSCalendar()
    
    let today = Date()
    private var calendarCurrent: Calendar = Calendar.current
    private var currentPage: Date?
    private var dateComponents = DateComponents()
    
    lazy var moveToPreviousButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named: "move-to-previous-button"), for: .normal)
        $0.addTarget(self, action: #selector(moveToPrev(_:)), for: .touchUpInside)
    }
    
    lazy var moveToNextButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named: "move-to-next-button"), for: .normal)
        $0.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [questionImage, contentLabel, calendar].forEach { contentView.addSubview($0) }
        [moveToPreviousButton, moveToNextButton].forEach { calendar.addSubview($0)}
        setupLayout()
        calendarStyle()
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        // 질문 구분 imageView
        questionImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        // 질문 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(23)
        }
        
        // 달력
        calendar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.height.equalTo(356)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }
        
        // 달력 이전달 버튼
        moveToPreviousButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(107)
            $0.top.equalToSuperview().offset(24)
        }
        
        // 달력 다음달 버튼
        moveToNextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-107)
            $0.top.equalToSuperview().offset(24)
        }
    }
    
    func calendarStyle() {
        // 언어를 한국어로 변경
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 상단 헤더 뷰
        calendar.headerHeight = 66 // YYYY년 M월 표시부 영역 높이
        calendar.weekdayHeight = 41 // 날짜 표시부 행의 높이
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 좌, 우측 흐릿한 글씨 삭제
        calendar.appearance.headerDateFormat = "YYYY.MM" // 헤더 표시 형식
        calendar.appearance.headerTitleColor = .black // 헤더 색
        calendar.calendarWeekdayView.weekdayLabels.first?.textColor = UIColor(named: "mainOrange")
        
        
        // 날짜 부분
        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = .black // 요일 글씨 색
        calendar.appearance.selectionColor = .clear // 선택되었을 때 배경색
        calendar.appearance.titleSelectionColor = UIColor(named: "mainOrange") // 선택되었을 때 텍스트 색
        calendar.appearance.titleWeekendColor = .black // 주말 날짜 색
        calendar.appearance.titleDefaultColor = .black // 기본 날짜 색
        
        // 오늘 날짜
        calendar.appearance.titleTodayColor = .black // Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear // Today에 표시되는 선택 전 동그라미 색
        calendar.appearance.todaySelectionColor = .none  // Today에 표시되는 선택 후 동그라미 색
        
        // Month 폰트
        calendar.appearance.headerTitleFont = .pretendard(size: 18, weight: .bold)
        
        // day 폰트
        calendar.appearance.titleFont = .pretendard(size: 14, weight: .medium)
        
        // 테두리
        calendar.layer.cornerRadius = 9.97
    }
    
    // 달력 페이지 이동
    @objc func moveToNext(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: true)
        
        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        
        for nonSelectedCell in nonSelectedCells {
            nonSelectedCell.layer.borderWidth = 0.0
        }
        
        // 레이아웃 갱신
        layoutIfNeeded()
    }
    
    @objc func moveToPrev(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: false)
        
        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        
        for nonSelectedCell in nonSelectedCells {
            nonSelectedCell.layer.borderWidth = 0.0
        }
        
        // 레이아웃 갱신
        layoutIfNeeded()
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        dateComponents.month = moveUp ? 1 : -1
        currentPage = calendarCurrent.date(byAdding: dateComponents, to: currentPage ?? today)
        calendar.setCurrentPage(currentPage!, animated: true)
    }
    
    func configure(with questionDto: CheckListItem, with imjangId: Int, date: String, at indexPath: IndexPath) {
        self.question = questionDto
        self.imjangId = imjangId
        
        let content = questionDto.question
        contentLabel.text = content
        contentLabel.textColor = UIColor(named: "500")

        // 선택된 날짜가 있으면 표시
        if date != "" {
            // 저장된 날짜 문자열이 존재할 때만 실행
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            
            // 현재 indexPath에 해당하는 질문 데이터 가져오기
            let cellContent = questionDto.question
            
            if content == cellContent {
                // 날짜 포맷에 맞는 DateFormatter 생성
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd" // 저장된 날짜 문자열의 포맷에 맞게 설정
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC TimeZone 설정
                
                // 날짜 문자열을 Date로 변환
                if let date = dateFormatter.date(from: date) {
                    print("Date from stored date string:", date)
                    selectedDate = date
                    
                    // 변환된 날짜를 사용하여 셀 업데이트
                    if let position = monthPosition, let selectedCell = calendar.cell(for: date, at: position) {
                        selectedCell.layer.cornerRadius = 9.97
                        selectedCell.layer.borderWidth = 1.5
                        selectedCell.layer.borderColor = UIColor(named: "mainOrange")?.cgColor
                    } else {
                        selectedDate = nil
                    }
                } else {
                    // 날짜 포맷이 맞지 않는 경우
                    print("Invalid date format for stored date string:", date)
                    selectedDate = nil
                }
            } else {
                // content와 셀의 데이터가 일치하지 않는 경우
                print("Content does not match cell data.")
                selectedDate = nil
            }
        } else {
            // 저장된 날짜가 없는 경우
            print("No stored date for content:", content)
            selectedDate = nil
        }
    }
    
    func handleDateSelection(_ date: Date) {
        selectedDate = date
    }
}

extension ExpandedCalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.monthPosition = monthPosition
        backgroundColor = UIColor(named: "lightOrange")
        questionImage.image = UIImage(named: "question-selected-image")
        
        // 이미 선택된 날짜를 클릭하면 선택을 해제
        if let currentSelectedDate = selectedDate, currentSelectedDate == date {
            calendar.deselect(date)
            selectedDate = nil
            RealmManager.shared.deleteChecklistItem(imjangId: imjangId!, questionId: question!.questionId)
            
            // 선택 해제할 경우 테두리 제거
            if let selectedCell = calendar.cell(for: date, at: monthPosition) as? FSCalendarCell {
                selectedCell.layer.borderWidth = 0.0
                backgroundColor = .white
                questionImage.image = UIImage(named: "question-image")
            }
            return
        }
        
        // 현재 선택된 날짜의 테두리를 초기화
        if let currentSelectedDate = selectedDate, let currentSelectedCell = calendar.cell(for: currentSelectedDate, at: monthPosition) {
            currentSelectedCell.layer.borderWidth = 0.0
        }

        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }

        for nonSelectedCell in nonSelectedCells {
            nonSelectedCell.layer.borderWidth = 0.0
        }

        // 현재 달이 아닌 날짜의 테두리를 초기화
        if monthPosition != .current, let outOfMonthDateCell = calendar.cell(for: date, at: monthPosition) {
            outOfMonthDateCell.layer.borderWidth = 0.0
        }

        // 선택된 날짜의 테두리를 설정
        if let selectedCell = calendar.cell(for: date, at: monthPosition) {
            selectedCell.layer.cornerRadius = 9.97
            selectedCell.layer.borderWidth = 1.5
//            selectedCell.layer.fs_width = 49
//            selectedCell.layer.fs_height = 49
            selectedCell.layer.borderColor = UIColor(named: "mainOrange")?.cgColor
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        print("Selected Date: \(dateFormatter.string(from: date))")

        // 선택된 날짜의 시간 성분을 12:00 PM으로 설정 (UTC로 변환)
        if let selectedDateNoon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date)?.addingTimeInterval(TimeInterval(NSTimeZone.system.secondsFromGMT())) {
            print("Selected Date (after adjustment): \(selectedDateNoon)")
            
            // 현재 선택된 날짜 업데이트
            selectedDate = selectedDateNoon
            
            // 선택된 날짜를 해당 CalendarItem에 저장
            RealmManager.shared.saveChecklistItem(imjangId: imjangId!, questionId: question!.questionId, answer: dateFormatter.string(from: date), isSelected: true)
        }
        // 현재 선택된 날짜 업데이트
        selectedDate = date
        
        // delegate에게 선택된 날짜를 전달
//        delegate?.didSelectDate(date, inCell: self, at: indexPath)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        if dayOfWeek == 1 { // 일요일
            return .red
        } else {
            return nil // 다른 날짜의 경우 기본값으로 설정
        }
    }
}
