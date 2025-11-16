import Foundation
import Domain

public struct EditNoteRequest: Encodable {
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
    
    init(_ model: EditNote) {
        priceType = model.priceType
        price = model.monthlyRent
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
