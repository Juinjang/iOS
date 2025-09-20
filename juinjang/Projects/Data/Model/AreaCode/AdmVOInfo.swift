import Foundation

public struct AdmVOInfo: Decodable {
    let pageNo: String?
    let totalCount: String
    let error: String
    let message: String
    let numOfRows: String
    var admVOList: [AdmVO]
}
