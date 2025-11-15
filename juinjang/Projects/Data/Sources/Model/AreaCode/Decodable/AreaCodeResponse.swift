import Foundation
import CoreCommon
import DomainModel

public struct AreaCodeResponse: Decodable, DomainMappable {
    let admVOList: AdmVOInfoResponse
    
    public func toDomain() -> AreaCode {
        return AreaCode.init(admVOList: admVOList.toDomain() )
    }
}

