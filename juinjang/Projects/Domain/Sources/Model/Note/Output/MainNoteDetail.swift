public struct MainNoteDetail {
    public let limjangId: Int
    public let checkListVersion: String // 버전 (임장용 체크리스트 - LIMJANG,  원룸용 체크리스트 - NON_LIMJANG)
    public let images: [String]
    public let purposeCode: Int    // 거래목적 (0 - 부동산 투자, 1 - 직접 거주)
    public let nickname: String
    public let priceType: Int
    public let priceList: [String] // 월세일 경우 보증금, 월세 순
    public let address: String?
    public let addressDetail: String?
    public let createdAt: String
    public let updatedAt: String
    
    public init(limjangId: Int,
                checkListVersion: String,
                images: [String],
                purposeCode: Int,
                nickname: String,
                priceType: Int,
                priceList: [String],
                address: String?,
                addressDetail: String?,
                createdAt: String,
                updatedAt: String) {
        self.limjangId = limjangId
        self.checkListVersion = checkListVersion
        self.images = images
        self.purposeCode = purposeCode
        self.nickname = nickname
        self.priceType = priceType
        self.priceList = priceList
        self.address = address
        self.addressDetail = addressDetail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
