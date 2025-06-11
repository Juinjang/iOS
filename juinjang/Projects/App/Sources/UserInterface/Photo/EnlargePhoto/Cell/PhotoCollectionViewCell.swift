//
//  photoCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class PhotoCollectionViewCell: UICollectionViewCell {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
        
        scrollView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imageDto: nil)
    }
    
    func configureCell(imageDto: ImageDto?) {
        guard let imageDto else { return }
        imageView.kf.setImage(with: URL(string: imageDto.imageUrl))
    }
    
    private func configureHierarchy() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.centerY.equalToSuperview()
        }
    }
    private func configureView() {
        contentView.backgroundColor = .clear
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let collectionView = self.superview as? UICollectionView else { return }
        
        let enlarged = scrollView.zoomScale > 1
        collectionView.isScrollEnabled = !enlarged

        guard let image = imageView.image else { return }
        
        if enlarged {
            let ratioWidth = imageView.frame.width / image.size.width
            let ratioHeight = imageView.frame.height / image.size.height
            
            let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
            
            let imageWidth = image.size.width * ratio
            let imageHeight = image.size.height * ratio
            
            let leftCondition = imageWidth * scrollView.zoomScale > imageView.frame.width
            var leftInset = leftCondition
            ? imageWidth - imageView.frame.width
            : scrollView.frame.width - scrollView.contentSize.width
            
            leftInset = leftInset * 0.5
            
            let topCondition = imageHeight * scrollView.zoomScale > self.imageView.frame.height
            var topInset = topCondition
            ? imageHeight - imageView.frame.height
            : scrollView.frame.height - scrollView.contentSize.height
            
            topInset = topInset * 0.5
            
            scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)
        } else {
            scrollView.contentInset = .zero
        }
    }
}
