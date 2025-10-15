import Foundation

public struct RecentUpdatedNoteResult {
    let recentUpdatedNoteList: [Note]
    
    public init(recentUpdatedList: [Note]) {
        self.recentUpdatedNoteList = recentUpdatedList
    }
}
