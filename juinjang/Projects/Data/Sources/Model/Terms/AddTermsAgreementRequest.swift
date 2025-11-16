import Foundation
import Domain

public struct AddTermsAgreementRequest: Codable {
    let termsType: String // 연필 상점 : "PENCIL_SHOP_SERVICE"
    let isAgreed: Bool
    
    init(_ model: AddTermsAgreement) {
        termsType = model.termsType
        isAgreed = model.isAgreed
    }
}
