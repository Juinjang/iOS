//
//  PencilShopTermsView.swift
//  juinjang
//
//  Created by KimDongWoo on 7/23/25.
//

import UIKit
import Then
import SnapKit

final class PencilShopTermsView: BaseView {
    let closeButton = UIButton().then {
        $0.setImage(UIImage.close, for: .normal)
    }
    
    let navigationView = DefaultNavigationView()
    
    private let scrollView = UIScrollView().then {
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.backgroundColor = .gray100
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 0
    }
    
    let agreeButton: FilledButton
    
    init(title: String,
         filledButtonTitle: String,
         termFileType: TermFileType) {
        navigationView.title = title
        agreeButton = FilledButton(title: "동의하고 화면 닫기").then {
            $0.isActivated = true
        }
        super.init(frame: .zero)
        loadTerms(from: termFileType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(
            navigationView.with(closeButton),
            scrollView.with(contentView),
            agreeButton
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(46)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(agreeButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(16)
            $0.bottom.equalTo(scrollView.contentLayoutGuide).offset(-16)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            $0.width.equalTo(scrollView.frameLayoutGuide).inset(16)
        }
        
        agreeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    private func loadTerms(from fileType: TermFileType) {
        let filename = fileType.rawValue
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Terms 파일 URL을 찾을 수 없습니다: \(filename).json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Terms 데이터를 읽을 수 없습니다: \(filename).json")
            return
        }
        
        do {
            let terms = try JSONDecoder().decode([TermResponseModel].self, from: data)
            for item in terms {
                let label = UILabel()
                label.numberOfLines = 0
                label.attributedText = NSAttributedString(string: item.text, attributes: item.style.attributes)
                contentView.addArrangedSubview(label)
            }
        } catch {
            print("Terms JSON 디코딩 실패: \(error)")
        }
    }
}
