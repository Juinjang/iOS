//
//  PencilUsageGuideView.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay

final class PencilUsageGuideView: BaseView {
    private let headerView = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let titleLabel = UILabel().then {
        $0.setAttribute(text: "연필 이용안내", color: .gray450, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
    }
    
    private let arrowImageView = UIImageView().then {
        $0.design(image: .arrow16Down, contentMode: .scaleAspectFit)
    }
    
    private let dividorView = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    private let textView = UITextView().then {
        $0.text = "Lorem ipsum dolor sit amet consectetur. Sapien eget sagittis sit turpis malesuada nisi tincidunt sed arcu. Neque ultrices risus metus tellus accumsan rhoncus diam sollicitudin. Sed tincidunt viverra scelerisque diam. Morbi venenatis metus vivamus bibendum nunc non. Scelerisque sem id ac mattis nunc neque. Vitae mauris mollis sed suspendisse. Sed libero ultrices netus facilisis elementum enim quis. Pharetra morbi suscipit id pellentesque massa. Metus magna faucibus mattis metus urna nulla pellentesque. Tellus lectus id condimentum lacinia. Pretium sed purus integer tempor lacus. Aliquam placerat erat elementum massa sem purus morbi lorem praesent. Torrksktor eu mauris magna ullamcorper porttitor.\n Accumsan egestas magna dui ut rhoncus accumsan. Risus et risus nunc nunc neque augue dolor cursus diam. Quis mauris at morbi aliquam nec enim id tincidunt tempus. Pulvinar sed felis bibendum sit odio quis facilisis. Lorem enim sed aliquet diam eget turpis sem adipiscing nunc.\n Non blandit sed mattis pulvinar euismod id. Metus faucibus morbi id nisl tincidunt nam convallis. Egestas sollicitudin nec auctor tortor. Egestas sit vitae purus tincidunt etiam hac. Nam massa euismod in venenatis eu rhoncus etiam eu. Dolor massa parturient rutrum "
 
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 24, bottom: 52, right: 24)
        $0.backgroundColor = .gray200
        
        let font = UIFont.pretendard(size: 14, weight: .medium)
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 20
        style.minimumLineHeight = 20
        style.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .kern: -0.02,
            .font: font,
            .foregroundColor: UIColor.gray400
        ]
        
        $0.attributedText = NSAttributedString(AttributedString($0.text, attributes: AttributeContainer(attributes)))
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.isHidden = true
    }
    
    private var disposeBag = DisposeBag()
    private var heightConstraint: Constraint?
    
    private let expandedHeight: CGFloat = 566 // 펼쳤을 때 높이 (수정 가능)
    private let collapsedHeight: CGFloat = 52 // 접었을 때 기본 높이
    let guideTapRelay = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            headerView.with(
                titleLabel,
                arrowImageView,
                dividorView
            ),
            textView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(36)
        }
        
        dividorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            heightConstraint = make.height.equalTo(collapsedHeight).constraint
        }
    }
    
    override func configureView() {
        backgroundColor = .gray200
        
        let tapGesture = UITapGestureRecognizer()
        headerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                let isExpanded = !owner.textView.isHidden
                
                // 높이 변경
                owner.heightConstraint?.update(offset: isExpanded ? owner.collapsedHeight : owner.expandedHeight) // 예시: 펼쳤을 때 400
                
                owner.textView.isHidden.toggle()
                owner.arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
                self.layoutIfNeeded()
                owner.guideTapRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
}
