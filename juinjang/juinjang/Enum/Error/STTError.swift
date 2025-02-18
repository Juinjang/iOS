//
//  STTError.swift
//  juinjang
//
//  Created by 조유진 on 5/20/24.
//

import Foundation

enum STTError: Error, LocalizedError {
    case isNotAvailable
    case resultError
    
    var errorDescription: String? {
        switch self {
        case .isNotAvailable: return "음성 인식을 사용할 수 없습니다. \n권한을 확인해주세요"
        case .resultError: return "음성 인식 중 에러가 발생했습니다. 다시 시도해주세요"
        }
    }
}
