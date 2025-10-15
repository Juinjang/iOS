import Foundation

public struct SearchAreaCode {
    public let admCode: String?
    public let format: String
    public let numOfRows: Int?
    public let pageNo: Int?
    
    init(admCode: String? = nil,
         format: String = "json",
         numOfRows: Int? = 1000,
         pageNo: Int = 1) {
        self.admCode = admCode
        self.format = format
        self.numOfRows = numOfRows
        self.pageNo = pageNo
    }
}
