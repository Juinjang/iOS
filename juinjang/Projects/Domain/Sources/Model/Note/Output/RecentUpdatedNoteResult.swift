import Foundation

public struct RecentUpdatedNoteResult {
    public let recentUpdatedNoteList: [MainNote]
    
    public init(recentUpdatedList: [MainNote]) {
        self.recentUpdatedNoteList = recentUpdatedList
    }
}
