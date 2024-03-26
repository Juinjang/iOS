//
//  RecordPlaybackViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit

class RecordPlaybackViewController: UIViewController {

    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let topViewController = RecordTopViewController()
    let bottomViewController = RecordBottomViewController()
    
    lazy var bottomSheetTotalHeight: CGFloat = UIScreen.main.bounds.height * (801 / 844)
    lazy var topHeightRatio: CGFloat = 430 / 801
    lazy var bottomHeightRatio: CGFloat = 1 - topHeightRatio

    var topHeight: CGFloat {
        return topHeightRatio * bottomSheetTotalHeight
    }

    var bottomHeight: CGFloat {
        return bottomHeightRatio * bottomSheetTotalHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        print("bottomSheetTotalHeight: \(bottomSheetTotalHeight)")
        print("topHeight: \(topHeight)")
        print("bottomHeight: \(bottomHeight)")
    }
    
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        bottomSheetView.addSubview(topViewController.view)
        bottomSheetView.addSubview(bottomViewController.view)
        
        topViewController.bottomSheetViewController = bottomSheetViewController
        bottomViewController.topViewController = topViewController
        
        addChild(topViewController)
        addChild(bottomViewController)
        
        topViewController.didMove(toParent: self)
        bottomViewController.didMove(toParent: self)
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
//            $0.height.equalTo(bottomSheetTotalHeight)
        }
        
        // Top View Controller
        topViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(topHeight)
            $0.bottom.equalTo(bottomViewController.view.snp.top)
        }
        
        // Bottom View Controller
        bottomViewController.view.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomHeight)
        }
    }
}
