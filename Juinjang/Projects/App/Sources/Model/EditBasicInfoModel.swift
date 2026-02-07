//
//  EditBasicInfoModel.swift
//  App
//
//  Created by KimDongWoo on 9/9/25.
//

struct EditBasicInfoModel: Equatable {
    var postModel: PostCodeResponseModel?
    var address: String?
    var addressDetail: String?
    var pyung: String?
    var floor: String?
    var houseNickname: String?
    var priceType: Int?
    var threeDigitNumber: String?
    var fourDigitNumber: String?
    var monthlyRent: String?
    
    init(postModel: PostCodeResponseModel?,
         address: String?,
         addressDetail: String?,
         pyung: String?,
         floor: String?,
         houseNickname: String?,
         priceType: Int?,
         threeDigitNumber: String?,
         fourDigitNumber: String?,
         monthlyRent: String?) {
        self.postModel = postModel
        self.address = address
        self.addressDetail = addressDetail
        self.pyung = pyung
        self.floor = floor
        self.houseNickname = houseNickname
        self.priceType = priceType
        self.threeDigitNumber = threeDigitNumber ?? "0"
        self.fourDigitNumber = fourDigitNumber ?? "0"
        self.monthlyRent = monthlyRent ?? "0"
    }
    
    init(noteDetailModel: NoteDetailModel) {
        if let bcode = noteDetailModel.bcode,
           let address = noteDetailModel.roadAddress,
           let sido = noteDetailModel.sido,
           let sigungu = noteDetailModel.sigungu,
           let bname2 = noteDetailModel.bname2 {
            postModel = .init(
                bcode: bcode,
                address: address,
                sido: sido,
                sigungu: sigungu,
                bname1: noteDetailModel.bname1,
                bname2: bname2
            )
        } else {
            postModel = nil
        }
        
        address = noteDetailModel.roadAddress
        addressDetail = noteDetailModel.addressDetail
        pyung = "\(noteDetailModel.pyong ?? 0)"
        floor = noteDetailModel.floor
        houseNickname = noteDetailModel.buildingName
        priceType = convertPriceTypeToInt(noteDetailModel.priceType)
        let (three, four) = splitPrice(noteDetailModel.price)
        threeDigitNumber = three
        fourDigitNumber = four
        monthlyRent = convertToManwon(noteDetailModel.monthlyRent)
    }
}

extension EditBasicInfoModel {
    fileprivate func convertPriceTypeToInt(_ text: String?) -> Int? {
        switch text {
        case "SALE":
            return 0
        case "FULL_RENT":
            return 1
        case "MONTHLY_RENT":
            return 2
        default:
            return nil
        }
    }
    
    fileprivate func splitPrice(_ price: String?) -> (String, String) {
        guard let price = price, let priceInt = Int(price) else {
            return ("0", "0")
        }
        
        // price가 "만원" 단위로 들어옴
        let priceInManwon = priceInt / 10_000  // 원 → 만원 변환
        let three = priceInManwon / 10_000     // 억 단위
        let four  = priceInManwon % 10_000     // 나머지 만원 단위
        
        let threeString = "\(three)"
        let fourString  = four == 0 ? "0" : "\(four)"
        
        return (threeString, fourString)
    }
    
    fileprivate func convertToManwon(_ text: String?) -> String {
        guard let text = text, let value = Int(text) else { return "0" }
        let manwon = value / 10_000   // 원 → 만원
        return "\(manwon)"
    }
}
