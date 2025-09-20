import Foundation

public struct NoteUpdateRequestDTO: Encodable {
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
}
