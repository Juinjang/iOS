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
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image.profileImage
                    .resizable()
                    .scaledToFill()
            }
        } else {
            Image.profileImage
                .resizable()
                .scaledToFill()
        }
    }
}
