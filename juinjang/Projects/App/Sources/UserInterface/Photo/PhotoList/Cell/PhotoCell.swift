//
//  PhotoCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import Kingfisher

final class PhotoCell: BaseCollectionViewCell {
    private let baseButton = UIButton()
    
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind(item: PhotoCellItem,
              relay: PublishRelay<Int>) {
        contentView.backgroundColor = .null
        contentView.roundCorners(cornerRadius: 5, corner: .all)
        mainImageView.kf.setImage(with: URL(string: item.imageUrl))
                
        baseButton.rx.throttleTap
            .map {
                Int(item.id) ?? 0
            }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(
            mainImageView,
            baseButton
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
