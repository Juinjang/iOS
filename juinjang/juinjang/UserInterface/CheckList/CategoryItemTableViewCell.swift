//
//  CategoryItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import UIKit

class CategoryItemTableViewCell: UITableViewCell {
    
    var itemCategory: [Category] = []
    var index = Int()
    var category: Category? = nil {
        didSet {
            if let _categories = category {
                innerTableView.isHidden = !_categories.isExpanded
                categoryLabel.text = _categories.name
                categoryImage.image = _categories.image
                innerTableView.dataSource = self
                innerTableView.delegate = self
                innerTableView.reloadData()
            }
        }
    }
    
    let innerTableView = UITableView().then {
        $0.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        $0.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        $0.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        $0.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
//        $0.estimatedRowHeight = 98.0
//        $0.rowHeight = UITableView.automaticDimension
    }
    
    var helperDelegate: HelperDelegate?
    var headerView = UIView()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(innerTableView)
        [categoryImage,
         categoryLabel,
         expandButton].forEach { headerView.addSubview($0) }
        setupLayout()
        addTapEvent()
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
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(63)
        }
        
        categoryImage.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.width.equalTo(18)
            $0.centerY.equalTo(headerView)
            $0.leading.equalTo(headerView).offset(24)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryImage.snp.trailing).offset(8)
            $0.centerY.equalTo(headerView)
            $0.height.equalTo(24)
        }
        
        expandButton.snp.makeConstraints {
            $0.trailing.equalTo(headerView).offset(-24)
            $0.centerY.equalTo(headerView)
            $0.height.equalTo(22)
            $0.width.equalTo(22)
        }
    }
    
    func addTapEvent() {
        let panGesture = UITapGestureRecognizer(target: self, action: #selector(handelerAction))
        headerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handelerAction() {
        guard let isExpanded = category?.isExpanded else {
            return
        }
        innerTableView.isHidden = isExpanded
        UIView.animate(withDuration: 0.3) {
            self.stackView.setNeedsLayout()
            self.helperDelegate?.heightChanged(index: self.index, value: !isExpanded)
        }
        category?.isExpanded = !isExpanded
    }
}

extension CategoryItemTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = category?.items[indexPath.row]
        if item is CalendarItem {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as? ExpandedCalendarTableViewCell else { return UITableViewCell() }
            
            cell.contentLabel.text = item?.content
            
            return cell
        } else if item is ScoreItem {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as? ExpandedScoreTableViewCell else { return UITableViewCell()}
            cell.contentLabel.text = item?.content
            
            return cell
        } else if item is InputItem {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as? ExpandedTextFieldTableViewCell else { return UITableViewCell() }
            cell.contentLabel.text = item?.content
            return cell
        } else if item is SelectionItem {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as? ExpandedDropdownTableViewCell else { return UITableViewCell() }
            cell.contentLabel.text = item?.content
            return cell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.invalidateIntrinsicContentSize()
//        tableView.layoutIfNeeded()
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = category?.items[indexPath.row]
        print("ddddd")
        if item is CalendarItem {
            print("dsfdsf")
            return 443
        } else if item is ScoreItem {
            print("score")
            return 98
        } else if item is InputItem {
            return 98
        } else if item is SelectionItem {
            return 114
        }
        return UITableView.automaticDimension
    }
}
