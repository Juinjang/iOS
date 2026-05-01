import SwiftUI

public struct DSDashedDivider: View {
    private let color: Color
    private let lineWidth: CGFloat
    private let dash: [CGFloat]
    private let lineCap: CGLineCap

    public init(
        color: Color = .gray400,
        lineWidth: CGFloat = 2,
        dash: [CGFloat] = [2, 5],
        lineCap: CGLineCap = .round
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.dash = dash
        self.lineCap = lineCap
    }

    public var body: some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: lineWidth / 2))
                path.addLine(to: CGPoint(x: geo.size.width, y: lineWidth / 2))
            }
            .stroke(
                color,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, dash: dash)
            )
        }
        .frame(height: lineWidth)
    }
}

#Preview {
    VStack(spacing: 24) {
        DSDashedDivider()
        DSDashedDivider(lineWidth: 1.5, dash: [1, 4])
        DSDashedDivider(lineWidth: 2.5, dash: [1, 5])
        DSDashedDivider(color: .gray300, lineWidth: 1, dash: [3, 3], lineCap: .butt)
    }
    .padding(40)
}
