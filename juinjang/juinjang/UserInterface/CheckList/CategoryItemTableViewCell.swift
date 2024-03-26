//
//  CategoryItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import UIKit

class CategoryItemTableViewCell: UITableViewCell {
    
    var categories: [Category]?
    var categoryItemList = CategoryItem.allCases
    
    let categoryImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "deadline-item")
    }
    
    let categoryLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .bold)
        $0.textColor = UIColor(named: "mainOrange")
    }
    
    let expandButton = UIButton().then {
        $0.setImage(UIImage(named: "expand-items"), for: .normal)
    }
    
    let expandedItemLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("CategoryItemTableViewCell initialized")
        
        [categoryImage, categoryLabel, expandButton].forEach { addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = UIColor(named: "lightBackgroundOrange")
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        categoryImage.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.width.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryImage.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        expandButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(22)
        }
    }
    
    func configure(checkListResponseDto: CheckListResponseDto) {
        let categoryId = checkListResponseDto.category
        categoryImage.image = categoryItemList[categoryId].image
        categoryLabel.text = categoryItemList[categoryId].title
    }
}

enum CategoryItem: Int, CaseIterable {
    case deadline           // 기한
    case locationConditions // 입지여건
    case commonSpace        // 공용공간
    case indoor             // 실내
    
    var title: String {
        switch self {
        case .deadline: return "기한"
        case .locationConditions: return "입지여건"
        case .commonSpace: return "공용공간"
        case .indoor: return "실내"
        }
    }
    
    var image: UIImage {
        switch self {
        case .deadline: return UIImage(named: "deadline-item")!
        case .locationConditions: return UIImage(named: "location-conditions-item")!
        case .commonSpace: return UIImage(named: "public-space-item")!
        case .indoor: return UIImage(named: "indoor-item")!
        }
    }
}
