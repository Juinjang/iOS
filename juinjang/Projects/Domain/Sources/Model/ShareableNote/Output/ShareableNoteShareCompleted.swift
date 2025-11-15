import Foundation

public struct ShareableNoteShareCompleted {
    let sharedNoteId: Int
    
    public init(sharedNoteId: Int) {
        self.sharedNoteId = sharedNoteId
    }
}
