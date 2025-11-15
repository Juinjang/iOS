import Foundation

struct SharedNote {
    let sharedNoteId: Int
    let propertyType: String
    let priceType: String
    let buildingName: String
    let imageUrl: String?
    let isPurchase: Bool
    var isLiked: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String
    let ownerImageUrl: String?
    let ownerNickname: String
    let timeAge: String?
    let viewCount: Int
    
    public init(sharedNoteId: Int,
                propertyType: String,
                priceType: String,
                buildingName: String,
                imageUrl: String?,
                isPurchase: Bool,
                isLiked: Bool,
                rate: String?,
                price: String,
                monthlyRent: String?,
                pyong: Int?,
                floor: String?,
                address: String,
                ownerImageUrl: String?,
                ownerNickname: String,
                timeAge: String?,
                viewCount: Int) {
        self.sharedNoteId = sharedNoteId
        self.propertyType = propertyType
        self.priceType = priceType
        self.buildingName = buildingName
        self.imageUrl = imageUrl
        self.isPurchase = isPurchase
        self.isLiked = isLiked
        self.rate = rate
        self.price = price
        self.monthlyRent = monthlyRent
        self.pyong = pyong
        self.floor = floor
        self.address = address
        self.ownerImageUrl = ownerImageUrl
        self.ownerNickname = ownerNickname
        self.timeAge = timeAge
        self.viewCount = viewCount
    }
}
