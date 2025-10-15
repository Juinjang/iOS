import Foundation
import CoreCommon
import DomainModel

public struct AdmVOResponse: Decodable, Hashable, DomainMappable {
    let admCode: String
    let lowestAdmCodeNm: String
    
    public func toDomain() -> AdmVO {
        return AdmVO.init(
            admCode: admCode,
            lowestAdmCodeNm: lowestAdmCodeNm
        )
    }
}
