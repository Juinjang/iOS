import DesignSystem
import PhotosUI
import SwiftUI

struct ProfileEditPhotoPicker: View {
    @Binding var selection: PhotosPickerItem?
    let onPick: (PhotosPickerItem?) -> Void

    var body: some View {
        PhotosPicker(
            selection: $selection,
            matching: .images,
            photoLibrary: .shared()
        ) {
            DSText("수정")
                .style(.body2)
                .textColor(.main)
        }
        .onChange(of: selection) { _, newItem in
            onPick(newItem)
        }
    }
}
