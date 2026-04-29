import DesignSystem
import SwiftUI

struct SettingMenuRow<Icon: View>: View {
    let title: String
    let titleColor: Color
    let action: () -> Void
    let icon: Icon

    init(
        title: String,
        titleColor: Color = .gray500,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.title = title
        self.titleColor = titleColor
        self.action = action
        self.icon = icon()
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon
                DSText(title)
                    .style(.title)
                    .textColor(titleColor)
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }
}

extension SettingMenuRow where Icon == EmptyView {
    init(
        title: String,
        titleColor: Color = .gray500,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            titleColor: titleColor,
            action: action,
            icon: { EmptyView() }
        )
    }
}
