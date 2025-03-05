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

final class ImjangImageListViewController: BaseViewController {
    private let mainView = ImjangImageListView()
    private let imagePicker = UIImagePickerController()
    
    private var imageList: [ImageDto] = [] {
        didSet {
            checkImage()
        }
    }// 일단 String 배열
    
    private var isLongTap: Bool = false
    private var selectedIndexs: Set<Int> = [] {
        didSet {
            if isDeleteMode {
                navigationItem.title = "삭제할 사진 선택(\(selectedIndexs.count))"
            }
            
            mainView.setIsSelectedIndexsEmptyUI(isEmpty: selectedIndexs.isEmpty)
        }
    }
    var imjangId: Int? = nil
    var completionHandler: (([String]) -> Void)?
    private var isDeleteMode = false
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        checkImage()
        configureCollectionView()
        callFetchImageRequest()
    }
    
    override func loadView() {
        view = mainView
    }
    
    // 이미지 전체 조회 요청
    func callFetchImageRequest() {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<ImagesListDto>.self, api: .fetchImage(imjangId: imjangId)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let imagesListDto = response.result else { return }
            self.imageList = imagesListDto.images
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
        if isDeleteMode {
            selectedIndexs.removeAll()
            setDeleteModeUIHidden()
        } else {
            let imageDtos = imageList.prefix(3)
            var imageStrings: [String] = []
            for image in imageDtos {
                imageStrings.append(image.imageUrl)
            }
            completionHandler?(imageStrings)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addImage() { // + 버튼 눌렀을 때 -> 이미지 추가
        if !checkImageCount() {
            showAlert(title: nil, message: "사진은 8개까지 올릴 수 있어요", actionHandler: nil)
            return
        }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 8
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func checkImage() {
        print(#function)
        if imageList.isEmpty {
            mainView.setEmptyLayout(true)
        } else {
            mainView.setEmptyLayout(false)
            DispatchQueue.main.async {
                self.isLongTap = false
                self.mainView.imageCollectionView.reloadData()
                print(self.selectedIndexs)
            }
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: mainView.imageCollectionView)
        
        switch gesture.state {
        case .began, .changed:
            // 위치에 해당하는 셀의 인덱스 패스 찾기
            guard let indexPath = mainView.imageCollectionView.indexPathForItem(at: location) else { return }
            // 해당 셀을 선택 상태로 변경
            isLongTap = true
            selectedIndexs.insert(imageList[indexPath.row].imageId) // 배열에 선택된 이미지의 아이디 넣기
            mainView.imageCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            // UICollectionViewDelegate 메서드를 수동으로 호출하여 선택을 처리
            mainView.imageCollectionView.delegate?.collectionView?(mainView.imageCollectionView, didSelectItemAt: indexPath)
        case .ended:
            // 드래그 종료 시 필요한 작업 수행
            isLongTap = false
            break
        default:
            break
        }
    }
    
    func configureCollectionView() {
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        configureCollectionViewFlowLayout()
    }
    
    func configureCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let size = (UIScreen.main.bounds.width - 48) - spacing*2
        layout.itemSize = CGSize(width: size/3, height: size/3)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        mainView.imageCollectionView.collectionViewLayout = layout
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "사진 목록"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        
        mainView.backButtonItem.addTarget(self, action: #selector(popView), for: .touchUpInside)
//        mainView.deleteImageButton.addTarget(self, action: #selector(deleteImages), for: .touchUpInside)
        mainView.deleteImageButtonItem.addTarget(self, action: #selector(deleteImageButtonTapped), for: .touchUpInside)
        mainView.addImageButtonItem.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.backButtonItem)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: mainView.addImageButtonItem),
            UIBarButtonItem(customView: mainView.deleteImageButtonItem)
        ]
    }
    
    // 선택된 이미지 삭제 요청
    func callDeleteImageRequest(imageIds: [Int]) {
        if imageIds.isEmpty { return }
        let parameter: [String:Any] = [
            "imageIdList": imageIds
        ]
        
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .deleteImage, parameter: parameter) { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let self else { return }
            self.selectedIndexs.removeAll()
        }
    }
    
    // 모두 선택 해제
    func deselectAll() {
        if let selectedItems = mainView.imageCollectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                mainView.imageCollectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    // MARK: 이미지 삭제 버튼 클릭 시
    // 1. 아이콘 제거
    // 2. 네비게이션바 제목 삭제할 사진 선택(0) 으로 변경
    // 3. collectionView panGesture 활성화
    // 4. 하단에 삭제 버튼 추가
    @objc func deleteImageButtonTapped() {
        
        isDeleteMode = true
        mainView.setNavigationBarButtonHidden(true)
        navigationItem.title = "삭제할 사진 선택(0)"
        
        mainView.imageCollectionView.addGestureRecognizer(panGesture)
        
        mainView.updateDeleteUI(true)
        mainView.deleteImageButton.addTarget(self, action: #selector(deleteImages), for: .touchUpInside)
    }
    
    
    // 이미지 삭제
    // 1. 삭제 확인 팝업창 표시
    // 2. 확인 클릭 시 삭제할 인덱스를 전달하여 이미지 삭제 요청
    @objc func deleteImages() {
        // 선택된 인덱스에 해당하는 요소를 배열에서 삭제
        if selectedIndexs.isEmpty {
            return
        }
        
        let deletePopupVC = DeleteImjangImagePopupView()
        deletePopupVC.selectedCount = selectedIndexs.count
        deletePopupVC.modalPresentationStyle = .overFullScreen
        deletePopupVC.completionHandler = {  [weak self] in// 선택된 이미지 삭제
            guard let self else { return }
            let indexes = self.selectedIndexs.sorted(by: >)
            print("삭제할 id들: \(indexes)")
            imageList.removeAll { image in
                indexes.contains(image.imageId)
            }
            self.callDeleteImageRequest(imageIds: indexes)
            
            setDeleteModeUIHidden()
        }
        present(deletePopupVC, animated: false)
    }
    
    private func setDeleteModeUIHidden() {
        mainView.updateDeleteUI(false)
        isDeleteMode = false
        navigationItem.title = "사진 목록"
        mainView.imageCollectionView.removeGestureRecognizer(panGesture)
        mainView.imageCollectionView.reloadData()
    }

    // 이미지 확대 화면으로 이동
    func showEnlargePhotoVC(index: Int, photoList: [ImageDto]) {
        let enlargePhotoVC = EnlargePhotoViewController(currentIndex: index, photoList: photoList)
        enlargePhotoVC.modalPresentationStyle = .overFullScreen
        present(enlargePhotoVC, animated: false)
    }
}

// MARK: CollectionView Delegate
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
        if isLongTap && isDeleteMode {
            print(#function, index)
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.mainStroke.cgColor
            isLongTap = false
        } else if isDeleteMode {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.mainStroke.cgColor
            selectedIndexs.insert(imageList[indexPath.row].imageId)
        } else {
            showEnlargePhotoVC(index: index, photoList: imageList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // 선택 해제된 셀의 시각적 강조 해제, 예를 들면 배경색을 원래대로
        
        if isLongTap && isDeleteMode {
            print(#function, indexPath.row)
            cell.contentView.layer.borderWidth = 0
            let item = imageList[indexPath.row]
            selectedIndexs.remove(item.imageId)
            print(selectedIndexs)
        } else if isDeleteMode {
            cell.contentView.layer.borderWidth = 0
            let item = imageList[indexPath.row]
            selectedIndexs.remove(item.imageId)
            print(selectedIndexs)
        }
    }
}

// MARK: ImagePicker Delegate
extension ImjangImageListViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let group = DispatchGroup()
        
        if !(results.isEmpty) {
            var images: [UIImage] = []
            
            print("results 개수 \(results.count)")
            // 이미지 개수 체크 후 제한 안내 alert
            if !checkImageCount(resultCount: results.count) {
                showAlert(title: nil, message: "사진은 8개까지 올릴 수 있어요", actionHandler: nil)
                return
            }
            
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
                            print(error)
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
    
    // 이미지 추가 화면에서 추가 시 resultCount에 값을 넣어 체크
    // 이미지 추가 버튼 클릭 시 resultCount = nil로 설정
    private func checkImageCount(resultCount: Int? = nil) -> Bool {
        if let resultCount {
            imageList.count + resultCount > 8 ? false : true
        } else {
            imageList.count >= 8 ? false : true
        }
    }
}
