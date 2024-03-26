//
//  RecordingFileItem.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import Foundation

struct RecordingFileItem {
    //let url: URL
    let name: String
    let recordedDate: Date
    var recordedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: recordedDate)
    }
    let recordedTime: String
    
}
