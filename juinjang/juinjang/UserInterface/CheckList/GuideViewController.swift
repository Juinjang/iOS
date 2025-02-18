//
//  GuideViewController.swift
//  juinjang
//
//  Created by 임수진 on 7/21/24.
//

import UIKit
import Then
import SnapKit

final class GuideViewController: UIViewController {
    
    private let imageView =  UIImageView().then {
        $0.image = UIImage(named: "guide-checklist")
        $0.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        
        if UIScreen.main.bounds.height <= 667 { // 아이폰 SE(3rd generation) 기준으로 스크린이 작으면
            // 비율에 맞춘 이미지 사용
            imageView.image = UIImage(named: "guide-checklist-se")
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView() {
        view.addSubview(imageView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }
}
