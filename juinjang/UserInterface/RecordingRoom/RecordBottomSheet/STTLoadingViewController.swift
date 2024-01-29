//
//  STTLoadingViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit

class STTLoadingViewController: UIViewController {

    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let totalHeight: CGFloat = 844 // 전체 높이
    let ratio: CGFloat = 392 // Bottom Sheet가 차지하는 높이
    
    var bottomSheetHeight: CGFloat {
        return (ratio / totalHeight) * UIScreen.main.bounds.height // 디바이스가 달라져도 비율만큼 차지
    }
    
    lazy var sttConversionLabel = UILabel().then {
        $0.text = "speech to text 변환 중..."
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var loadingImage = UIImageView().then {
        $0.image = UIImage(named: "record-loading")
        $0.contentMode = .scaleAspectFill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        [sttConversionLabel,
         loadingImage].forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        // STT 변환 Label
        sttConversionLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(87)
        }
        
        // 로딩 ImageView
        loadingImage.snp.makeConstraints {
            $0.top.equalTo(sttConversionLabel.snp.bottom).offset(78)
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
        }
    }
}
