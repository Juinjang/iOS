import DesignSystem
import Model
import SwiftUI

struct TermsDocumentRowView: View {
    let document: TermsDocument
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image.documentText
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                DSText(document.title)
                    .style(.title)
                    .textColor(.gray500)

                Spacer()

                Image.arrowRight
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .frame(height: 64)
        }
        .buttonStyle(.plain)
    }
}
