import Foundation

public struct SharedNoteSearchCompletedResult {
    let totalResults: Int
    let notes: [SharedNote]
    
    public init(totalResults: Int, notes: [SharedNote]) {
        self.totalResults = totalResults
        self.notes = notes
    }
}
