//
//  CategoryItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import UIKit

class CategoryItemTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryItemTableViewCell"
    
    var itemCategory: [Category] = []
    
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
        
        [categoryImage,
         categoryLabel,
         expandButton].forEach { addSubview($0) }
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
            $0.height.height.equalTo(24)
        }
        
        expandButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(22)
        }
    }
}
