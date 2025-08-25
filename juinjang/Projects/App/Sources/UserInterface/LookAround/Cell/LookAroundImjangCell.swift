//
//  LookAroundImjangCell.swift
//  juinjang
//
//  Created by 조유진 on 2/27/25.
//

import UIKit
import Then
import RxSwift
import RxRelay

final class LookAroundImjangCell: BaseCollectionViewCell {
    private let imjangImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .lightGray
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
    }
    private let scoreStackView = UIStackView().then {
        $0.backgroundColor = .gray450.withAlphaComponent(0.7)
        $0.spacing = 2
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    
    private let starImageView = UIImageView().then {
        $0.image = .ImjangList.starRounded.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .mainWhite
    }
    
    private let scoreLabel = UILabel()
    
    private let heartButton = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .ImjangList.heart
        $0.configuration = configuration
    }
    
    private let roomNameLabel = UILabel()
    
    private let purchasedLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)).then {
        $0.backgroundColor = .point.withAlphaComponent(0.1)
        $0.setAttribute(text: "소장", color: .point, font: .pretendard(size: 12, weight: .medium), lineHeight: 17, alignment: .center)
        $0.roundCorners(cornerRadius: 4, corner: .all)
        $0.isHidden = true
    }
    
    private let priceLabel = UILabel()
    
    private let roomDetailNameLabel = UILabel()
    
    private let roomAddressLabel = UILabel()
    
    private let profileStackView = UIStackView().then {
        $0.design(alignment: .center , distribution: .fill, spacing: 2)
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage.Setting.profile
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let ownerNicknameLabel = UILabel()
    
    private let uploadedDateLabel = UILabel()
    
    private let hitsStackView = UIStackView().then {
        $0.spacing = 2
        $0.alignment = .center
    }
    
    private let hitsImageView = UIImageView().then {
        $0.image = .ImjangList.eye
        $0.contentMode = .scaleAspectFit
    }
    
    private let hitsLabel = UILabel()
    
    private let infoStackView = UIStackView().then {
        $0.design(alignment: .fill, distribution: .fill, spacing: 0)
    }
    
    private let seperatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let cellButton = UIButton()
    
    private var disposeBag = DisposeBag()
    
    func configureCell(_ note: ExploreNoteModel, relay: PublishRelay<LookAroundEventType>) {
        setImjangImage(note.imageUrl, propertyType: note.propertyType)
        setScore(note.rate)
        setRoomName(note.buildingName)
        setIsPurchase(note.isPurchase)
        setPrice(note.price, priceType: note.priceType, monthlyRent: note.monthlyRent)
        setRoomDetail(pyong: note.pyong, floor: note.floor)
        setRoomAddress(note.address)
        setProfileImage(note.ownerImageUrl)
        setOwnerNickname(note.ownerNickname)
        setAgoDate(note.timeAge)
        setHits(note.viewCount)
        setIsLiked(note.isLiked)
        
        heartButton.rx.throttleTap
            .map { LookAroundEventType.heartButtonTap(sharedNoteId: note.sharedNoteId) }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        cellButton.rx.throttleTap
            .map { LookAroundEventType.noteTap(
                sharedNoteId: note.sharedNoteId,
                buildingName: note.buildingName
            )}
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imjangImageView.image = nil
        purchasedLabel.isHidden = true
    }
    
    override func configureHierarchy() {
        [starImageView, scoreLabel].forEach {
            scoreStackView.addArrangedSubview($0)
        }
        
        [profileImageView, ownerNicknameLabel].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        [profileStackView, createDivideCircleLabel() ,uploadedDateLabel, createDivideCircleLabel(), hitsStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        imjangImageView.addSubview(scoreStackView)
        imjangImageView.addSubview(heartButton)
        
        [hitsImageView, hitsLabel].forEach {
            hitsStackView.addArrangedSubview($0)
        }
        [cellButton, imjangImageView, roomNameLabel, purchasedLabel, priceLabel, roomDetailNameLabel, roomAddressLabel, infoStackView, seperatorView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        cellButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imjangImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalTo(seperatorView.snp.top).offset(-11)
            make.width.equalTo(144)
            make.height.equalTo(112)
        }
        
        scoreStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(imjangImageView)
            make.height.equalTo(19)
        }
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imjangImageView).inset(8)
            make.size.equalTo(20)
        }
        
        roomNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imjangImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(purchasedLabel.snp.leading).inset(4)
            make.top.equalTo(imjangImageView.snp.top)
        }
        
        purchasedLabel.snp.makeConstraints { make in
            make.leading.equalTo(roomNameLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
            make.centerY.equalTo(roomNameLabel)
        }
        roomNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        purchasedLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(imjangImageView.snp.trailing).offset(12)
            make.top.equalTo(roomNameLabel.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        roomDetailNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imjangImageView.snp.trailing).offset(12)
            make.top.equalTo(priceLabel.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        roomAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(imjangImageView.snp.trailing).offset(12)
            make.top.equalTo(roomDetailNameLabel.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(imjangImageView.snp.trailing).offset(12)
            make.top.equalTo(roomAddressLabel.snp.bottom).offset(2)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        hitsImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2
        }
    }
}

