import Foundation

public struct NoteImageInfo {
    let imageId: Int
    let imageUrl: String
    
    public init(imageId: Int, imageUrl: String) {
        self.imageId = imageId
        self.imageUrl = imageUrl
    }
}
