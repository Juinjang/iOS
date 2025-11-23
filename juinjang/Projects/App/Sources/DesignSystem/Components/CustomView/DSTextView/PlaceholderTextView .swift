//
//  PlaceholderTextView .swift
//  juinjang
//
//  Created by KimDongWoo on 5/7/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class PlaceholderTextView: BaseView {
    private let textView = UITextView().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .label
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.textContainerInset.top = 0
        $0.font = UIFont.pretendard(size: 14, weight: .medium)
        $0.textColor = .gray450
        $0.returnKeyType = .default
    }
    
    private let placeholderLabel = DSLabel(.body2).then {
        $0.fontColor = .gray300
        $0.numberOfLines = 5
    }
    
    private let maxLength: Int
    
    private let disposeBag = DisposeBag()

    init(placeholder: String,
         maxLength: Int = 500) {
        self.maxLength = maxLength
        super.init(frame: .zero)
        placeholderLabel.text = placeholder
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(relay: PublishRelay<String>) {
        textView.rx.text
            .orEmpty
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        textView.rx.text
            .orEmpty
            .map { [weak self] text in
                if text.count > self?.maxLength ?? 500 {
                    return String(text.prefix(self?.maxLength ?? 500))
                }
                return text
            }
            .do(onNext: { [weak self] text in
                guard let self = self,
                      text.count >= self.maxLength else { return }
                let bottom = NSMakeRange(text.count - 1, 1)
                self.textView.scrollRangeToVisible(bottom)
            })
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        
        textView.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(textView, placeholderLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.left.equalToSuperview().offset(-5)
            $0.right.bottom.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
    }
}
