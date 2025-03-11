//
//  OnboardingContainerViewController.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class OnboardingContainerViewController: UIViewController, View {
    var disposeBag: DisposeBag = .init()
    
    private let goLoginButton: UIButton = {
        let button: UIButton = .init()
        var config = UIButton.Configuration.filled()
        config.title = "로그인 페이지로"
        config.titleAlignment = .center
        config.baseForegroundColor = .mainWhite
        config.baseBackgroundColor = .gray500
        config.background.cornerRadius = 10
 
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        config.attributedTitle = AttributedString("로그인 페이지로", attributes: container)
        
        button.configuration = config
        button.alpha = 0
        return button
    }()
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerList: [UIViewController] = []
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .main
        pageControl.pageIndicatorTintColor = .main100
        pageControl.backgroundColor = .clear
        
        pageControl.numberOfPages = OnboardingType.allCases.count
        return pageControl
    }()
    
    init(reactor: OnboardingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()
        configureDataSource()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func bind(reactor: OnboardingReactor) {
        pageViewController.rx.currentPageVC
            .withUnretained(self)
            .compactMap { owner, vc in owner.pageViewControllerList.firstIndex(of: vc)
            }
            .compactMap { OnboardingType(rawValue: $0) }
            .map { OnboardingReactor.Action.pageChanged($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        goLoginButton.rx.tap
            .map { OnboardingReactor.Action.loginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentPage }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoginButtonVisible }
            .distinctUntilChanged()
            .bind(with: self) { owner, isVisible in
                if isVisible {
                    owner.showLoginButton()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shouldNavigateToLogin }
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isNavigate in
                owner.changeLoginVC()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setViewControllers() {
        OnboardingType.allCases.forEach {
            let vc = OnboardingViewController(onboardingType: $0)
            pageViewControllerList.append(vc)
            
            if $0 == .report {
                vc.isShowLoginButton
                    .filter { $0 }
                    .drive(with: self) { owner, isShow in
                        print(#function, isShow)
                        owner.reactor?.action.onNext(.updateLoginButtonVisible(isShow))
                    }
                    .disposed(by: disposeBag)
            }
        }
    }
    
    private func configureDataSource() {
        pageViewController.dataSource = self
    }
    
    private func configureHierarchy() {
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        addChild(pageViewController)
    }
    
    private func configureLayout() {
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .mainWhite
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
    }
    
    private func showLoginButton() {
        view.addSubview(goLoginButton)
        goLoginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(52)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            self.goLoginButton.alpha = 1
        })
    }
}

// MARK: - UIPageViewControllerDataSource Method
extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    // 이전 화면에 대한 구성
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 1. 현재 페이지뷰컨에 보이는 뷰컨의 인덱스를 가지고 오기
        // 2. 그 인덱스의 -1 값인 뷰컨을 리턴
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    // 다음 화면에 대한 구성
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 1. 현재 페이지뷰컨에 보이는 뷰컨의 인덱스를 가지고 오기
        // 2. 그 인덱스의 +1 값인 뷰컨을 리턴
        guard let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first,
              let currentIndex = pageViewControllerList.firstIndex(of: viewController) else { return 0 }
        
        return currentIndex
    }
}

