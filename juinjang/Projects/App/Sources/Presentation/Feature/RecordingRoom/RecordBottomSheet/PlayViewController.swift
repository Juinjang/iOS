//
//  PlayViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/19/24.
//

import UIKit
import SnapKit
import AVFoundation

final class PlayViewController: BaseViewController, UITextFieldDelegate, AVAudioPlayerDelegate {

    var titleTextField = UITextField().then {
        $0.text = "녹음파일_001"
        $0.textAlignment = .center
        $0.textColor = .null
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    var recordStartTimeLabel = UILabel().then {
//        $0.text = "\(recordTime)" // - TODO: 녹음 파일 추가할 때의 시간 반영
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    lazy var elapsedTimeLabel = UILabel().then {
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "0:41"
    }
    
    var recordingSlider = UISlider().then {
        $0.setThumbImage(UIImage.Recording.sliderThumb, for: .normal)
        $0.tintColor = .main
        $0.isUserInteractionEnabled = true
    }
    
    lazy var remainingTimeLabel = UILabel().then {
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "4:10"
    }
    
    lazy var rewindButton = UIButton().then {
        $0.setImage(UIImage.Recording.rewind, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage.Recording.record, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var fastForwardButton = UIButton().then {
        $0.setImage(UIImage.Recording.fastForward, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    
    weak var topViewController: RecordTopViewController?
    var recordingIndexPath: IndexPath?
    
    var audioFile : URL! // 재생할 오디오의 파일명 변수
    var audioPlayer : AVAudioPlayer! //avaudioplayer인스턴스 변수
    var progressTimer : Timer! //타이머를 위한 변수
    //var recordResponse: RecordResponse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray500
        addSubViews()
        setupLayout()
        titleTextField.delegate = self
        addTarget()
        initPlay1()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime1), userInfo: nil, repeats: true)
    }
    
    private func addTarget() {
        recordingSlider.addTarget(self, action: #selector(dragedSlider), for: .valueChanged)
    }
    
    func initPlay1(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-iniPlay : \(error)")
        }
        
        recordingSlider.value = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
        
        remainingTimeLabel.text = convertNSTimeInterval2String(audioPlayer.duration)
        elapsedTimeLabel.text = convertNSTimeInterval2String(0)
    }
    
    // 00:00 형태의 문자열로 변환
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    //0.1초마다 호출되어 재생 시간 표시
    @objc func updatePlayTime1() {
        elapsedTimeLabel.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        //pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
        recordingSlider.value = Float(audioPlayer.currentTime / audioPlayer.duration)
        if recordingSlider.value == 0 {
            recordButton.setImage(UIImage.Recording.record, for: .normal)
        }
    }
    
    //정지 버튼 클릭 시 음악 재생 종료
    @objc func btnStopAudio1(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        elapsedTimeLabel.text = convertNSTimeInterval2String(0)
        progressTimer.invalidate()
    }
    
    func addSubViews() {
        [titleTextField,
         recordStartTimeLabel,
         recordingSlider,
         elapsedTimeLabel,
         remainingTimeLabel,
         rewindButton,
         recordButton,
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
            $0.trailing.equalTo(recordButton.snp.leading).offset(-40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
        
        recordButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.snp.bottom).offset(-76)
        }
        
        fastForwardButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드가 수정되면 title을 수정
        updateTitle(textField.text)
        updateRecordingTitle(textField.text)
//        topViewController?.updateTitle(textField.text)
    }
    
    func updateRecordingTitle(_ newTitle: String?) {
        guard let indexPath = recordingIndexPath else { return }
        print(indexPath)
        print(indexPath.row)
//        print(recordings)
//        recordings[indexPath.row].title = newTitle!
//        print("실행 됨\(recordings)")
    }

    func updateTitle(_ newTitle: String?) {
        if let title = newTitle {
            print("녹음 파일 제목: \(title)")
            titleTextField.text = title
        }
    }
    
    
    @objc func startRecordPressed(_ sender: UIButton) {
        if recordButton.isSelected {
            audioPlayer.play()
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime1), userInfo: nil, repeats: true)
            recordButton.setImage(UIImage.Recording.beingRecorded, for: .normal)
        } else {
            audioPlayer.pause()
            recordButton.setImage(UIImage.Recording.record, for: .normal)
        }
        recordButton.isSelected.toggle()
    }
    
    @objc private func dragedSlider() {
        //audioPlayer.currentTime = TimeInterval(recordingSlider.v
        let newTime = TimeInterval(recordingSlider.value) * audioPlayer.duration
        audioPlayer.currentTime = newTime
    }
}

