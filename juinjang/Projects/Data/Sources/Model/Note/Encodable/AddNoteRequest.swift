import Foundation
import Domain

public struct AddNoteRequest: Encodable {
    let purposeType: String
    let propertyType: String
    let priceType: String
    let price: String
    let monthlyRent: String?
    let roadAddress: String
    let addressDetail: String?
    let bcode: String
    let nickname: String
    let floor: String
    let pyong: Int
    let sido: String?
    let sigungu: String?
    let bname1: String?
    let bname2: String?
    
    public init(_ model: AddNote) {
        purposeType = model.purposeType
        propertyType = model.propertyType
        priceType = model.priceType
        price = model.price
        monthlyRent = model.monthlyRent
        roadAddress = model.roadAddress
        addressDetail = model.addressDetail
        bcode = model.bcode
        nickname = model.nickname
        floor = model.floor
        pyong = model.pyong
        sido = model.sido
        sigungu = model.sigungu
        bname1 = model.bname1
        bname2 = model.bname2
    }
}
