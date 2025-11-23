//
//  PencilShopTermsViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 7/23/25.
//

import UIKit
import RxSwift
import Then
import RxRelay

final class PencilShopTermsViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let mainView: PencilShopTermsView
    private let agreeRelay: PublishRelay<Void>
    
    init(termFileType: TermFileType,
         relay agreeRelay: PublishRelay<Void>,
         title: String,
         filledButtonTitle: String = "동의하고 화면 닫기") {
        self.agreeRelay = agreeRelay
        self.mainView = PencilShopTermsView(
            title: title,
            filledButtonTitle: filledButtonTitle,
            termFileType: termFileType
        )
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        mainView
            .agreeButton.rx
            .throttleTap
            .subscribe(with: self) { (self, _) in
                self.agreeRelay.accept(())
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView
            .closeButton.rx
            .throttleTap
            .subscribe(with: self) { (self, _) in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
