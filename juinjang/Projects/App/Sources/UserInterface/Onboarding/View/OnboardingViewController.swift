//
//  OnboardingViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit
import AVFoundation
import Lottie
import AmplitudeSwift
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    private var titleLabel = UILabel()      // 온보딩 텍스트
    private lazy var animationView = LottieAnimationView(name: onboardingType.item1.jsonURLString)
    private var onboardingType: OnboardingType
    
    private let showLoginButtonRelay: BehaviorRelay<Bool> = .init(value: false)
    var isShowLoginButton: Driver<Bool> {
        showLoginButtonRelay.asDriver()
    }
    
    init(onboardingType: OnboardingType) {
        self.onboardingType = onboardingType
        print("OnboardingViewController Init")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTitle(onboardingType.item1.title, keyword: onboardingType.item1.keyword)
        animationView = LottieAnimationView(name: onboardingType.item1.jsonURLString)
        animationView.alpha = 0
        setAnimationViewLayout(isItem2: false)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            titleLabel.alpha = 1.0
        }) { _ in   // 타이틀 애니메이션 끝났을 때
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self else { return }
                animationView.alpha = 1.0
            }) { [weak self] _ in   // 영상뷰 애니메이션 끝났을 때
                guard let self else { return }
                // 3D 영상 재생 시작
                animationView.play { [weak self] (finish) in
                    guard let self else { return }
                    // 어플 예시 화면, 텍스트로 변경
                    startItem2Animation()
                    
                    // 마지막 온보딩 화면인지 체크 후 로그인 버튼 보이기
                    checkLastOnboarding()
                }
            }
        }
    }
    
    private func checkLastOnboarding() {
        showLoginButtonRelay.accept(onboardingType == .report)
    }
    
    private func startItem2Animation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            guard let self else { return }
            setUIHidden(true, hiddenAlpha: 0)
        })
        setTitle(onboardingType.item2.title, keyword: onboardingType.item2.keyword)
        self.animationView = LottieAnimationView(name: onboardingType.item2.jsonURLString)
        setAnimationViewLayout(isItem2: true)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            guard let self else { return }
            setUIHidden(false)
        }) { [weak self] _ in
            guard let self else { return }
            animationView.play()
        }
    
    }
    
    // MARK: viewDidDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUIHidden(true)
    }
    
    private func configureHierarchy() {
        [titleLabel, animationView].forEach {
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
    }
    
    private func setAnimationViewLayout(isItem2: Bool) {
        animationView.removeFromSuperview()
        view.addSubview(animationView)
        animationView.layer.shouldRasterize = true
        animationView.layer.rasterizationScale = UIScreen.main.scale
        
        if isItem2 {
            animationView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(22)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(animationView.snp.width)
            }
        } else {
            animationView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(54)
                make.horizontalEdges.equalToSuperview().inset(64)
                make.height.equalTo(animationView.snp.width)
            }
        }
        animationView.layoutIfNeeded()
    }
    
    private func configureView() {
        
        titleLabel.design(text: onboardingType.item1.title, font: .pretendard(size: 24, weight: .bold), numberOfLines: 0)
        titleLabel.setLineSpacing(spacing: 10)
        titleLabel.textAlignment = .center
        titleLabel.asColor(targetString: onboardingType.item1.keyword, color: .main)
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.rasterizationScale = UIScreen.main.scale
        
        animationView.backgroundColor = .systemGray6
        animationView.loopMode = .playOnce
        
        setUIHidden(true)
    }
    
    private func setTitle(_ title: String, keyword: String) {
        titleLabel.text = title
        titleLabel.asColor(targetString: keyword, color: .main)
    }
    
    private func setUIHidden(_ isHidden: Bool, hiddenAlpha: Double = 0.2) {
        titleLabel.alpha = isHidden ? hiddenAlpha : 1
        animationView.alpha = isHidden ? 0 : 1
    }
}
