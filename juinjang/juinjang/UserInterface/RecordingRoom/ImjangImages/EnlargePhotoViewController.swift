//
//  EnlargePhotoViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import SnapKit

class EnlargePhotoViewController: UIViewController {
    let closeButton = UIButton()
    lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    
    var currentIndex: Int?
    var photoList: [ImageDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureHierarchy()
        configureLayout()
        configureView()
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let currentIndex {
           
            print("currentIndex \(currentIndex)")
            photoCollectionView.reloadData()
            DispatchQueue.main.async {
                self.photoCollectionView.isPagingEnabled = false
                self.photoCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: false)
                self.photoCollectionView.isPagingEnabled = true
            }
        }
    }
    
    @objc func closeVC() {
        dismiss(animated: false)
    }
    
    func configureCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.isPagingEnabled = false
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    func configureHierarchy() {
        view.addSubview(closeButton)
        view.addSubview(photoCollectionView)
    }
    func configureLayout(){
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.equalToSuperview().offset(22)
            $0.size.equalTo(12)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(closeButton.snp.bottom).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
    }
    func configureView() {
        view.backgroundColor = .white
        closeButton.design(image: ImageStyle.x, tintColor: .black ,backgroundColor: .white)
    }
    
   
}

extension EnlargePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let item = photoList[indexPath.row]
        
        cell.configureCell(imageDto: item, index: indexPath.row + 1, totalCount: photoList.count)
        
        return cell
    }
    
    
}
