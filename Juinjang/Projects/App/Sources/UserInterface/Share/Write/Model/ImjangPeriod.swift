//
//  ImjangPeriod.swift
//  juinjang
//
//  Created by KimDongWoo on 5/7/25.
//

import UIKit

enum ImjangPeriodType {
    case year(String)
    case month(String)
    case phase(String)
}

struct ImjangPeriod: Equatable {
    var year: String
    var month: String
    var phase: String
}

extension ImjangPeriod {
    static func from(date: Date = Date()) -> ImjangPeriod {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let year = String(components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = components.day ?? 1

        let phase: String
        switch day {
        case 1...10: phase = "초반"
        case 11...20: phase = "중반"
        default: phase = "후반"
        }

        return ImjangPeriod(year: year, month: month, phase: phase)
    }
}
