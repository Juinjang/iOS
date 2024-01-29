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

    static let identifier = "ExpandedCalendarTableViewCell"
    
    var calendarItem: CalendarItem?
    
    var selectedDate: Date? {
        didSet {
            // 선택된 날짜가 변경될 때마다 호출되는 메서드
            saveSelectedDate()
        }
    }
    
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
    
    var calendarItems: [Item] = []  // 이 부분을 추가
    
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
        self.backgroundColor = .white
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
    
    private func saveSelectedDate() {
        // 선택된 날짜를 입력값으로 추가
    }
}


extension ExpandedCalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        backgroundColor = UIColor(named: "lightOrange")
        questionImage.image = UIImage(named: "question-selected-image")
        
        // 이미 선택된 날짜를 클릭하면 선택을 해제
        if let currentSelectedDate = selectedDate, currentSelectedDate == date {
            calendar.deselect(date)
            selectedDate = nil
            
            // 선택 해제할 경우 테두리 제거
            if let selectedCell = calendar.cell(for: date, at: monthPosition) as? FSCalendarCell {
                selectedCell.layer.borderWidth = 0.0
                backgroundColor = .white
                questionImage.image = UIImage(named: "question-image")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            print("Date deselected: \(dateFormatter.string(from: date))")
            
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
        
        
        // 선택된 날짜를 해당 CalendarItem에 저장
        calendarItem?.inputDate = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        print("Selected Date: \(dateFormatter.string(from: date))")
        // 현재 선택된 날짜 업데이트
        selectedDate = date
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
