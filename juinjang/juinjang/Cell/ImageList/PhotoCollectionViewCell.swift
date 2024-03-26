//
//  photoCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let photoStatusLabel = PaddingLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            self.photoStatusLabel.layer.cornerRadius = self.photoStatusLabel.bounds.height / 2
            self.photoStatusLabel.clipsToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imageDto: nil, index: nil, totalCount: nil)
    }
    
    func configureCell(imageDto: ImageDto?, index: Int?, totalCount: Int?) {
        guard let imageDto else { return }
        if let url = URL(string: imageDto.imageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
        } else {
            imageView.image = UIImage(named: "1")
        }
        if let index, let totalCount {
            photoStatusLabel.text = "\(index)/\(totalCount)"
        }
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(photoStatusLabel)
    }
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(250)
        }
        
        photoStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(46)
            $0.height.equalTo(26)
        }
    }
    func configureView() {
        contentView.backgroundColor = .white
        imageView.backgroundColor = ColorStyle.emptyGray
        imageView.contentMode = .scaleAspectFill
        photoStatusLabel.design(text: "/", textColor: .white, font: .pretendard(size: 16, weight: .regular))
        photoStatusLabel.backgroundColor = .black.withAlphaComponent(0.4)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
