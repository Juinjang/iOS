//
//  CheckListNoteOpenView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/20/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class CheckListNoteOpenView: UICollectionReusableView {
    private let infoView = CheckListNoteOpenInfoView()
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontSize = 16
        $0.fontColor = .gray600
        $0.numberOfLines = 2
        $0.fontAlignment = .center
    }
    
    fileprivate let noteOpenButton = CheckListNoteOpenButton()
    
    static let tapRelay = PublishRelay<Void>()
    static let modelRelay = BehaviorRelay<ImjangDetailInfoModel?>(value: nil)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Self.modelRelay
            .subscribe(with: self) { owner, model in
                if let model = model {
                    owner.infoView.configure(for: model)
                    owner.contentLabel.text = "연필을 \(model.requiredPencils ?? 0)개를 사용하면\n모든 내용을 확인하고 소장할 수 있어요."
                    owner.noteOpenButton.configure(count: model.requiredPencils ?? 0)
                }
            }
            .disposed(by: disposeBag)
        
        noteOpenButton.rx.throttleTap
            .bind(to: Self.tapRelay)
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.white.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.6]
        gradientLayer.frame = self.bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureHierarchy() {
        add(infoView,
            contentLabel,
            noteOpenButton)
    }
    
    private func configureLayout() {
        infoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(87)
            $0.top.equalToSuperview().offset(141)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoView.snp.bottom).offset(32)
        }
        
        noteOpenButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(32)
            $0.height.equalTo(52)
            $0.width.equalTo(143)
            $0.centerX.equalToSuperview()
        }
    }
}

fileprivate final class CheckListNoteOpenInfoView: BaseView {
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.roundCorners(cornerRadius: 10, corner: .all)
    }
    
    private var itemViews: [CheckListNoteOpenInfoItemView] = []
    private let borderLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    func configure(for model: ImjangDetailInfoModel) {
        [("사진", model.imageCount, "장"),
         ("체크된 항목", model.checkedCount, "개"),
         ("상세 후기", model.reviewLength, "자")].enumerated().forEach { index, element in
            let view = CheckListNoteOpenInfoItemView()
            view.configure(title: element.0, countText: "\(element.1 ?? 0)\(element.2)")
            view.isHiddenDashedLine = (index == 2)
            stackView.addArrangedSubview(view)
            itemViews.append(view)
        }
    }
    
    override func configureView() {
        super.configureView()
        roundCorners(cornerRadius: 10, corner: .all)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(stackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        borderLayer.lineWidth = 2.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.mainGradient1.cgColor,
            UIColor.mainGradient2.cgColor
        ]
        gradientLayer.mask = borderLayer

        layer.addSublayer(gradientLayer)
    }
}

fileprivate final class CheckListNoteOpenInfoItemView: BaseView {
    private let titleLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .gray600
        $0.fontAlignment = .center
    }
    
    private let countLabel = DSLabel(.title).then {
        $0.fontSize = 20
        $0.fontColor = .main
        $0.fontAlignment = .center
    }
    
    private let dashedLineView = DashedLineView()
    
    var isHiddenDashedLine: Bool = false {
        didSet {
            dashedLineView.isHidden = isHiddenDashedLine
        }
    }
    
    func configure(title: String,
                   countText: String) {
        titleLabel.text = title
        countLabel.text = countText
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(titleLabel,
            countLabel,
            dashedLineView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
        
        dashedLineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview()
        }
    }
}


fileprivate final class CheckListNoteOpenButton: UIButton {
    private let textLabel = DSLabel(.title).then {
        $0.fontColor = .mainWhite
        $0.text = "노트 열기"
    }
    
    private let pencilIconView = UIImageView().then {
        $0.image = .pencil20
    }
    
    private let countLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .main
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(count: Int) {
        countLabel.text = "\(count)"
    }
    
    private func configureView() {
        backgroundColor = .gray500
        roundCorners(cornerRadius: 10, corner: .all)
    }
    
    private func configureHierarchy() {
        add(textLabel,
            pencilIconView,
            countLabel)
    }
    
    private func configureLayout() {
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        pencilIconView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.left.equalTo(textLabel.snp.right).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(pencilIconView.snp.right).offset(4)
        }
    }
}

fileprivate final class DashedLineView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedLine()
    }

    private func addDashedLine() {
        // 기존 레이어 제거 (중복 방지)
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.stroke.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 2.8] // [dash, gap] pattern

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: bounds.height)])
        shapeLayer.path = path

        layer.addSublayer(shapeLayer)
    }
}
