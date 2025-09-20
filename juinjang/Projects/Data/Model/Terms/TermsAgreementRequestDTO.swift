import Foundation

public struct TermsAgreementRequestDTO: Codable {
    let termsType: String // 연필 상점 : "PENCIL_SHOP_SERVICE"
    let isAgreed: Bool
}