extension LookAroundImjangCell {
   
    private func createDivideCircleLabel() -> UILabel {
        let label = UILabel()
        label.setAttribute(text: "・", color: .gray300, font: .pretendard(size: 13, weight: .regular), lineHeight: 19, alignment: .center)
        label.frame = CGRect(x: 0, y: 0, width: 13, height: 19)
        return label
    }
}

extension LookAroundImjangCell {
    private func setScore(_ score: String?) {
        guard let score, let doubleScore = Double(score) else {
            scoreLabel.setAttribute(text: "0.0", color: .mainWhite, font: .pretendard(size: 13, weight: .semiBold), lineHeight: 19)
            return
        }
        
        let resultScore = String(format: "%.1f", doubleScore.truncateToSingleDecimal())
        scoreLabel.setAttribute(text: resultScore, color: .mainWhite, font: .pretendard(size: 13, weight: .semiBold), lineHeight: 19)
    }
    
    private func setImjangImage(_ imageUrl: String?, propertyType: String) {
        let property = PropertyType.allCases.filter { $0.rawValue == propertyType }
        if let propertyImage = property.first?.image {
            if let imageUrl {
                imjangImageView.setImage(with: imageUrl, placeholder: propertyImage, resizedTo: CGSize(width: 144, height: 112))
            } else {
                imjangImageView.image = propertyImage
            }
        }
    }
    
    private func setRoomName(_ roomName: String) {
        roomNameLabel.setAttribute(text: roomName, color: .gray600, font: .pretendard(size: 16, weight: .bold), lineHeight: 23)
    }
    
    private func setIsPurchase(_ isPurchase: Bool) {
        purchasedLabel.isHidden = !isPurchase
    }
    
    private func setPrice(_ priceString: String, priceType: String, monthlyRent: String?) {
        guard let priceType = PriceType(rawValue: priceType) else { return }
        
        var priceResult = ""
        
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            priceResult = "\(priceType.title) \(priceString.formatToKoreanCurrencyWithZero())"
        case .MONTHLY_RENT:
            priceResult = "\(priceType.title) \(priceString.formatToKoreanCurrencyWithZero()) / \(monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
        }
        
        priceLabel.setAttribute(
            text: priceResult,
            color: .gray450,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23
        )
    }
    
    private func setRoomDetail(pyong: Int?, floor: String?) {
        let roomDetail: String
        if pyong == nil || floor == nil {
            roomDetail = "평수와 층수가 입력되지 않음"
        } else {
            guard let pyong, let floor else { return }
            roomDetail = "\(pyong)평 \(floor)층"
        }
        roomDetailNameLabel.setAttribute(text: roomDetail, color: .gray400, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
    }
    
    private func setRoomAddress(_ address: String) {
        roomAddressLabel.setAttribute(text: address, color: .gray400, font: .pretendard(size: 13, weight: .medium), lineHeight: 19)
    }
    
    private func setProfileImage(_ imageUrl: String?) {
        if let imageUrl = URL(string: imageUrl ?? "") {
            DispatchQueue.main.async {
                self.profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage.Setting.profile)
            }
        } else {
            profileImageView.image = .Setting.profile
        }
    }
    
    private func setOwnerNickname(_ userName: String) {
        ownerNicknameLabel.setAttribute(text: userName, color: .gray400, font: .pretendard(size: 13, weight: .regular), lineHeight: 19)
    }
    
    private func setAgoDate(_ timeAge: String?) {
        uploadedDateLabel.setAttribute(text: timeAge ?? "", color: .gray400, font: .pretendard(size: 13, weight: .regular), lineHeight: 19)
    }
    
    private func setHits(_ hits: Int) {
        let hitsText = hits.viewCountString
        hitsLabel.setAttribute(text: hitsText, color: .gray400, font: .pretendard(size: 13, weight: .regular), lineHeight: 16)
    }
    
    private func setIsLiked(_ isLiked: Bool) {
        heartButton.configuration?.image = isLiked ? .ImjangList.heartFill : .ImjangList.heart
    }
}
