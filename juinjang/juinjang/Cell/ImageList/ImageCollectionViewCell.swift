//
//  ImageCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(image: nil)
    }
    
    func configureCell(image: UIImage?) {
        guard let image else { return }
        print("뭐야;;;")
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    override func draw(_ rect: CGRect) {
        DispatchQueue.main.async {
            self.contentView.layer.cornerRadius = 5
            self.contentView.clipsToBounds = true
        }
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func configureView() {
        imageView.backgroundColor = ColorStyle.emptyGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
