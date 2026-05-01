import DesignSystem
import Model
import SwiftUI

struct ReasonOptionRow: View {
    let reason: AccountDeleteReason
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                DSText(reason.label)
                    .style(.body)
                    .textColor(isSelected ? .main : .gray450)

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(isSelected ? Color.main200 : Color.gray100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.main, lineWidth: isSelected ? 1.5 : 0)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
