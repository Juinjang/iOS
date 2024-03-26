//
//  ImjangImageListViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import SnapKit
import PhotosUI
import Kingfisher

class ImjangImageListViewController: UIViewController {
    let noImageBackgroundView = UIView()
    let noImageStackView = UIStackView()
    let galleryImageView = UIImageView()
    let noImageMessageLabel = UILabel()
    
    let imagePicker = UIImagePickerController()
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    var imageList: [ImageDto] = [] {
        didSet {
            checkImage()
        }
    }// 일단 String 배열
    
    var isLongTap: Bool = false
    var selectedIndexs: Set<Int> = []
    var imjangId: Int? = nil
    var completionHandler: (([String]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        checkImage()
        configureCollectionView()
        configureHierarchy()
        configureLayout()
        configureView()
        callFetchImageRequest()
    }
    
    // 이미지 전체 조회 요청
    func callFetchImageRequest() {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<ImagesListDto>.self, api: .fetchImage(imjangId: imjangId)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let imagesListDto = response.result else { return }
                self.imageList = imagesListDto.images
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    // 추가된 이미지 등록 요청
    func callAddImageRequest(images: [UIImage]) {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.uploadImages(imjangId: imjangId, images: images, api: .addImage) { result in
            self.callFetchImageRequest()    // 이미지가 추가됐으니 다시 전체 이미지를 조회하자
        }
    }
    
    @objc func popView() {
        let imageDtos = imageList.prefix(3)
        var imageStrings: [String] = []
        for image in imageDtos {
            imageStrings.append(image.imageUrl)
        }
        completionHandler?(imageStrings)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addImage() { // + 버튼 눌렀을 때 -> 이미지 추가
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func checkImage() {
        if imageList.isEmpty {
            print("비었냐?")
            setEmptyLayout(true)
        } else {
            print("안비었는뎅...")
            setEmptyLayout(false)
            DispatchQueue.main.async {
                self.isLongTap = false
                self.imageCollectionView.reloadData()
                print(self.selectedIndexs)
            }
        }
    }
    
    func setEmptyLayout(_ isEmpty: Bool) {
        DispatchQueue.main.async {
            self.imageCollectionView.isHidden = isEmpty ? true : false
            self.noImageBackgroundView.isHidden = isEmpty ? false : true
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: imageCollectionView)
        
        switch gesture.state {
        case .began, .changed:
            // 위치에 해당하는 셀의 인덱스 패스 찾기
            guard let indexPath = imageCollectionView.indexPathForItem(at: location) else { return }
            // 해당 셀을 선택 상태로 변경
            isLongTap = true
            selectedIndexs.insert(imageList[indexPath.row].imageId) // 배열에 선택된 이미지의 아이디 넣기
            imageCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            // UICollectionViewDelegate 메서드를 수동으로 호출하여 선택을 처리
            imageCollectionView.delegate?.collectionView?(imageCollectionView, didSelectItemAt: indexPath)
        case .ended:
            // 드래그 종료 시 필요한 작업 수행
            isLongTap = false
            break
        default:
            break
        }
    }
    
    func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        imageCollectionView.addGestureRecognizer(panGesture)
        imageCollectionView.allowsMultipleSelection = true
    }
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let size = (UIScreen.main.bounds.width - 48) - spacing*2
        layout.itemSize = CGSize(width: size/3, height: size/3)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        return layout
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "사진 목록"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
       
        let deleteImageButtonItem = UIBarButtonItem(image: ImageStyle.trash, style: .plain, target: self, action: #selector(deleteImages))
        let addButtonItem = UIBarButtonItem(image: ImageStyle.add, style: .plain, target: self, action: #selector(addImage))
        addButtonItem.tintColor = ColorStyle.darkGray

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItems = [addButtonItem, deleteImageButtonItem]
    }
    
    // 선택된 이미지 삭제 요청
    func callDeleteImageRequest(imageIds: [Int]) {
        if imageIds.isEmpty { return }
        let parameter: [String:Any] = [
            "imageIdList": imageIds
        ]
        
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .deleteImage, parameter: parameter) { response, error in
            if error == nil {
                guard let response = response else { return }
                print(response)
                self.selectedIndexs.removeAll()
                self.callFetchImageRequest()  // 삭제 완료시 전체 이미지 조회
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    // 모두 선택 해제
    func deselectAll() {
        if let selectedItems = self.imageCollectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                self.imageCollectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    @objc func deleteImages() {
        // 선택된 인덱스에 해당하는 요소를 배열에서 삭제
        if selectedIndexs.isEmpty {
            return
        }
        
        let deletePopupVC = DeleteImjangImagePopupView()
        deletePopupVC.selectedCount = selectedIndexs.count
        deletePopupVC.modalPresentationStyle = .overFullScreen
        deletePopupVC.completionHandler = { // 선택된 이미지 삭제
            let indexes = self.selectedIndexs.sorted(by: >)
            print("삭제할 id들: \(indexes)")
            self.callDeleteImageRequest(imageIds: indexes)
        }
        present(deletePopupVC, animated: false)
    }
    
    func configureHierarchy() {
        view.addSubview(noImageBackgroundView)
        view.addSubview(imageCollectionView)
        noImageBackgroundView.addSubview(noImageStackView)
        [galleryImageView, noImageMessageLabel].forEach {
            noImageStackView.addArrangedSubview($0)
        }
    }
    func configureLayout() {
        view.backgroundColor = .white
        
        imageCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        noImageBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noImageStackView.snp.makeConstraints {
            $0.center.equalTo(noImageBackgroundView)
            $0.width.equalTo(200)
        }
        
        galleryImageView.snp.makeConstraints {
            $0.size.equalTo(117)
        }
        
        noImageMessageLabel.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
    
    func configureView() {
        noImageStackView.design(axis: .vertical, spacing: 26)
        galleryImageView.design(image: ImageStyle.gallery, contentMode: .scaleAspectFit)
        noImageMessageLabel.design(text: "아직 등록된 사진이 없어요\n사진을 추가해 볼까요?", 
                                   textColor: ColorStyle.gray1,
                                   font: .pretendard(size: 18, weight: .medium),
                                   numberOfLines: 2)
        noImageMessageLabel.setLineSpacing(spacing: 4)
        noImageMessageLabel.textAlignment = .center
    }
    
    // 이미지 확대 화면으로 이동
    func showEnlargePhotoVC(index: Int, photoList: [ImageDto]) {
        let enlargePhotoVC = EnlargePhotoViewController()
        enlargePhotoVC.currentIndex = index
        enlargePhotoVC.photoList = photoList
        enlargePhotoVC.modalPresentationStyle = .overFullScreen
        present(enlargePhotoVC, animated: false)
    }
}

extension ImjangImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.contentView.layer.borderWidth = 0
        let item = imageList[indexPath.row]
        if let url = URL(string: item.imageUrl) {
            cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
        } else {
            cell.imageView.image = UIImage(named: "1")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if isLongTap {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = ColorStyle.mainStrokeOrange?.cgColor
            isLongTap = false
        } else {
            showEnlargePhotoVC(index: index, photoList: imageList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // 선택 해제된 셀의 시각적 강조 해제, 예를 들면 배경색을 원래대로
        cell.contentView.layer.borderWidth = 0
        let item = imageList[indexPath.row]
        selectedIndexs.remove(item.imageId)
        print(selectedIndexs)
    }
}


extension ImjangImageListViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let group = DispatchGroup()
        
        if !(results.isEmpty) {
            var images: [UIImage] = []
            for result in results {
                group.enter()
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            images.append(image)
                            group.leave()
                        }
                        
                        if let error = error {
                            group.leave()
                            return
                        }
                    }
                } else {
                    print("이미지 가져오기 실패")
                }
            }
            group.notify(queue: .main) {
                self.callAddImageRequest(images: images)
            }
        }
    }
    
    
}
