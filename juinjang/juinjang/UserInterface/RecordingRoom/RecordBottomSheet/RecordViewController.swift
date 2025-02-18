//
//  RecordViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/13.
//

import UIKit
import SnapKit
import Speech
import DSWaveformImageViews

struct Recording {
    var title: String
    var fileURL: URL
}

final class RecordViewController: BaseViewController, AVAudioRecorderDelegate {
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let totalHeight: CGFloat = 844 // 전체 높이
    let ratio: CGFloat = 392 // Bottom Sheet가 차지하는 높이
    
    var bottomSheetHeight: CGFloat {
        return (ratio / totalHeight) * UIScreen.main.bounds.height // 디바이스가 달라져도 비율만큼 차지
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cancel-white"), for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var recordLabel = UILabel().then {
        $0.text = "녹음하기"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.text = "00:00.00"
        $0.textColor = UIColor(named: "lightGray")
//        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .bold)
    }
    
    // -TODO: 음성과 직접 연결 필요
//    lazy var recordWaveForm = UIImageView().then {
//        $0.image = UIImage(named: "record-bar")
//        $0.contentMode = .scaleAspectFill
//    }
    var waveFormView = WaveformLiveView()
    
    lazy var limitLabel = UILabel().then {
        $0.text = "녹음은 5분까지만 가능해요"
        $0.textAlignment = .center
        $0.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var trashButton = UIButton().then {
        $0.setImage(UIImage(named: "record-trash"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(btnRecord(_:)), for: .touchUpInside)
    }
    
    lazy var completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.addTarget(self, action: #selector(completedButtonPressed(_:)), for: .touchUpInside)
    }
    
    weak var bottomSheetViewController: BottomSheetViewController?
    //var fileURLs : [URL] = []
    var recordings: [Recording] = []
    
    //    var audioFile : URL! // 재생할 오디오의 파일명 변수
    //    var audioRecorder : AVAudioRecorder!
    var progressTimer : Timer? //타이머를 위한 변수
    
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
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        requestSpeechRecognitionAuthorization()
        setRecord()
    }
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        super.viewDidAppear(animated)
        configureView()
        startRecording()
    }
    
    
    func setRecord() {
        AudioRecorderManager.shared.setupRecorder()
    }
    
    func startRecording() {
        print(#function, "녹음 시작")
        AudioRecorderManager.shared.startRecording()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateRecordTime), userInfo: nil, repeats: true)
    }
    
    // 00:00 형태의 문자열로 변환
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let milliSec = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        
        let strTime = String(format: "%02d:%02d.%02d", min, sec, milliSec)
        return strTime
    }
    
    //녹음 모드일 때 호출되는 함수
    @objc func btnRecord(_ sender: UIButton) {
        print(#function)
        recordButton.isSelected.toggle()
        if recordButton.isSelected {
            print("recordButtonTapped: 녹음 중지")
            AudioRecorderManager.shared.pauseRecording()
            progressTimer?.invalidate()
            progressTimer = nil
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        } else {
            print("recordButtonTapped: 녹음 시작")
            AudioRecorderManager.shared.startRecording()
            progressTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateRecordTime), userInfo: nil, repeats: true)
            recordButton.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        }
        
    }
    
    //0.1초마다 호출되어 녹음 시간 표시
    @objc func updateRecordTime() {
        guard let audioRecorder = AudioRecorderManager.shared.audioRecorder else { return }
        timeLabel.text = convertNSTimeInterval2String(audioRecorder.currentTime)
        audioRecorder.updateMeters()
        let currentAmplitude = 1 - pow(10, audioRecorder.averagePower(forChannel: 0) / 20)
        waveFormView.add(sample: currentAmplitude)
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        bottomSheetViewController?.hideBottomSheetAndGoBack()
    }
    
    // 완료 버튼 클릭 시
    @objc func completedButtonPressed(_ sender: UIButton) {
        print("완료 버튼 클릭")
        guard let recordTime = getRecordTime() else { return }
        AudioRecorderManager.shared.stopRecording() // 녹음 중지
        progressTimer?.invalidate()
        progressTimer = nil
        
        
        guard let recordUrl = AudioRecorderManager.shared.getRecordURL() else { return }
        
        let loadingVC = STTLoadingViewController(imjangId: imjangId, fileURL: recordUrl, recordTime: recordTime)
        loadingVC.bottomSheetViewController = bottomSheetViewController
        
        bottomSheetViewController?.transitionToViewController(loadingVC)
    }
    
    private func getRecordTime() -> Int? {
        guard let audioRecorder = AudioRecorderManager.shared.audioRecorder else {
            return nil
        }
        print("currentTime: \(audioRecorder.currentTime)")
        return Int.convertTimeToInt(time: audioRecorder.currentTime)
    }
    
    // 음성 인식 권한 확인
    func requestSpeechRecognitionAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorization granted")
                case .denied:
                    print("Speech recognition authorization denied")
                case .restricted:
                    print("Not allowed on this device")
                case .notDetermined:
                    print("Not determined")
                @unknown default:
                    print("Unknown authorization status")
                }
            }
        }
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        [cancelButton,
         recordLabel,
         timeLabel,
//         recordWaveForm,
         waveFormView,
         limitLabel,
         trashButton,
         recordButton,
         completedButton].forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        // 취소 Button
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(12)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            $0.top.equalTo(bottomSheetView.snp.top).offset(29)
        }
        
        // 녹음 Label
        recordLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(24)
        }
        
        // 시간 Label
        timeLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(recordLabel.snp.bottom).offset(34)
        }
        
        // 파형 ImageView
//        recordWaveForm.snp.makeConstraints {
//            $0.centerX.equalTo(bottomSheetView.snp.centerX)
//            $0.top.equalTo(timeLabel.snp.bottom).offset(25)
//        }
        
        waveFormView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(timeLabel.snp.bottom).offset(24)
            make.height.equalTo(50)
        }
        
        // 제한 문구 Label
        limitLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(waveFormView.snp.bottom).offset(28)
        }
        
        // 휴지통 Button
        trashButton.snp.makeConstraints {
            $0.top.equalTo(limitLabel.snp.bottom).offset(48)
            $0.trailing.equalTo(recordButton.snp.leading).offset(-90)
        }
        
        // 녹음 Button
        recordButton.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(limitLabel.snp.bottom).offset(35)
        }
        
        // 완료 Button
        completedButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(90)
            $0.top.equalTo(limitLabel.snp.bottom).offset(54)
            $0.height.equalTo(24)
        }
    }
    
    private func configureView() {
        waveFormView.shouldDrawSilencePadding = true
        waveFormView.configuration = waveFormView.configuration.with(backgroundColor: ColorStyle.textBlack, style: .striped(.init(color: ColorStyle.mainOrange, width: 3, spacing: 3)), damping: waveFormView.configuration.damping?.with(percentage: 0.25, sides: .both))
    }
}
