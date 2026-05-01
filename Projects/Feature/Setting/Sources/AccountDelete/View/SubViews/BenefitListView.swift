import DesignSystem
import SwiftUI

struct BenefitListView: View {
    private static let groups: [[String]] = [
        [
            "입력한 정보를 기반으로 계산된 점수 확인하기",
            "내 매물 정보 리포트로 한눈에 보기",
            "리포트 비교하고 공유하기"
        ],
        [
            "대화 녹음하고 매물별로 저장하기",
            "중요한 녹음파일 텍스트로 보기"
        ],
        [
            "내 매물 맞춤형 체크리스트 이용하기"
        ]
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(Self.groups.enumerated()), id: \.offset) { groupIndex, items in
                ForEach(items, id: \.self) { item in
                    benefitRow(text: item)
                        .padding(.bottom, 24)
                }

                if groupIndex < Self.groups.count - 1 {
                    DSDashedDivider()
                        .padding(.bottom, 24)
                }
            }
        }
    }

    private func benefitRow(text: String) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image.check
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.main)

            DSText(text)
                .style(.title)
                .textColor(.gray500)
        }
    }
}

