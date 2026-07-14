//
//  OnboardingPageView.swift
//  Onboarding
//
//  Created by 조유진 on 4/20/26.
//

import SwiftUI

import DesignSystem

// MARK: - OnboardingPageView

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isCurrentPage: Bool

    @State private var isOutroPhase = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                DSText(!isOutroPhase ? page.title1 : page.title2)
                    .style(.h1)
                    .textColor(.gray600)
                    .textAlignment(.center)
                    .highlightWords(
                        !isOutroPhase ? page.title1Highlight : page.title2Highlight,
                        style: DSText.HighlightStyle(color: .main, fontStyle: .h1)
                    )
                    .id(isOutroPhase)
                    .transition(.opacity)
            }
            .padding(.top, 50)
            .animation(.easeInOut(duration: 0.3), value: isOutroPhase)
            
            Spacer()
                .frame(height: 40)
            
            lottieView
            
            Spacer()
        }
        .onChange(of: isCurrentPage) { _, isCurrent in
            if isCurrent {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isOutroPhase = false
                }
            }
        }
    }

    @ViewBuilder
    private var lottieView: some View {
        if isOutroPhase {
            DSLottieView(name: page.outroLottieName, loopMode: .playOnce)
                .padding(.horizontal, 0)
                .frame(height: 360)
        } else {
            DSLottieView(name: page.introLottieName, loopMode: .playOnce) {
                guard isCurrentPage else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    isOutroPhase = true
                }
            }
            .id(isCurrentPage)
            .padding(.horizontal, 40)
            .frame(height: 280)
        }
    }
}
