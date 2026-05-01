import SwiftUI

// MARK: - DSPolicyTable
/// 약관/정책 본문 사이에 박히는 데이터 표.
/// (구 develop의 useImage1~4 PNG를 SwiftUI 네이티브로 대체)
///
/// - Setting의 약관 상세, Onboarding의 약관 동의 화면 등 **여러 feature가 공유**.
/// - 헤더 1행 + 데이터 N행 구조.
/// - 셀 배경: mainWhite, 보더: stroke (gray100 컨테이너 위에서도 선이 보이도록).
/// - 헤더는 Pretendard bold 14pt, 본문은 Pretendard medium 14pt — useImage 원본과 동일.
///
/// 사용 예:
/// ```
/// DSPolicyTable(
///     headers: ["법령", "수집 항목", "보유기간"],
///     rows: [["통신비밀보호법", "로그기록", "3개월"]]
/// )
/// ```

public struct DSPolicyTable: View {
    private let headers: [String]
    private let rows: [[String]]
    private let borderColor: Color
    private let cellBackground: Color
    private let cellPadding: EdgeInsets

    public init(
        headers: [String],
        rows: [[String]],
        borderColor: Color = .stroke,
        cellBackground: Color = .mainWhite,
        cellPadding: EdgeInsets = EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
    ) {
        self.headers = headers
        self.rows = rows
        self.borderColor = borderColor
        self.cellBackground = cellBackground
        self.cellPadding = cellPadding
    }

    public var body: some View {
        Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
            // Header row
            GridRow {
                ForEach(Array(headers.enumerated()), id: \.offset) { index, title in
                    tableCell(text: title, isHeader: true, isLastColumn: index == headers.count - 1)
                }
            }

            // Header → Body 사이 가로선
            rowDivider

            // Body rows
            ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                GridRow {
                    ForEach(Array(row.enumerated()), id: \.offset) { index, value in
                        tableCell(text: value, isHeader: false, isLastColumn: index == headers.count - 1)
                    }
                }
                if rowIndex < rows.count - 1 {
                    rowDivider
                }
            }
        }
        .background(cellBackground)
        .overlay(
            Rectangle()
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }

    // MARK: - 셀
    /// 텍스트 + (마지막 열이 아니면) 우측 1pt 세로선을 한 HStack 안에 같이 배치.
    /// 세로선이 셀의 자식이라 row 높이가 동기화되면 세로선도 동일 높이로 맞춰짐 → 가로선과 정확히 만남.

    @ViewBuilder
    private func tableCell(text: String, isHeader: Bool, isLastColumn: Bool) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(text)
                .font(font(isHeader: isHeader))
                .foregroundStyle(Color.gray500)
                .padding(cellPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if !isLastColumn {
                Rectangle()
                    .fill(borderColor)
                    .frame(width: 1)
            }
        }
    }

    // MARK: - 행 사이 가로 구분선

    @ViewBuilder
    private var rowDivider: some View {
        Rectangle()
            .fill(borderColor)
            .frame(height: 1)
            .gridCellColumns(max(1, headers.count))
            .gridCellUnsizedAxes(.horizontal)
    }

    // MARK: - 폰트
    /// 헤더 = Pretendard bold 14pt, 본문 = Pretendard medium 14pt

    private func font(isHeader: Bool) -> Font {
        let convertible: DesignSystemFontConvertible = isHeader
            ? DesignSystemFontFamily.Pretendard.bold
            : DesignSystemFontFamily.Pretendard.medium
        return convertible.swiftUIFont(size: 14)
    }
}

// MARK: - Previews

#Preview("법령 보존 표 (4열)") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            DSText("② 다른 법령에 따라 개인정보를 보관하는 경우")
                .style(.body)
                .textColor(.gray500)

            DSPolicyTable(
                headers: ["법령", "수집/이용 목적", "수집 항목", "보유/이용기간"],
                rows: [
                    ["통신비밀보호법", "통신사실 확인자료 제공", "로그기록, 접속지 정보 등", "3개월"],
                    ["전자상거래 등에서의 소비자 보호에 관한 법률", "표시/광고에 관한 기록", "표시/광고 기록", "6개월"],
                    ["", "소비자 불만 또는 분쟁 처리에 관한 기록", "소비자 식별정보, 분쟁처리 기록", "3년"]
                ]
            )
        }
        .padding(20)
    }
    .background(Color.gray100)
}

#Preview("추가 수집 항목 표 (2열)") {
    DSPolicyTable(
        headers: ["구분", "수집 이용 항목"],
        rows: [
            ["서비스 문의 상담 시", "이메일주소, 상담내용"],
            ["프로필 사진 지정 시", "프로필 사진"]
        ]
    )
    .padding(20)
    .background(Color.gray100)
}

#Preview("국외 위탁 현황 표 (4열)") {
    DSPolicyTable(
        headers: ["위탁사", "위탁하는 항목", "위탁 업무 내용", "위탁업체의 연락처 및 국가"],
        rows: [
            ["Amplitude, Inc.", "유저 식별자, 방문 일시 등", "이용자 서비스 이용 현황 데이터 분석", "privacy@amplitude.com/미국"],
            ["Google", "앱 방문 데이터", "구글 애널리틱스를 사용하여 데이터를 처리", "privacy@google.com/미국"]
        ]
    )
    .padding(20)
    .background(Color.gray100)
}
