//
//  SharedNoteDetailEvaluationReportResponse.swift
//  Data
//
//  Created by KimDongWoo on 10/12/25.
//
import Foundation
import CoreCommon
import DomainModel

public struct SharedNoteDetailEvaluationReportResponse: Codable, DomainMappable {
    let indoorKeyWord: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
    
    enum CodingKeys: String, CodingKey {
        case indoorKeyword = "indoorKeyWord"
        case publicSpaceKeyword = "publicSpaceKeyWord"
        case locationConditionsKeyword = "locationConditionsWord"
        case indoorRate
        case publicSpaceRate
        case locationConditionsRate
        case totalRate
    }
    
    public func toDomain() -> SharedNoteDetailEvaluationReport {
        return SharedNoteDetailEvaluationReport.init(
            indoorKeyWord: indoorKeyWord,
            publicSpaceKeyWord: publicSpaceKeyWord,
            locationConditionsWord: locationConditionsWord,
            indoorRate: indoorRate,
            publicSpaceRate: publicSpaceRate,
            locationConditionsRate: locationConditionsRate,
            totalRate: totalRate
        )
    }
}
