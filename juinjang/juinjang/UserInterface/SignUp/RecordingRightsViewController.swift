//
//  RecordingRightsViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit
import AVFoundation

final class RecordingRightsViewController: BaseViewController {
    
    lazy var guideLabel = UILabel().then {
        $0.text = "주인장 앱에서\n필요한 권한을 알려드려요"
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = .gray600
        $0.font = .pretendard(size: 24, weight: .bold)
        $0.asColor(targetString: "권한", color: .main)
    }
    
    lazy var guideDetailLabel = UILabel().then {
        $0.text = "원활한 서비스 이용을 위해 동의가 필요해요."
        $0.textColor = .gray400
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    
    lazy var microphoneImageView = UIImageView().then {
        $0.image = UIImage(named: "microphone")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var recordingLabel = UILabel().then {
        $0.text = "주인장 오디오 녹음 (필수)"
        $0.textColor = .gray500
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.asColor(targetString: "(필수)", color: .main)
    }
    
    lazy var recordingDetailLabel = UILabel().then {
        $0.text = "녹음 및 음성인식 서비스 제공"
        $0.textColor = .gray500
        $0.font = .pretendard(size: 14, weight: .medium)
    }
    
    lazy var confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.backgroundColor = .gray500
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainWhite
        setNavigationBar()
        addSubViews()
        setupLayout()
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func addSubViews() {
        [guideLabel,
         guideDetailLabel,
         microphoneImageView,
         recordingLabel,
         recordingDetailLabel,
         confirmButton].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.04 * view.bounds.height)
            $0.leading.equalTo(24)
        }
        
        // 안내 상세 Label
        guideDetailLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(0.06 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.leading.equalTo(24)
        }
        
        // 마이크 ImageView
        microphoneImageView.snp.makeConstraints {
            $0.top.equalTo(guideDetailLabel.snp.bottom).offset(59)
            $0.leading.equalToSuperview().offset(37)
        }
        
        // 녹음 Label
        recordingLabel.snp.makeConstraints {
            $0.top.equalTo(guideDetailLabel.snp.bottom).offset(58)
            $0.leading.equalTo(microphoneImageView.snp.trailing).offset(10)
        }
        
        // 녹음 상세 Label
        recordingDetailLabel.snp.makeConstraints {
            $0.top.equalTo(recordingLabel.snp.bottom).offset(8)
            $0.leading.equalTo(69)
        }
        
        // 확인 Button
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-33)
            //            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // 녹음 권한 팝업창 띄우기
        requestMicrophonePermission { [weak self] granted in
            guard let self else { return }
            DispatchQueue.main.async {
                self.changeHome()
                amplitude.track(eventType: AmpliEventName.signup.rawValue)
            }
        }
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Mic: 권한이 허용되었습니다.")
            } else {
                print("Mic: 권한이 거부되었습니다.")
            }
            completion(granted)
        }
    }
}
