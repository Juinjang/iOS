//
//  RecordBottomViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit
import AVFoundation

final class RecordBottomViewController: BaseViewController, UITextFieldDelegate, AVAudioPlayerDelegate {

    lazy var titleTextField = UITextField().then {
        $0.text = "녹음파일_001"
        $0.textAlignment = .center
        $0.textColor = .null
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    var recordStartTimeLabel = UILabel().then {
//        $0.text = "\(recordTime ?? "오후 4:00")" // - TODO: 녹음 파일 추가할 때의 시간 반영
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    lazy var elapsedTimeLabel = UILabel().then {
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "0:00"
    }
    
    var recordingSlider = UISlider().then {
        $0.setThumbImage(UIImage.Recording.sliderThumb, for: .normal)
        $0.tintColor = .main
        $0.addTarget(self, action: #selector(dragedSlider), for: .valueChanged)
        $0.isUserInteractionEnabled = true
    }
    
    lazy var remainingTimeLabel = UILabel().then {
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "0:00"
    }
    
    lazy var rewindButton = UIButton().then {
        $0.setImage(UIImage.Recording.rewind, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(rewindButtonTapped), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var playButton = UIButton().then {
        $0.setImage(UIImage.Recording.record, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var fastForwardButton = UIButton().then {
        $0.setImage(UIImage.Recording.fastForward, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(fastForwardButtonTapped), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false
    }
    
    weak var topViewController: RecordTopViewController?
    
    var progressTimer : Timer? //타이머를 위한 변수
    var recordTime : String = ""
    var recordResponse: RecordResponse
    let playerManager = AudioPlayerManager()
    
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressTimer?.invalidate()
        progressTimer = nil
        playerManager.stopPlaying()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray500
        addSubViews()
        setupLayout()
        titleTextField.delegate = self

        setRecordData()
        initPlay()
    }
    
    private func setRecordData() {
        titleTextField.text = recordResponse.recordName
        recordStartTimeLabel.text = DateFormatterManager.shared.formattedUpdatedDate(recordResponse.createdAt)
        remainingTimeLabel.text = String.formatSeconds(recordResponse.recordTime + 1)
    }
    
    func initPlay(){
        guard let recordUrl = URL(string: recordResponse.recordUrl) else { return }
        playerManager.setPlayer(recordingURL: recordUrl)
        
        recordingSlider.value = 0
    }
    
    @objc func updatePlayTime() {
        guard let currentTime = playerManager.getCurrentTime(), let duration = playerManager.getDuration() else { return }
        elapsedTimeLabel.text = String.formatSeconds(Int(currentTime))
        recordingSlider.value = Float(currentTime / duration)
        if currentTime == duration {
            recordingSlider.value = 0
            elapsedTimeLabel.text = String.formatSeconds(0)
            playerManager.setCurrentTime(time: 0)
            playButton.setImage(UIImage.Recording.record, for: .normal)
            playButton.isSelected.toggle()
            progressTimer?.invalidate()
            progressTimer = nil
        }
    }
    
    // 녹음 파일 이름 수정 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let editedRecordName = textField.text else {
            return
        }
        let trimmedEditedReocrdName = editedRecordName.trimmingCharacters(in: [" "])
        if trimmedEditedReocrdName.isEmpty {
            textField.text = recordResponse.recordName
        } else {
            recordResponse.recordName = trimmedEditedReocrdName
            editRecordName(trimmedEditedReocrdName)
            topViewController?.editTitle(trimmedEditedReocrdName)
        }
    }
    
    private func editRecordName(_ editedRecordName: String) {
        let parameter = ["recordName": editedRecordName]
        JuinjangAPIManager.shared.postData(type: BaseResponse<RecordResponse?>.self, api: .editRecordName(recordId: recordResponse.recordId, recordName: editedRecordName), parameter: parameter) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                print("post editRecordName")
                NotificationCenter.default.post(name: .editRecordName, object: recordResponse)
            } else {
                guard let error = error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    @objc func startRecordPressed(_ sender: UIButton) {
        playButton.isSelected.toggle()
        if playButton.isSelected {
            playerManager.startPlaying()
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime), userInfo: nil, repeats: true)
            playButton.setImage(UIImage.Recording.beingRecorded, for: .normal)
        } else {
            playerManager.pausePlaying()
            progressTimer?.invalidate()
            progressTimer = nil
            playButton.setImage(UIImage.Recording.record, for: .normal)
        }
    }
    
    @objc private func dragedSlider() {
        guard let duration = playerManager.getDuration() else { return }
        let newTime = TimeInterval(recordingSlider.value) * duration
        playerManager.setCurrentTime(time: newTime)
    }
    
    @objc private func rewindButtonTapped() {
        guard let currentTime = playerManager.getCurrentTime(), let duration = playerManager.getDuration() else { return }
        var rewindValue = currentTime - 10
        if rewindValue < 0 {
            rewindValue = 0
        }
        playerManager.setCurrentTime(time: rewindValue)
        elapsedTimeLabel.text = String.formatSeconds(Int(rewindValue))
        recordingSlider.value = Float(rewindValue / duration)
    }
    
    @objc private func fastForwardButtonTapped() {
        guard let currentTime = playerManager.getCurrentTime(), let duration = playerManager.getDuration() else { return }
        var fastForwardValue = currentTime + 10
        if fastForwardValue > duration {
            fastForwardValue = duration
        }
        playerManager.setCurrentTime(time: fastForwardValue)
        elapsedTimeLabel.text = String.formatSeconds(Int(fastForwardValue))
        recordingSlider.value = Float(fastForwardValue / duration)
    }
    
    func addSubViews() {
        [titleTextField,
         recordStartTimeLabel,
         recordingSlider,
         elapsedTimeLabel,
         remainingTimeLabel,
         rewindButton,
         playButton,
         fastForwardButton].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        titleTextField.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top).offset(24)
        }
        
        recordStartTimeLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
        }
        
        recordingSlider.snp.makeConstraints {
            $0.top.equalTo(recordStartTimeLabel.snp.bottom).offset(56)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        elapsedTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recordingSlider.snp.bottom).offset(12)
            $0.left.equalTo(recordingSlider)
        }
        
        remainingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recordingSlider.snp.bottom).offset(12)
            $0.right.equalTo(recordingSlider)
        }
        
        rewindButton.snp.makeConstraints {
            $0.trailing.equalTo(playButton.snp.leading).offset(-40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
        
        playButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.snp.bottom).offset(-76)
        }
        
        fastForwardButton.snp.makeConstraints {
            $0.leading.equalTo(playButton.snp.trailing).offset(40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
    }
}
