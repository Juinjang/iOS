//
//  ImjangNote.swift
//  juinjang
//
//  Created by 조유진 on 1/24/24.
//

import Foundation

struct ImjangNote {
    let images: [String]?
    let roomName: String
    let price: String
    let score: Double?
    let location: String
    var isBookmarked: Bool
    var isSelected : Bool = false
//    let Date: String
}

enum ImjangList {
    static let list = [
        ImjangNote(images: ["1", "4", "3"], roomName: "판교푸르지오월드마크", price: "30억 1천만원", score: 4.6, location: "경기도 성남시 분당구 삼평동 741", isBookmarked: true),
        ImjangNote(images: ["3"], roomName: "happycat", price: "1억 3천만원", score: 4.7, location: "seoul 어쩌구", isBookmarked: false),
        ImjangNote(images: ["2","3"], roomName: "남양주 이편한세상", price: "3억 6천만원", score: 4.2, location: "경기도 남양주시 저쩌구", isBookmarked: true),
        ImjangNote(images: [], roomName: "강원도 땅끝마을", price: "12억 6천만원", score: 3.5, location: "강원도 속초시", isBookmarked: false),
        ImjangNote(images: ["2"], roomName: "와르르맨션", price: "3천만원", score: 4.6, location: "짱구네 마을", isBookmarked: true),
        ImjangNote(images: ["3"], roomName: "카카오 오피스텔", price: "100억 5천만원", score: 5.0, location: "경기도 성남시 분당구", isBookmarked: true),
        ImjangNote(images: [], roomName: "네이버 근처 주택", price: "21억 3천만원", score: 54.8, location: "경기도 성남시 분당구", isBookmarked: false),
        ImjangNote(images: ["3","2"], roomName: "반지하", price: "1백만원", score: 0.2, location: "서울시 동대문구", isBookmarked: false),
        ImjangNote(images: [], roomName: "cat집", price: "3만원", score: 4.6, location: "서울시 서대문구", isBookmarked: true),
        ImjangNote(images: ["1"], roomName: "개미집", price: "1천원", score: 0.7, location: "모래성", isBookmarked: false)
    ]
}
