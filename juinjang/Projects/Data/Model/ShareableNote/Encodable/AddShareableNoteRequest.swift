import Foundation
import DomainModel

public struct AddShareableNoteRequest: Encodable {
    let buildingName: String
    let isImageShared: Bool
    let year: Int
    let month: Int
    let period: String
    let review: String
    
    init(_ model: AddShareableNote) {
        buildingName = model.buildingName
        isImageShared = model.isImageShared
        year = model.year
        month = model.month
        period = model.period
        review = model.review
    }
}
