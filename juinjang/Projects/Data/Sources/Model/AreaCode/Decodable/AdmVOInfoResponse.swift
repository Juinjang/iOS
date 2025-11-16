import Foundation
import Core
import Domain

public struct AdmVOInfoResponse: Decodable, DomainMappable {
    let pageNo: String?
    let totalCount: String
    let error: String
    let message: String
    let numOfRows: String
    var admVOList: [AdmVOResponse]
    
    public func toDomain() -> AdmVOInfo {
        return AdmVOInfo.init(
            pageNo: pageNo,
            totalCount: totalCount,
            error: error,
            message: message,
            numOfRows: numOfRows,
            admVOList: admVOList.map { $0.toDomain() }
        )
    }
}
