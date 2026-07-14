//
//  MaintenanceNoticeView.swift
//  App
//
//  Created by 조유진 on 6/7/26.
//

import UIKit

final class MaintenanceNoticeView: BaseView {
    // MARK: - Subviews
    
    private let logoLabel = {
        let label = UILabel()
        label.text = "주인장"
        label.font = UIFont(name: "KCC-Ganpan", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView = {
        let imageView = UIImageView(image: .maintenance)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = {
        let label = DSLabel(.h1)
        label.text = "서비스 서버 점검 안내"
        label.fontColor = .gray600
        label.setLineHeight(32)
        return label
    }()
    
    private let descriptionLabel = {
        let label = DSLabel(.body2)
        label.text = "점검 기간 동안 전체 서비스 이용이 불가하니,\n양해 부탁드립니다 :)"
        label.fontColor = .gray400
        label.fontAlignment = .center
        label.setLineHeight(20)
        label.numberOfLines = 2
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .stroke
        return view
    }()
    
    private let startDateLabel = {
        let label = DSLabel(.h3)
        label.fontColor = .main
        label.fontAlignment = .center
        return label
    }()
    
    private let endDateLabel = {
        let label = DSLabel(.h3)
        label.fontColor = .main
        label.fontAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func addSubviews() {
        add(
            logoLabel,
            iconImageView,
            titleLabel,
            descriptionLabel,
            seperatorView,
            startDateLabel,
            endDateLabel
        )
    }
    
    private func setupLayout() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.horizontalEdges.equalToSuperview().inset(86)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconImageView.snp.top).offset(-78)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(26)
            make.height.equalTo(1)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
        
        endDateLabel.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(26)
        }
    }
    
    func configureDurationDate(
        startDate: Date,
        endDate: Date
    ) {
        startDateLabel.text = "시작: \(formatAsNoticeString(startDate))"
        startDateLabel.setLineHeight(24)
        
        endDateLabel.text = "종료: \(formatAsNoticeString(endDate))"
        endDateLabel.setLineHeight(24)
    }
}

private extension MaintenanceNoticeView {
    static let noticeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 a h시 mm분"
        return formatter
    }()
    
    func formatAsNoticeString(_ date: Date) -> String {
        Self.noticeDateFormatter.string(from: date)
    }
}
