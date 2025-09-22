//
//  BottomTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then

final class BottomTableViewCell: UITableViewCell{
    
    static let id = "BottomTableViewCell"
    static let cellHeight = 250.0
    //MARK: - 변수 설정
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        return cv
    }()
    
    //최근 본 임장
    var recentImjangLabel = UILabel().then {
        $0.text = "최근 본 임장"
        $0.textColor = .gray500
        $0.font = .pretendard(size: 20, weight: .bold)
    }
    
    //최근 본 임장이 없을 때
    var noImjangImageView = UIImageView().then {
        $0.image = UIImage.Main.nomaemull.resize(newHeight: 108)
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
    }
    var noImjangLabel = UILabel().then {
        $0.text = "아직 등록된 집이 없어요"
        $0.textColor = .gray400
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isHidden(_ isEmpty: Bool, isFirstShowing: Bool) {
        guard !isFirstShowing else {
            showLoading()
            return
        }
        hideLoading()
        noImjangLabel.isHidden = !isEmpty
        noImjangImageView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
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
            $0.height.equalTo(108)
        }
        
        noImjangLabel.snp.makeConstraints{
            $0.top.equalTo(noImjangImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        //최근 본 임장 있을 때
        collectionView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(204)
        }
    }
    
    func showLoading() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = contentView.center
        spinner.tag = 999
        spinner.startAnimating()
        spinner.isUserInteractionEnabled = false // 터치 막을 필요 없으므로 false

        contentView.addSubview(spinner)
    }

    func hideLoading() {
        if let spinner = viewWithTag(999) as? UIActivityIndicatorView {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
}


