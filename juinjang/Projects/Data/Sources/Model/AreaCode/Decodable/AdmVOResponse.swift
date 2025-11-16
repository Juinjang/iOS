import Foundation
import Core
import Domain

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
