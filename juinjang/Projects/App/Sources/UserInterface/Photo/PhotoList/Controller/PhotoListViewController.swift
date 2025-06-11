//
//  PhotoListViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 5/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import ReactorKit

final class PhotoListViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    typealias DataSource = UICollectionViewDiffableDataSource<PhotoSection, PhotoCellItem>
    private var dataSource: DataSource!
    private let mainView = PhotoListView()
    
    private let photoClickRelay = PublishRelay<Int>()
    
    init(reactor: PhotoListViewReactor) {
        super.init()
        configureDataSource()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: PhotoListViewReactor) {
        reactor.state
            .map(\.photoList)
            .bind(to: mainView.rx.bindPhotos(to: dataSource))
            .disposed(by: disposeBag)
        
        photoClickRelay
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (self, index) in
                let enlargePhotoVC = EnlargePhotoViewController(currentIndex: index, photoList: reactor.convertToImageDTOList())
                enlargePhotoVC.modalPresentationStyle = .overFullScreen
                self.present(enlargePhotoVC, animated: false)
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - Setup DataSource
extension PhotoListViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: mainView.exposedCollectionView
        ) { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(PhotoCell.self,
                                                          for: indexPath)
            cell.bind(item: item, relay: self.photoClickRelay)
            return cell
        }
    }
}
