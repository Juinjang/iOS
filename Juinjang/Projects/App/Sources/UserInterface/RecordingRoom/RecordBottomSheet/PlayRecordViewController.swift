//
//  PlayRecordViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/19/24.
//

import UIKit
import SnapKit

final class PlayRecordViewController: BaseViewController, UITextFieldDelegate{

    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    lazy var bottomSheetTotalHeight: CGFloat = UIScreen.main.bounds.height * (392 / 844)

    var bottomHeight: CGFloat {
        return bottomSheetTotalHeight
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage.Recording.cancelWhite, for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }

    weak var bottomSheetViewController: BottomSheetViewController?
    lazy var bottomViewController = PlayViewController()
    var recordResponse: RecordResponse
    
    init(recordResponse: RecordResponse) {
        self.recordResponse = recordResponse
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomViewController.titleTextField.delegate = self
        bottomSheetView.backgroundColor = .gray500
        addSubViews()
        setupLayout()
        print("bottomSheetTotalHeight: \(bottomSheetTotalHeight)")
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        print("닫기")
        dismiss(animated: true) 
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        bottomSheetView.addSubview(bottomViewController.view)
        bottomSheetView.addSubview(cancelButton)
        
        addChild(bottomViewController)
        
        bottomViewController.didMove(toParent: self)
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetTotalHeight)
        }
        
        // Bottom View Controller
        bottomViewController.view.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomHeight)
        }
        
        // 취소 Button
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(12)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            $0.top.equalTo(bottomSheetView.snp.top).offset(29)
        }
    }
}

