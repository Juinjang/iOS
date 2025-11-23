//
//  CountingTextView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/7/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxSwift

final class CountingTextView: BaseView {
    private lazy var textView: PlaceholderTextView = {
        return PlaceholderTextView(
            placeholder: placeholder,
            maxLength: maxLength
        )
    }()
    
    private let counterLabel = DSLabel(.reguler).then {
        $0.fontSize = 14
        $0.fontColor = .gray300
        $0.textAlignment = .right
    }
    
    private let maxLength: Int
    private let placeholder: String
    private let disposeBag = DisposeBag()
    
    init(maxLength: Int = 500,
         placeholder: String) {
        self.maxLength = maxLength
        self.placeholder = placeholder
        super.init(frame: .zero)
        counterLabel.text = "\(0)/\(maxLength)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(relay: PublishRelay<String>) {
        textView.configure(relay: relay)
        
        relay
            .map { [weak self] text in
                "\(text.count)/\(self?.maxLength ?? 500)"
            }
            .bind(to: counterLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .gray100
        roundCorners(cornerRadius: 10, corner: .all)
        layer.borderColor = UIColor.stroke.cgColor
        layer.borderWidth = 1
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(textView, counterLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.height.equalTo(200)
        }
        
        counterLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
