import Foundation

public struct ImjangDetailCheckListDTO: Codable {
    let checklistAnswers: [ImjangDetailCheckListModel]
    let review: String?
    let totalRate: Double?
}
