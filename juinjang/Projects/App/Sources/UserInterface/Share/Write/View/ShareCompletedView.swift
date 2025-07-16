//
//  ShareCompletedView.swift
//  juinjang
//
//  Created by KimDongWoo on 6/7/25.
//

import UIKit
import Then
import SnapKit
import Lottie

final class ShareCompletedView: BaseAlertViewController {
    private let baseView = UIView()
    
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.text = "임장노트 나누기 완료"
    }
    
    private let animatedView = LottieAnimationView(name: "Animation_share_completed")
    
    init() {
        super.init(
            height: 277,
            isBackgroundDismissEnabled: true,
            contentViews: [baseView],
            buttons: [.cancel(title: "다른 노트 구경가기", width: 179),
                      .confirm(title: "확인하기")]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedView.loopMode = .loop
        animatedView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animatedView.stop()
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
        
        baseView.add(
            titleLabel,
            animatedView
        )
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(204)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        animatedView.snp.makeConstraints {
            $0.size.equalTo(168)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
