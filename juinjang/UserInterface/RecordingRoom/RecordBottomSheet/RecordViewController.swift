//
//  RecordViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/13.
//

import UIKit
import SnapKit

class RecordViewController: UIViewController {
    
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
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cancel-white"), for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var recordLabel = UILabel().then {
        $0.text = "녹음하기"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.text = "00:18.79"
        $0.textColor = UIColor(named: "lightGray")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    // -TODO: 음성과 직접 연결 필요
    lazy var recordWaveForm = UIImageView().then {
        $0.image = UIImage(named: "record-bar")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var limitLabel = UILabel().then {
        $0.text = "녹음은 5분까지만 가능해요"
        $0.textAlignment = .center
        $0.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var trashButton = UIButton().then {
        $0.setImage(UIImage(named: "record-trash"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.addTarget(self, action: #selector(completedButtonPressed(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        [cancelButton,
         recordLabel,
         timeLabel,
         recordWaveForm,
         limitLabel,
         trashButton,
         recordButton,
         completedButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        // 취소 Button
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(12)
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(354)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            $0.top.equalTo(bottomSheetView.snp.top).offset(29)
        }
        
        // 녹음 Label
        recordLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(24)
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(164)
        }
        
        // 시간 Label
        timeLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(recordLabel.snp.bottom).offset(34)
        }
        
        // 파형 ImageView
        recordWaveForm.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(timeLabel.snp.bottom).offset(25)
        }
        
        // 제한 문구 Label
        limitLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(recordWaveForm.snp.bottom).offset(28)
        }
        
        // 휴지통 Button
        trashButton.snp.makeConstraints {
            $0.top.equalTo(limitLabel.snp.bottom).offset(48)
            $0.trailing.equalTo(recordButton.snp.leading).offset(-90)
        }
        
        // 녹음 Button
        recordButton.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(limitLabel.snp.bottom).offset(35)
        }
        
        // 완료 Button
        completedButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(90)
            $0.top.equalTo(limitLabel.snp.bottom).offset(54)
            $0.height.equalTo(24)
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        bottomSheetViewController?.hideBottomSheetAndGoBack()
    }
    
    @objc func startRecordPressed(_ sender: UIButton) {
        if recordButton.isSelected {
            recordButton.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        } else {
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        }
        recordButton.isSelected.toggle()
    }
    
    @objc func completedButtonPressed(_ sender: UIButton) {
        let loadingVC = STTLoadingViewController()
        loadingVC.bottomSheetViewController = bottomSheetViewController
        
        bottomSheetViewController?.transitionToViewController(loadingVC)
        
        // 임의로 2초 후 recordPlaybackVC로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            let recordPlaybackVC = RecordPlaybackViewController()
            recordPlaybackVC.bottomSheetViewController = bottomSheetViewController

            bottomSheetViewController?.transitionToViewController(recordPlaybackVC)
        }
    }
}
