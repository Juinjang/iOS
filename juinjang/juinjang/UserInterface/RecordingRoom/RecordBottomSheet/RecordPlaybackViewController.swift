//
//  RecordPlaybackViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit

final class RecordPlaybackViewController: BaseViewController {

    weak var bottomSheetViewController: BottomSheetViewController?
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    lazy var topViewController = RecordTopViewController(recordResponse: recordResponse)
    lazy var bottomViewController = RecordBottomViewController(recordResponse: recordResponse)
    
    lazy var bottomSheetTotalHeight: CGFloat = UIScreen.main.bounds.height * (801 / 844)
    lazy var topHeightRatio: CGFloat = 430 / 801
    lazy var bottomHeightRatio: CGFloat = 1 - topHeightRatio

    var topHeight: CGFloat {
        return topHeightRatio * bottomSheetTotalHeight
    }

    var bottomHeight: CGFloat {
        return bottomHeightRatio * bottomSheetTotalHeight
    }
    
    var recordResponse: RecordResponse
    
    init(recordResponse: RecordResponse) {
        self.recordResponse = recordResponse
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
    
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
    }
    
    
    func addSubViews() {
        addChild(topViewController)
        addChild(bottomViewController)
        view.addSubview(bottomSheetView)
        bottomSheetView.addSubview(topViewController.view)
        bottomSheetView.addSubview(bottomViewController.view)
        
        topViewController.bottomSheetViewController = bottomSheetViewController
        bottomViewController.topViewController = topViewController
        
        topViewController.didMove(toParent: self)
        bottomViewController.didMove(toParent: self)
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
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
