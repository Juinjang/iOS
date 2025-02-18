//
//  DateFormatterManager.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    let dateFormatter = DateFormatter()
    
    private init() { }
    
    func convertEndTime(endTime: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let endTimeString = dateFormatter.string(from: endTime)
        return endTimeString
    }
    
    func formattedUpdatedDate(_ dateString: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let today = Date()
            
            let isToday = calendar.isDate(date, inSameDayAs: today)
            
            if isToday {
                // 오늘 날짜일 경우 "오후 4:00" 형식으로 변환
                let outputFormatter = getTodayFormatter()
                
                let formattedDateString = outputFormatter.string(from: date)
                return formattedDateString
            } else {
                // 오늘 날짜가 아닐 경우 "yyyy.MM.dd" 형식으로 변환
                let outputFormatter = getNotTodayFormatter()
                
                let formattedDateString = outputFormatter.string(from: date)
                return formattedDateString
            }
        } else {
            print("Invalid date string or date format")
        }
        return dateString
    }
    
    private func getTodayFormatter() -> DateFormatter {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h:mm"
        outputFormatter.amSymbol = "오전"
        outputFormatter.pmSymbol = "오후"
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale(identifier: "ko_KR")
        return outputFormatter
    }
    
    private func getNotTodayFormatter() -> DateFormatter {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter
    }
}
