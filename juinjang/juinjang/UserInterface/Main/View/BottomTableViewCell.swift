//
//  BottomTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then

class BottomTableViewCell: UITableViewCell{
    
    static let id = "BottomTableViewCell"
    static let cellHeight = 250.0
    //MARK: - 변수 설정
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        return cv
    }()
    
    //최근 본 임장
    var recentImjangLabel = UILabel().then {
        $0.text = "최근 본 임장"
        $0.textColor = ColorStyle.textBlack
        $0.font = .pretendard(size: 20, weight: .bold)
    }
    
    //최근 본 임장이 없을 때
    var noImjangImageView = UIImageView().then {
        $0.image = UIImage(named: "투명로고")
        $0.contentMode = .scaleAspectFill
    }
    var noImjangLabel = UILabel().then {
        $0.text = "아직 등록된 집이 없어요"
        $0.textColor = UIColor(named: "450")
        $0.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func isHidden(_ isEmpty: Bool) {
        noImjangLabel.isHidden = isEmpty ? false : true
        noImjangImageView.isHidden = isEmpty ? false : true
        collectionView.isHidden = isEmpty ? true : false
    }
    
    private func addContentView() {
        [recentImjangLabel, noImjangImageView, noImjangLabel, collectionView].forEach {
            contentView.addSubview($0)
        }
    }
        
    private func autoLayout() {
        recentImjangLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
        
        //최근 본 임장 없을 떄
        noImjangImageView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(49)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(108.83)
        }
        
        noImjangLabel.snp.makeConstraints{
            $0.top.equalTo(noImjangImageView.snp.bottom).offset(33.17)
            $0.centerX.equalToSuperview()
        }
        
        //최근 본 임장 있을 때
        collectionView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(204)
        }
    }
}


