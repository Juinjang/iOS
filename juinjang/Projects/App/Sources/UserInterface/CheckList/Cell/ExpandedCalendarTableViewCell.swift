//
//  ExpandedCalendarTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit
import FSCalendar
import AmplitudeSwift

final class ExpandedCalendarTableViewCell: UITableViewCell {
    
    var dateSelectionHandler: ((String) -> Void)?
    var selectedDate: Date?
    var monthPosition: FSCalendarMonthPosition?
    
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
        backgroundColor = .mainWhite
        questionImage.image = UIImage.CheckList.questionDot
    }
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.CheckList.questionDot
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = .gray500
    }
    
    // 달력
    lazy var calendar = FSCalendar()
    
    let today = Date()
    private var calendarCurrent: Calendar = Calendar.current
    private var currentPage: Date?
    private var dateComponents = DateComponents()
    
    lazy var moveToPreviousButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage.CheckList.moveToPreviousButton, for: .normal)
        $0.addTarget(self, action: #selector(moveToPrev(_:)), for: .touchUpInside)
    }
    
    lazy var moveToNextButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage.CheckList.moveToNextButton, for: .normal)
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
        calendar.appearance.headerDateFormat = "yyyy.MM" // 헤더 표시 형식
        calendar.appearance.headerTitleColor = .black // 헤더 색
        calendar.calendarWeekdayView.weekdayLabels.first?.textColor = .main
        
        // 날짜 부분
        calendar.backgroundColor = .mainWhite // 배경색
        calendar.appearance.weekdayTextColor = .black // 요일 글씨 색
        calendar.appearance.selectionColor = .clear // 선택되었을 때 배경색
        calendar.appearance.titleSelectionColor = .main // 선택되었을 때 텍스트 색
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
    @objc private func moveToNext(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: true)
        
        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        
        for nonSelectedCell in nonSelectedCells {
            DispatchQueue.main.async {
                nonSelectedCell.layer.borderWidth = 0.0
            }
        }
        
        // 레이아웃 갱신
        layoutIfNeeded()
    }
    
    @objc private func moveToPrev(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: false)
        
        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        
        for nonSelectedCell in nonSelectedCells {
            DispatchQueue.main.async {
                nonSelectedCell.layer.borderWidth = 0.0
            }
        }
        
        // 레이아웃 갱신
        layoutIfNeeded()
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        dateComponents.month = moveUp ? 1 : -1
        currentPage = calendarCurrent.date(byAdding: dateComponents, to: ((currentPage ?? selectedDate) ?? today))
        calendar.setCurrentPage(currentPage!, animated: true)
        setborderStyle()
    }
      
    // 수정 모드
    func editModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = .gray500
        backgroundColor = .mainWhite
        
        selectedDate = nil
    }
    
    // 수정 모드일 때 저장된 값이 있는 경우
    func savedEditModeConfigure(with answer: String, at indexPath: IndexPath) {
        questionImage.image = UIImage.CheckList.questionSelected
        contentLabel.textColor = .gray500
        backgroundColor = .main150
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 저장된 날짜 문자열의 포맷에 맞게 설정
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // 날짜 문자열을 Date로 변환
        guard let date = dateFormatter.date(from: answer) else { return }
        
        selectedDate = date
        calendar.select(date)
        
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateCalendarCell(for: date)
            }
        }
    }
    
    func updateCalendarCell(for date: Date) {
        if let selectedCell = self.calendar.cell(for: date, at: .current) {
            selectedCell.layer.cornerRadius = 9.97
            selectedCell.layer.borderWidth = 1.5
            selectedCell.layer.borderColor = UIColor.main.cgColor
        } else {
            // .current에서 찾지 못한 경우 .notFound로 시도
            if let selectedCell = self.calendar.cell(for: date, at: .notFound) {
                selectedCell.layer.cornerRadius = 9.97
                selectedCell.layer.borderWidth = 1.5
                selectedCell.layer.borderColor = UIColor.main.cgColor
            } else {
                print("셀을 찾을 수 없습니다.")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setborderStyle()
    }
    
    private func setborderStyle() {
        if let selectedDate = self.selectedDate {
            let convertedDate = convertDate(date: selectedDate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateCalendarCell(for: convertedDate)
            }
        }
    }
    
    private func handleDateSelection(_ date: String) {
        dateSelectionHandler?(date)
    }
    
    private func convertDate(date: Date) -> Date {
        guard let convertedDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)?.addingTimeInterval(TimeInterval(NSTimeZone.system.secondsFromGMT()))
        else { return date }
        return convertedDate
    }
}

extension ExpandedCalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.monthPosition = monthPosition
        backgroundColor = .main150
        questionImage.image = UIImage.CheckList.questionSelected
        
        // 날짜 변환
        let date = convertDate(date: date)
        
        // 이미 선택된 날짜를 클릭하면 선택을 해제
        if let currentSelectedDate = selectedDate, currentSelectedDate == date {
            calendar.deselect(date)
            selectedDate = nil
            
            // 선택 해제할 경우 테두리 제거
            if let selectedCell = calendar.cell(for: date, at: monthPosition) {
                DispatchQueue.main.async {
                    selectedCell.layer.borderWidth = 0.0
                    self.backgroundColor = .mainWhite
                    self.questionImage.image = UIImage.CheckList.questionDot
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            handleDateSelection(dateFormatter.string(from: date))
            
            return
        }
        
        // 현재 선택된 날짜의 테두리를 초기화
        if let currentSelectedDate = selectedDate, let currentSelectedCell = calendar.cell(for: currentSelectedDate, at: monthPosition) {
            DispatchQueue.main.async {
                currentSelectedCell.layer.borderWidth = 0.0
            }
        }
        
        // 선택되지 않은 날짜의 테두리를 초기화
        let nonSelectedCells = calendar.visibleCells().compactMap { $0 as? FSCalendarCell }
        for nonSelectedCell in nonSelectedCells {
            DispatchQueue.main.async {
                nonSelectedCell.layer.borderWidth = 0.0
            }
        }
        
        // 현재 달이 아닌 날짜의 테두리를 초기화
        if monthPosition != .current, let outOfMonthDateCell = calendar.cell(for: date, at: monthPosition) {
            DispatchQueue.main.async {
                outOfMonthDateCell.layer.borderWidth = 0.0
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        print("Selected Date: \(dateFormatter.string(from: date))")
        
        // 선택된 날짜의 테두리를 설정
        if let selectedCell = calendar.cell(for: date, at: monthPosition) {
            DispatchQueue.main.async {
                selectedCell.layer.cornerRadius = 9.97
                selectedCell.layer.borderWidth = 1.5
//                selectedCell.layer.fs_width = 49
//                selectedCell.layer.fs_height = 49
                selectedCell.layer.borderColor = UIColor.main.cgColor
            }
            handleDateSelection(dateFormatter.string(from: date))
            selectedDate = date
        }
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
