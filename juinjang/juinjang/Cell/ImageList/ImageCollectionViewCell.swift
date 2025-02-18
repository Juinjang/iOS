//
//  ImageCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
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
        imageView.image = image
    }
    
    override func draw(_ rect: CGRect) {
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
    }
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    private func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func configureView() {
        imageView.backgroundColor = ColorStyle.emptyGray
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
