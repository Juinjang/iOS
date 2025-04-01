//
//  LookAroundImjangCountCell.swift
//  juinjang
//
//  Created by 조유진 on 3/11/25.
//

import UIKit

final class LookAroundImjangCountCell: BaseCollectionViewCell {
    private let stackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }

    private let titleLabel = UILabel().then {
        let title = "임장노트"
        $0.setAttribute(text: title, color: .gray600, font: .pretendard(size: 18, weight: .bold), lineHeight: 24)
    }

    private let countLabel = UILabel()

    func configureCell(imjangCount: Int) {
        countLabel.setAttribute(text: "\(imjangCount)", color: .gray300, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
    }

    override func configureHierarchy() {
        [titleLabel, countLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        addSubview(stackView)
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
    }
}
