import Foundation
import Domain

public struct SearchAreaCodeRequest: Encodable {
    let admCode: String?
    let format: String
    let numOfRows: Int?
    let pageNo: Int?
    var key: String
    
    public init(_ model: SearchAreaCode) {
        admCode = model.admCode
        format = model.format
        numOfRows = model.numOfRows
        pageNo = model.pageNo
        guard let admKey = Bundle.main.infoDictionary?["ADM_KEY"] as? String else {
            fatalError("ADM_KEY not found in Info.plist")
        }
        key = admKey
    }
}
