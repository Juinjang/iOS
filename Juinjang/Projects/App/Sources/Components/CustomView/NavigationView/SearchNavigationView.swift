//
//  SearchNavigationView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/4/25.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

final class SearchNavigationView: DefaultNavigationView {
    private let searchBar = UIView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 20
    }
    
    private let searchTextField = UITextField().then {
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.returnKeyType = .search
        $0.inputAccessoryView = UIView()
        $0.spellCheckingType = .no
    }
    
    private let searchToggleButton = UIButton()
    
    private let isSearchActiveRelay = BehaviorRelay<Bool>(value: false)

    var searchPlaceHolder: String? {
        didSet {
            self.searchTextField.placeholder = self.searchPlaceHolder ?? ""
        }
    }
    
    override func configureView() {
        super.configureView()
        
        self.isTitleHidden = true
        self.bind()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(searchBar.with(
            searchTextField,
            searchToggleButton
        ))
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        self.searchBar.snp.makeConstraints {
            $0.left.equalTo(self.leftItemStackView.snp.right).offset(4)
            $0.right.equalTo(self.snp.right).offset(-24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        self.searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(self.searchToggleButton.snp.left).offset(-16)
        }
        
        self.searchToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.height.width.equalTo(24)
        }
    }
    
    private func bind() {
        self.searchTextField.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: isSearchActiveRelay)
            .disposed(by: disposeBag)
        
        self.searchToggleButton.rx.throttleTap
            .withUnretained(self)
            .subscribe { (self, _) in
                if self.isSearchActiveRelay.value {
                    self.searchTextField.text = ""
                    self.isSearchActiveRelay.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        self.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .subscribe { (self, _) in
                if let keyword = self.searchTextField.text {
                    self.itemActionRelay.accept(.searchSummit(keyword: keyword))
                }
            }
            .disposed(by: disposeBag)
        
        self.isSearchActiveRelay
            .bind(to: self.searchToggleButton.rx.isSearchActive)
            .disposed(by: disposeBag)
        
        self.isSearchActiveRelay
            .withUnretained(self)
            .subscribe { (self, isActive) in
                self.itemActionRelay.accept(.searchActive(isActive: isActive))
            }
            .disposed(by: disposeBag)
    }
    
    func setSearchTextFieldBecomeResponder() {
        searchTextField.becomeFirstResponder()
    }
    
    func setSearchTextFieldText(_ text: String) {
        searchTextField.text = text
    }
}


fileprivate extension Reactive where Base: UIButton {
    var isSearchActive: Binder<Bool> {
        return Binder(self.base) { button, isActive in
            let image: UIImage = isActive ? .x24 : .ImjangList.search
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .gray400
        }
    }
}
