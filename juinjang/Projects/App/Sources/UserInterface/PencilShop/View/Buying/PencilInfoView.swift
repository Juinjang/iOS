//
//  PencilInfoView.swift
//  juinjang
//
//  Created by 조유진 on 4/4/25.
//

import UIKit
import SnapKit

enum PencilInfo: Int {
    case necessaryPencil
    case pencilYouHave
    case notEnoughPencil
    
    var title: String {
        switch self {
        case .necessaryPencil: return "필요한 연필"
        case .pencilYouHave: return "갖고 있는 연필"
        case .notEnoughPencil: return "부족한 연필"
        }
    }
}

final class PencilInfoView: UIStackView {
    
    private var infoList: [(PencilInfo, Int)]
    
    init(infoList: [(PencilInfo, Int)]) {
        self.infoList = infoList
        super.init(frame: .zero)
        configureView()
        setInfo()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        spacing = 0
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
    }
    
    private func setInfo() {
        for (info, value) in infoList {
            let vStackView = createVerticalStackView()
            let titleLabel = createTitleLabel(title: info.title)
            let valueLabel = createValueLabel(value: value, info: info)
            [titleLabel, valueLabel].forEach { vStackView.addArrangedSubview($0) }
            addArrangedSubview(vStackView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index, vStackView) in subviews.enumerated() {
            if infoList.count > 1 && index < infoList.count - 1 {
                addDashBorder(view: vStackView)
            }
        }
    }
    
    func setPencilShopMyPencilCount(pencilCount: Int) {
        guard subviews.count == 1,
              let vStackView = subviews.first else { return }

        let valueLabelIndex = 1

        guard vStackView.subviews.indices.contains(valueLabelIndex),
              let valueLabel = vStackView.subviews[valueLabelIndex] as? UILabel else { return }

        valueLabel.setAttribute(
            text: "\(pencilCount)",
            color: .gray600,
            font: .pretendard(size: 20, weight: .semiBold),
            lineHeight: 27,
            alignment: .center
        )
    }
    
    func setNoteEnterMyPencilCount(pencilCount: Int) {
        guard subviews.count == 3 else { return }
        let vStackView = subviews[1]
        
        let valueLabelIndex = 1

        guard vStackView.subviews.indices.contains(valueLabelIndex),
              let valueLabel = vStackView.subviews[valueLabelIndex] as? UILabel else { return }
        
        valueLabel.setAttribute(
            text: "\(pencilCount)",
            color: .gray600,
            font: .pretendard(size: 20, weight: .semiBold),
            lineHeight: 27,
            alignment: .center
        )
    }
    
    func setNeededPencilCount(neededPencilCount: Int) {
        guard subviews.count == 3 else { return }
        let vStackView = subviews[0]
        
        let valueLabelIndex = 1

        guard vStackView.subviews.indices.contains(valueLabelIndex),
              let valueLabel = vStackView.subviews[valueLabelIndex] as? UILabel else { return }
        
        valueLabel.setAttribute(
            text: "\(neededPencilCount)",
            color: .gray600,
            font: .pretendard(size: 20, weight: .semiBold),
            lineHeight: 27,
            alignment: .center
        )
    }
    
    func setNotEnoughPencilCount(notEnoughPencilCount: Int) {
        guard subviews.count == 3 else { return }
        let vStackView = subviews[2]
        
        let valueLabelIndex = 1

        guard vStackView.subviews.indices.contains(valueLabelIndex),
              let valueLabel = vStackView.subviews[valueLabelIndex] as? UILabel else { return }
        
        valueLabel.setAttribute(
            text: "\(notEnoughPencilCount)",
            color: .main,
            font: .pretendard(size: 20, weight: .semiBold),
            lineHeight: 27,
            alignment: .center
        )
    }
    
    func createVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }
    
    func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.setAttribute(
            text: title,
            color: .gray600,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            alignment: .center
        )
        return label
    }
    
    func createValueLabel(value: Int, info: PencilInfo) -> UILabel {
        let label = UILabel()
        let color: UIColor = info == .notEnoughPencil ? .main : .gray600
        label.setAttribute(
            text: "\(value)",
            color: color,
            font: .pretendard(size: 20, weight: .semiBold),
            lineHeight: 27,
            alignment: .center
        )
        return label
    }
    
    func addDashBorder(view: UIView) {
        let color = UIColor.stroke.cgColor

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2, 4]

        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        shapeLayer.path = path.cgPath

        shapeLayer.frame = view.bounds
        view.layer.addSublayer(shapeLayer)
    }
}
