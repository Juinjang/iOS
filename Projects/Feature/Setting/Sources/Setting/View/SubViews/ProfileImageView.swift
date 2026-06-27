import DesignSystem
import SwiftUI

struct ProfileImageView: View {
    let pickedImageData: Data?
    let imageURL: String?

    var body: some View {
        if let pickedImageData,
           let uiImage = UIImage(data: pickedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if let imageURL,
                  let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case let .success(image):
                    image.resizable().scaledToFill()
                case .empty, .failure:
                    Image.profileImage
                        .resizable()
                        .scaledToFill()
                @unknown default:
                    Image.profileImage
                        .resizable()
                        .scaledToFill()
                }
            }
        } else {
            Image.profileImage
                .resizable()
                .scaledToFill()
        }
    }
}
