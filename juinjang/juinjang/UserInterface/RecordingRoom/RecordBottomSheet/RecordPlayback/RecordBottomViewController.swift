//
//  RecordBottomViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit
import AVFoundation

var recordTime : String!

class RecordBottomViewController: UIViewController, UITextFieldDelegate, AVAudioPlayerDelegate {
    
    weak var topViewController: RecordTopViewController?
    var fileURLs : [URL] = []
    
    var audioFile : URL! // 재생할 오디오의 파일명 변수
    var audioPlayer : AVAudioPlayer! //avaudioplayer인스턴스 변수
    var progressTimer : Timer! //타이머를 위한 변수
    

    lazy var titleTextField = UITextField().then {
        $0.text = "\(RecordingFileViewCell().recordingFileNameLabel.text ?? "녹음파일_001")"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "lightGray")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    var recordStartTimeLabel = UILabel().then {
        $0.text = "\(recordTime ?? "오후 4:00")" // - TODO: 녹음 파일 추가할 때의 시간 반영
        $0.textColor = UIColor(named: "gray1")
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    lazy var elapsedTimeLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray1")
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "0:41"
    }
    
    var recordingSlider = UISlider().then {
        $0.setThumbImage(UIImage(named: "slider-thumb"), for: .normal)
        $0.tintColor = UIColor(named: "mainOrange")
        $0.addTarget(self, action: #selector(dragedSlider), for: .valueChanged)
        $0.isUserInteractionEnabled = true
    }
    
    lazy var remainingTimeLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray1")
        $0.font = UIFont(name: "Pretendard-Regular", size: 13)
        $0.text = "4:10"
    }
    
    // 임의로 넣어둠 -TODO: 음성 녹음 파일 연결 필요
//    var player: AVPlayer = {
//        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else { fatalError() }
//        let player = AVPlayer()
//        let playerItem = AVPlayerItem(url: url)
//        player.replaceCurrentItem(with: playerItem) // AVPlayer는 한번에 하나씩만 다룰 수 있음
//        return player
//    }()
    
    lazy var rewindButton = UIButton().then {
        $0.setImage(UIImage(named: "rewind"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var fastForwardButton = UIButton().then {
        $0.setImage(UIImage(named: "fast-forward"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        titleTextField.delegate = self
        
        loadRecordings()
        playSet()
        audioPlayer.stop()
        audioPlayer.play()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime), userInfo: nil, repeats: true)
    }
    
    func loadRecordings() {
       let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       do {
           // 문서 디렉토리에서 녹음 파일들을 가져옴
           let recordingURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
           // 녹음 파일 목록에 추가
           fileURLs = recordingURLs.filter { $0.pathExtension == "m4a" } // .m4a 확장자를 가진 파일만 필터링
       } catch {
           print("Failed to load recordings: \(error)")
       }
   }
    func playSet() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioFile = documentDirectory.appendingPathComponent("recordfile\(fileURLs.count-1).m4a")
        //audioFile = Bundle.main.url(forResource: "Cruel Summer", withExtension: "mp3")
        initPlay()
    }
    
    func initPlay(){
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
    @objc func updatePlayTime() {
        elapsedTimeLabel.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        //pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
        recordingSlider.value = Float(audioPlayer.currentTime / audioPlayer.duration)
        if recordingSlider.value == 0 {
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        }
    }
    
    //정지 버튼 클릭 시 음악 재생 종료
    @objc func btnStopAudio(_ sender: UIButton) {
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
//            $0.top.equalTo(elapsedTimeLabel.snp.bottom).offset(68)
            $0.trailing.equalTo(recordButton.snp.leading).offset(-40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
        
        recordButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
//            $0.top.equalTo(elapsedTimeLabel.snp.bottom).offset(56)
            $0.bottom.equalTo(view.snp.bottom).offset(-76)
        }
        
        fastForwardButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(40)
//            $0.top.equalTo(elapsedTimeLabel.snp.bottom).offset(68)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드가 수정되면 title을 수정
        updateTitle(textField.text)
        topViewController?.updateTitle(textField.text)
    }

    func updateTitle(_ newTitle: String?) {
        if let title = newTitle {
            print("녹음 파일 제목: \(title)")
            titleTextField.text = title
            RecordingFileViewCell().recordingFileNameLabel.text = title
        }
    }
    
    @objc func startRecordPressed(_ sender: UIButton) {
        if recordButton.isSelected {
            audioPlayer.play()
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updatePlayTime), userInfo: nil, repeats: true)
            recordButton.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        } else {
            audioPlayer.pause()
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        }
        recordButton.isSelected.toggle()
    }
    
    @objc private func dragedSlider() {
        //audioPlayer.currentTime = TimeInterval(recordingSlider.value)
        let newTime = TimeInterval(recordingSlider.value) * audioPlayer.duration
        audioPlayer.currentTime = newTime
    }
}
