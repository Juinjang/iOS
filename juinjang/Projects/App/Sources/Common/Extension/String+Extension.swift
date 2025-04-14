//
//  String+Extension.swift
//  juinjang
//
//  Created by 조유진 on 2/11/24.
//

import Foundation
import UIKit
import CryptoKit

extension String {
    
    static func formatSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    func formatToKoreanCurrencyWithZero() -> String {
        guard let price = Int(self) else { return self }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        
        // 단위 배열
        let units = ["", "만", "억", "조", "경"]
        var formattedString = ""
        var value = price
        
        for (index, unit) in units.enumerated() {
            let rem = value % 10000
            if rem > 0 {
                let formattedRem = formatter.string(from: NSNumber(value: rem)) ?? "\(rem)"
                
                // 억 단위 이상인 경우에만 단위 표시
                if index >= 2 { // 2번째 인덱스는 "억" 단위
                    formattedString = formattedRem + unit + " " + formattedString
                } else {
                    // 억 미만인 경우에는 숫자만 붙임
                    formattedString = formattedRem + " " + formattedString
                }
            }
            value /= 10000
            if value == 0 {
                break
            }
        }
        
        return formattedString.trimmingCharacters(in: .whitespaces)
    }
    
    static func dateToString(target: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let isoDate = dateFormatter.date(from: target) else {
            return ""
        }
//        let myFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateString = dateFormatter.string(from: isoDate)
        return dateString
    }
    
    func twoSplitAmount() -> (String, String) {
        // 문자열을 숫자로 변환
        if let amount = Int(self) {
            let units = amount / 100000000
            let remainder = (amount % 100000000) / 10000

            // 나눈 결과를 문자열로 변환하여 반환
            return (String(units), String(remainder))
        } else {
            // 변환 실패 시 기본값 반환
            return ("0", "0")
        }
    }
    
    func oneSplitAmount() -> String {
        // 문자열을 숫자로 변환
        if let amount = Int(self) {
            let remainder = (amount % 100000000) / 10000

            // 문자열로 변환하여 반환
            return String(remainder)
        } else {
            // 변환 실패 시 기본값 반환
            return ("0")
        }
    }
    
    func addingCommas() -> String {
        // 숫자로 변환 가능한지 확인
        guard let number = Double(self) else {
            return self // 변환할 수 없으면 원래 문자열 반환
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 세 자리마다 콤마를 찍는 스타일
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정

        return formatter.string(from: NSNumber(value: number)) ?? self
    }
    
    // 텍스트 너비 계산
    func size(forFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes)
    }
    
    func width(forFont font: UIFont) -> CGFloat {
        return self.size(forFont: font).width
    }
    
    var hashedUUID: UUID {
        let hash = Insecure.MD5.hash(data: Data(self.utf8))
        let bytes = Array(hash.prefix(16))
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5],
            bytes[6], bytes[7],
            bytes[8], bytes[9],
            bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }
    
    var formattedKoreanCurrency: String {
        guard let value = Int(self) else { return self }
        
        let billion = value / 100_000_000
        let remainder = (value % 100_000_000) / 10_000
        
        switch (billion, remainder) {
        case (let b, let r) where b > 0 && r > 0:
            return "\(b)억 \(NumberFormatter.withComma.string(from: NSNumber(value: r)) ?? "\(r)")"
        case (let b, _) where b > 0:
            return "\(b)억"
        case (_, let r) where r > 0:
            return NumberFormatter.withComma.string(from: NSNumber(value: r)) ?? "\(r)"
        default:
            return "0"
        }
    }
}

private extension NumberFormatter {
    static let withComma: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
