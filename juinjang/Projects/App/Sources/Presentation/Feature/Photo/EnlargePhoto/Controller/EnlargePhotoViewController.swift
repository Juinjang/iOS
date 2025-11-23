//
//  EnlargePhotoViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import SnapKit

final class EnlargePhotoViewController: BaseViewController {
    private let mainView = EnlargePhotoView()
    var currentIndex: Int
    var photoList: [ImageDto]
    
    init(currentIndex: Int, photoList: [ImageDto]) {
        self.currentIndex = currentIndex
        self.photoList = photoList
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        mainView.closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mainView.photoCollectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mainView.photoCollectionView.reloadData()
            mainView.photoCollectionView.isPagingEnabled = false
            mainView.photoCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            mainView.photoCollectionView.isPagingEnabled = true
            mainView.setCurrentIndex(index: currentIndex + 1, totalCount: photoList.count)
        }
    }
    
    
    // 닫기버튼 클릭 시
    @objc func closeVC() {
        dismiss(animated: false)
    }
    
    func configureCollectionView() {
        mainView.photoCollectionView.delegate = self
        mainView.photoCollectionView.dataSource = self
    }
}

// MARK: 이미지 CollectionView Delegate
extension EnlargePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let item = photoList[indexPath.row]
       
        cell.configureCell(imageDto: item)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        currentIndex = Int(scrollView.contentOffset.x / pageWidth)
       
        mainView.setCurrentIndex(index: currentIndex + 1, totalCount: photoList.count)
    }
    
}
