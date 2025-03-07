//
//  STTLoadingViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import Lottie
import Speech
import AmplitudeSwift

final class STTLoadingViewController: BaseViewController {
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let totalHeight: CGFloat = 844 // 전체 높이
    let ratio: CGFloat = 392 // Bottom Sheet가 차지하는 높이
    
    var bottomSheetHeight: CGFloat {
        return (ratio / totalHeight) * UIScreen.main.bounds.height // 디바이스가 달라져도 비율만큼 차지
    }
    
    lazy var sttConversionLabel = UILabel().then {
        $0.text = "speech to text 변환 중..."
        $0.textAlignment = .center
        $0.textColor = .mainWhite
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var animationView = LottieAnimationView(name: "Animation - 1707961785957.json").then {
        $0.frame = CGRect(x: 156, y: 184, width: 73, height: 76)
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
    }
    
    weak var bottomSheetViewController: BottomSheetViewController?
    var imjangId: Int
    var fileURL: URL
    var recordTime: Int
    
    init(imjangId: Int, fileURL: URL, recordTime: Int) {
        self.imjangId = imjangId
        self.fileURL = fileURL
        self.recordTime = recordTime
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetView.backgroundColor = .gray500
        addSubViews()
        setupLayout()
        startSTT()
    }
    
    // 재생 화면으로 전환
    func showPlaybackVC(recordResponse: RecordResponse) {
        let recordPlaybackVC = RecordPlaybackViewController(recordResponse: recordResponse)
        recordPlaybackVC.bottomSheetViewController = bottomSheetViewController
        bottomSheetViewController?.transitionToViewController(recordPlaybackVC)
    }
    
    func startSTT() {
        transcribeAudio() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let script):
                print("STT 성공")
                print(UserDefaultManager.shared.accessToken)
                
                let recordRequestDTO = getRecordRequestDTO(script: script)
                
                uploadRecordFile(recordRequestDto: recordRequestDTO)
            case .failure(let failure):
                print("STT 실패")
                let recordRequestDTO = getRecordRequestDTO(script: "")
                uploadRecordFile(recordRequestDto: recordRequestDTO)
//                bottomSheetViewController?.transitionToViewController(self)
            }
        }
    }
    
    private func uploadRecordFile(recordRequestDto: RecordRequestDTO) {
        JuinjangAPIManager.shared.uploadRecordFile(api: .uploadRecordFile, fileURL: fileURL, dto: recordRequestDto) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let recordResponse):
                print(recordResponse)
                NotificationCenter.default.post(name: .addRecordResponse, object: recordResponse)
                // 녹음 파일 업로드 이벤트
                amplitude.track(event: BaseEvent(eventType: AmpliEventName.button_clicked.rawValue, eventProperties: [
                    AmpliEventProp.record_file.rawValue: "true"
                ]))
                showPlaybackVC(recordResponse: recordResponse)
            case .failure(let failure):
                print("실패...>!!!!!")
                bottomSheetViewController?.hideBottomSheetAndGoBack()
            }
        }
    }
    
    // 음성 파일에 대해 Speech To Text
    private func transcribeAudio(completionHandler: @escaping (Result<String, STTError>) -> Void) {
        print("STT 시작")
        // 음성 인식 권한 확인
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR")), recognizer.isAvailable else {
            print("Speech recognizer is not available")
            completionHandler(.failure(STTError.isNotAvailable))
            return
        }
        
        // url통해 음성 파일에 대한 음성 인식 요청 객체 생성
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        recognizer.recognitionTask(with: request) { result, error in
            guard let result, error == nil else {
                print("There was an error: \(error!.localizedDescription)")
                completionHandler(.failure(STTError.resultError))
                return
            }

            if result.isFinal {
                print("Transcription: \(result.bestTranscription.formattedString)")
                completionHandler(.success(result.bestTranscription.formattedString))
                return
            }
        }
    }
    
    private func getRecordRequestDTO(script: String) -> RecordRequestDTO {
        return RecordRequestDTO(limjangId: imjangId, recordTime: recordTime, recordScript: script)
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        animationView.play()
        [sttConversionLabel, animationView].forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        // STT 변환 Label
        sttConversionLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(87)
        }
    }
}
