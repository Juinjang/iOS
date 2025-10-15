import Foundation

struct NoteDetailResponse: Codable {
    let isShared: Bool
    let purposeType: String
    let propertyType: String
    let priceType: String
    let buildingName: String
    let images: [String]
    let roadAddress: String?
    let addressDetail: String?
    let price: String
    let monthlyRent: String?
    let updatedAt: String
    let floor: String?
    let pyong: Int?
    let bcode: String?
    let sido: String?
    let sigungu: String?
    let bname1: String?
    let bname2: String?
}
