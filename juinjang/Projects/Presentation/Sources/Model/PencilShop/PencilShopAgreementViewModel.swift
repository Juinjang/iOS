import Domain

public struct PencilShopAgreementViewModel {
    let status: Bool
    
    public init(_ model: PencilShopAgreement) {
        self.status = model.status
    }
}
