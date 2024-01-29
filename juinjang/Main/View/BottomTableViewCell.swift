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
    
    static let identifier = "BottomTableViewCell"
    static let cellHeight = 250.0
    
//MARK: - 변수 설정
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate : UICollectionViewDelegate & UICollectionViewDataSource, forRow row: Int){
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
    }
    //최근 본 임장
    var recentImjangLabel = UILabel().then {
        $0.text = "최근 본 임장"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //최근 본 임장이 없을 때
    var noImjangImageView = UIImageView().then {
        $0.image = UIImage(named: "투명로고")
        $0.contentMode = .scaleAspectFill
        $0.alpha = 0.0
    }
    var noImjaneLabel = UILabel().then {
        $0.text = "아직 등록된 집이 없어요"
        $0.textColor = UIColor(named: "450")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func addContentView() {
        contentView.addSubview(recentImjangLabel)
        //contentView.addSubview(noImjangImageView)
        //contentView.addSubview(noImjaneLabel)
        contentView.addSubview(collectionView)
    }
        
    private func autoLayout() {
        recentImjangLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
        
        /*noImjangImageView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(49)
            $0.left.right.equalToSuperview().inset(149)
            $0.height.equalTo(108.83)
        }
        
        noImjaneLabel.snp.makeConstraints{
            $0.top.equalTo(noImjangImageView.snp.bottom).offset(33.17)
            $0.left.equalToSuperview().offset(122)
        }*/
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(204)
        }
    }
}

