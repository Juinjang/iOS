//
//  PlayRecordViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/19/24.
//

import UIKit
import SnapKit

class PlayRecordViewController: UIViewController {

    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let bottomViewController = PlayViewController()
    
    lazy var bottomSheetTotalHeight: CGFloat = UIScreen.main.bounds.height * (392 / 844)

    var bottomHeight: CGFloat {
        return bottomSheetTotalHeight
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cancel-white"), for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        print("닫기")
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        print("bottomSheetTotalHeight: \(bottomSheetTotalHeight)")
        //print("bottomHeight: \(bottomHeight)")
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
           // $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(354)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            $0.top.equalTo(bottomSheetView.snp.top).offset(29)
        }
    }
}

