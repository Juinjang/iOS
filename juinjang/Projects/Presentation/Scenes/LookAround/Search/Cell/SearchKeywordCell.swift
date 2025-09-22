//
//  SearchKeywordCell.swift
//  juinjang
//
//  Created by 조유진 on 3/29/25.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

enum SearchKeywordCellEventType: Equatable {
    case deleteButtonTap(keyword: String)
}

extension SearchKeywordCellEventType {
    var deleteTapKeyword: String? {
        if case let .deleteButtonTap(keyword) = self {
            return keyword
        }
        return nil
    }
}

final class RecentSearchKeywordCell: BaseCollectionViewCell {
    private let clockIcon = UIImageView().then {
        $0.design(image: UIImage.ImjangList.clock, contentMode: .scaleAspectFit)
    }
    private let searchKeywordLabel = UILabel().then {
        $0.setAttribute(text: "", font: .pretendard(size: 16, weight: .medium), lineHeight: 23)
    }
    let deleteButton = UIButton().then {
        $0.design(image: UIImage.X, backgroundColor: .mainWhite)
    }
    
    var disposeBag = DisposeBag()
    
    func configureCell(keyword: String, relay: PublishRelay<SearchKeywordCellEventType>) {
        searchKeywordLabel.setAttribute(text: keyword, font: .pretendard(size: 16, weight: .medium), lineHeight: 23)
   
        deleteButton.rx.tap
            .map { SearchKeywordCellEventType.deleteButtonTap(keyword: keyword) }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.add(clockIcon, searchKeywordLabel, deleteButton)
    }
    
    override func configureLayout() {
        clockIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView).offset(24)
            $0.size.equalTo(16)
        }
        
        searchKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(clockIcon)
            $0.leading.equalTo(clockIcon.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualTo(deleteButton.snp.leading).inset(12)
            $0.height.equalTo(23)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(clockIcon)
            $0.trailing.equalTo(contentView).inset(24)
            $0.size.equalTo(20)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
