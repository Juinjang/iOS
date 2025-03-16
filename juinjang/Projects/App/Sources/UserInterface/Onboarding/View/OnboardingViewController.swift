//
//  OnboardingViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit
import Lottie
import AmplitudeSwift
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    private let titleLabel = UILabel()      // 온보딩 텍스트
    private let animationView: LottieAnimationView
    private let animationView2: LottieAnimationView
    private let onboardingType: OnboardingType
    
    private let showLoginButtonRelay: BehaviorRelay<Bool> = .init(value: false)
    var isShowLoginButton: Driver<Bool> {
        showLoginButtonRelay.asDriver()
    }
    
    init(onboardingType: OnboardingType) {
        self.onboardingType = onboardingType
        animationView = LottieAnimationView(name: onboardingType.item1.jsonURLString)
        animationView2 = LottieAnimationView(name: onboardingType.item2.jsonURLString)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetAlpha()
        stopAllAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTitle(onboardingType.item1.title, keyword: onboardingType.item1.keyword)
        
        let titleAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.titleLabel.alpha = 1.0
        }
        
        defer { titleAnimator.startAnimation() }
        
        let animatorAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.animationView.alpha = 1.0
        }
        
        titleAnimator.addCompletion { _ in
            animatorAnimator.startAnimation()
        }
        
        // 3D 영상 재생 시작
        animatorAnimator.addCompletion { _ in
            self.animationView.play { _ in
                // 어플 예시 화면, 텍스트로 변경
                self.startItem2Animation()
                
                // 마지막 온보딩 화면인지 체크 후 로그인 버튼 보이기
                self.checkLastOnboarding()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllAnimation()
    }
    
    private func configureHierarchy() {
        [titleLabel, animationView, animationView2].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(64)
            make.top.equalToSuperview().offset(view.frame.height * 0.15)
        }
        
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.horizontalEdges.equalToSuperview().inset(64)
            make.height.equalTo(animationView.snp.width)
        }
        
        animationView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(animationView2.snp.width)
        }
    }
    
    private func configureView() {
        titleLabel.design(
            text: onboardingType.item1.title,
            textColor: .gray600,
            font: .pretendard(size: 24, weight: .bold),
            numberOfLines: 0
        )
        titleLabel.setLineSpacing(spacing: 10)
        titleLabel.textAlignment = .center
        titleLabel.asColor(targetString: onboardingType.item1.keyword, color: .main)
        
        [titleLabel, animationView, animationView2].forEach {
            $0.layer.shouldRasterize = true
            $0.layer.rasterizationScale = UIScreen.main.scale
        }
        
        animationView.backgroundColor = .systemGray6
        animationView.loopMode = .playOnce
        animationView2.loopMode = .playOnce
        
    }
    
}

// MARK: Animation Methods
extension OnboardingViewController {
    private func startItem2Animation() {
        let completeAnimation1 = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.resetAlpha()
            self.setTitle(self.onboardingType.item2.title, keyword: self.onboardingType.item2.keyword)
        }

        let animation2Animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.animationView2.play()
        }
        
        let viewAlphaAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.setAnimationUI(at: .item2, isHidden: false)
        }
        
        completeAnimation1.addCompletion { _ in
            animation2Animator.startAnimation()
        }
        
        animation2Animator.addCompletion { _ in
            viewAlphaAnimator.startAnimation()
        }
        
        completeAnimation1.startAnimation()
    }
    
    private func checkLastOnboarding() {
        showLoginButtonRelay.accept(onboardingType == .report)
    }
    
    private func setTitle(_ title: String, keyword: String) {
        titleLabel.text = title
        titleLabel.asColor(targetString: keyword, color: .main)
    }
    
    private func setAnimationUI(at type: AnimationType, isHidden: Bool, alpha: Double = 0.2) {
        titleLabel.alpha = isHidden ? alpha : 1
        setAnimation(at: type, isHidden: isHidden)
    }
    
    private func setAnimation(at type: AnimationType, isHidden: Bool) {
        switch type {
        case .item1:
            animationView.alpha = isHidden ? 0 : 1
            animationView2.alpha = !isHidden ? 0 : 1
        case .item2:
            animationView2.alpha = isHidden ? 0 : 1
            animationView.alpha = !isHidden ? 0 : 1
        }
    }
    
    private func resetAlpha() {
        self.titleLabel.alpha = 0.0
        self.animationView.alpha = 0.0
        self.animationView2.alpha = 0.0
    }
    
    private func stopAllAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            [animationView, animationView2].forEach {
                $0.alpha = 0.0
                if $0.isAnimationPlaying {
                    $0.stop()
                }
            }
        }
        
    }
}

private extension OnboardingViewController {
    enum AnimationType {
        case item1
        case item2
    }
}
