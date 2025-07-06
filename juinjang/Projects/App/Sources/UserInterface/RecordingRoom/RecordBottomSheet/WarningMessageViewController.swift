//
//  WarningMessageViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/14.
//

import UIKit
import SnapKit

protocol CheckWarningMessageDelegate: AnyObject {
    func checkMessage()
}

final class WarningMessageViewController: BaseViewController {
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let totalHeight: CGFloat = 844 // 전체 높이
    let ratio: CGFloat = 392 // Bottom Sheet가 차지하는 높이
    let lastPopupDateKey = "lastPopupDate" // 경고 메시지 날짜 저장 Key
    
    weak var delegate: CheckWarningMessageDelegate?
    
    var bottomSheetHeight: CGFloat {
        return (ratio / totalHeight) * UIScreen.main.bounds.height // 디바이스가 달라져도 비율만큼 차지
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage.Recording.cancelBlack, for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var warningMessageLabel = UILabel().then {
        $0.text = "녹음 파일을 법적인 상황에서 활용하려면\n반드시 녹음한 사람의 목소리가 함께 들어가야 해요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.asColor(targetString: "녹음한 사람의 목소리가 함께", color: .main)
    }
    
    lazy var warningMessageImage = UIImageView().then {
        $0.image = UIImage.Recording.check
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var checkButton = UIButton().then {
        $0.setTitle("오늘 하루 보지 않기", for: .normal)
        $0.setTitleColor(.gray600, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage.Recording.checkOff, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill

        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
    }

    lazy var recordStartButton = UIButton().then {
        $0.setTitle("녹음 시작!", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        
        $0.backgroundColor = .gray500
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(confirmButtonPressed(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    weak var bottomSheetViewController: BottomSheetViewController?
    
    private var currentChildViewController: UIViewController?
    var imjangId: Int
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(String(describing: self), "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        [cancelButton,
        warningMessageLabel,
        warningMessageImage,
        checkButton,
        recordStartButton].forEach { bottomSheetView.addSubview($0) }
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
        
        // 경고 메시지 문구 Label
        warningMessageLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(cancelButton.snp.bottom).offset(4)
        }
        
//        let ratio: CGFloat = 294.07 / 114.61
        // 경고 메시지 ImageView
        warningMessageImage.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
//            $0.width.equalTo(bottomSheetView.snp.width).multipliedBy(0.75)
//            $0.height.equalTo(warningMessageImage.snp.width).multipliedBy(0.75/ratio)
            $0.top.equalTo(warningMessageLabel.snp.bottom).offset(24.88)
        }
        
        // 문구 확인 Button
        checkButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.width.equalTo(140)
            $0.top.equalTo(warningMessageImage.snp.bottom).offset(30)//38.51
        }
        
        // 녹음 시작 Button
        recordStartButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(checkButton.snp.bottom).offset(16)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        checkButton.isSelected = !checkButton.isSelected
        
        if checkButton.isSelected {
            print("선택")
            checkButton.setImage(UIImage.Recording.checkOn, for: .normal)
            recordStartButton.setTitle("확인했어요", for: .normal)
            delegate?.checkMessage()
        } else {
            print("선택 해제")
            checkButton.setImage(UIImage.Recording.checkOff, for: .normal)
            recordStartButton.setTitle("녹음 시작!", for: .normal)
        }
    }
    
    @objc func confirmButtonPressed(_ sender: UIButton) {
        let recordVC = RecordViewController(imjangId: imjangId)
        recordVC.bottomSheetViewController = bottomSheetViewController
        
        bottomSheetViewController?.transitionToViewController(recordVC)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        print("닫기")
        dismiss(animated: true, completion: nil)
        //bottomSheetViewController?.hideBottomSheetAndGoBack()
    }
}
