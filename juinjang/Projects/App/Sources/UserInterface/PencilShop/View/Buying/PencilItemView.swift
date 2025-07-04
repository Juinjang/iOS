//
//  PencilItemView.swift
//  juinjang
//
//  Created by 조유진 on 4/5/25.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import StoreKit

final class PencilItemView: UIView {
    private let pencilImageView = UIImageView().then {
        $0.design(image: .ImjangList.pencil, contentMode: .scaleAspectFit)
    }
    
    private let titleLabel = UILabel()
    private let priceButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .gray500
        config.baseForegroundColor = .mainWhite
        config.background.cornerRadius = 5
        
        $0.configuration = config
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    let priceTappedRelay = PublishRelay<Product>()
    private var disposeBag = DisposeBag()
    
    init(product: Product) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView(product: product)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        add(
            pencilImageView,
            titleLabel,
            priceButton,
            dividerView
        )
    }
    
    private func configureLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(pencilImageView.snp.trailing).offset(4)
            make.centerY.equalTo(pencilImageView)
            make.trailing.lessThanOrEqualTo(priceButton.snp.leading).offset(-24)
        }
        
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(79)
            make.height.equalTo(32)
        }
        
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func configureView(product: Product) {
        print(product)
        let productName = product.displayName.filter { $0.isNumber || $0 == "개" }
        titleLabel.setAttribute(text: "\(productName)", color: .gray600, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
 
        let priceString = formatNumber(productPrice(productId: product.id))
        let price = "₩\(priceString)"
        priceButton.configuration?.title = price
        priceButton.configuration?.attributedTitle = AttributedString(
            price,
            attributes: AttributeContainer([
                .font: UIFont.pretendard(size: 14, weight: .medium)
            ])
        )
        
        priceButton.rx.throttleTap
            .subscribe(with: self) { owner, _ in
                owner.priceTappedRelay.accept(product)
            }
            .disposed(by: disposeBag)
    }
    
    private func productPrice(productId: String) -> String {
        guard let infoDict = Bundle.main.infoDictionary,
              let products = infoDict["Products"] as? [String: String] else {
            return ""
        }
        return products[productId] ?? ""
    }
    
    private func formatNumber(_ numberString: String) -> String {
        if let number = Int(numberString) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        }
        return ""
    }
}

