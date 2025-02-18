//
//  NetworkConnectionErrorView.swift
//  juinjang
//
//  Created by 조유진 on 7/17/24.
//

import UIKit
import SnapKit

final class NetworkConnectionErrorView: UIView {
    let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let refreshButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(stackView)
        [imageView, titleLabel, descriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-14)
            make.centerX.equalToSuperview()
            make.size.equalTo(126)
        }
    }
    
    private func configureView() {
        self.backgroundColor = ColorStyle.textWhite.withAlphaComponent(0.98)
        imageView.image = ImageStyle.cloudOff
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.design(text: "앗! 오프라인 상태인 것 같아요", textColor: ColorStyle.textBlack, font: .pretendard(size: 18, weight: .semiBold), textAlignment: .center)
        descriptionLabel.design(text: "주인장을 이용하려면 인터넷 연결이 필요해요.\nWi-Fi 혹은 데이터 네트워크 연결 후\n아래의 새로고침 버튼을 눌러 보세요.", textColor: ColorStyle.textGray, font: .pretendard(size: 16, weight: .regular), textAlignment: .center, numberOfLines: 3)
        descriptionLabel.setLineSpacing(spacing: 10)
        descriptionLabel.textAlignment = .center
        
//        var config = UIButton.Configuration.filled()
//        config.title = "새로고침"
//        config.baseBackgroundColor = ColorStyle.textBlack
//        config.baseForegroundColor = ColorStyle.textWhite
//        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 54, bottom: 15, trailing: 54)
//        config.background.cornerRadius = 10
//        refreshButton.configuration = config
    }
}
