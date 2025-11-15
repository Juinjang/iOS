import Foundation

public struct AdmVOInfo {
    let pageNo: String?
    let totalCount: String
    let error: String
    let message: String
    let numOfRows: String
    var admVOList: [AdmVO]
    
    public init(pageNo: String?,
                totalCount: String,
                error: String,
                message: String,
                numOfRows: String,
                admVOList: [AdmVO]) {
        self.pageNo = pageNo
        self.totalCount = totalCount
        self.error = error
        self.message = message
        self.numOfRows = numOfRows
        self.admVOList = admVOList
    }
}
