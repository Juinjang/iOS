//
//  SignUpBottomSheetView.swift
//  App
//
//  Created by KimDongWoo on 12/13/25.
//

import UIKit
import Then
import SnapKit
import AmplitudeSwift

final class SignUpBottomSheetView: UIViewController {
    private let containerView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.roundCorners(cornerRadius: 24, corner: .top)
    }
    
    private let mainIconView = UIImageView().then {
        $0.image = .keyIcon
    }
    
    private let titleLabel = DSLabel(.h4).then {
        $0.fontColor = .gray600
        $0.text = "여기서부터는 회원가입이 필요해요"
        $0.fontAlignment = .center
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray400
        $0.text = "회원가입을 하면 서비스를 이용할 수 있어요.\n회원가입 하러 갈까요?"
        $0.numberOfLines = 2
        $0.fontAlignment = .center
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.backgroundColor = .gray3
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    private lazy var acceptButton = UIButton().then {
        $0.backgroundColor = .gray500
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("예", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        view.addSubview(
            containerView.with(
                mainIconView,
                titleLabel,
                contentLabel,
                cancelButton,
                acceptButton
            )
        )
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(373)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        mainIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.size.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainIconView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(containerView.snp.centerX).offset(-4)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(52)
        }
        
        acceptButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(24)
            $0.left.equalTo(containerView.snp.centerX).offset(4)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(52)
        }
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func acceptButtonTapped(_ sender: UIButton) {
        amplitude.track(event: BaseEvent(eventType: AmpliEventName.signup_button_clicked.rawValue))
        present(SignUpViewController(.present), animated: true)
    }
}
