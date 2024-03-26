//
//  PlayAndRecordViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/18/24.
//

import AVFoundation
import UIKit

class PlayAndRecordViewController : UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    //    var aRecorder : AVAudioRecorder!
    //    var recFile : URL!
    //    var aPlayer : AVAudioPlayer!
    //    var playFile : URL!
    //    var timer : Timer!
    //    var isRecorderMode
    //
    //    func recordSet() {
    //        let docDic = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //        recFile = docDic.appendingPathComponent("recFile.m4a")
    //
    //        let rSettings = [
    //            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
    //            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
    //            AVEncoderBitRateKey : 320000,
    //            AVNumberOfChannelsKey : 2,
    //            AVSampleRateKey : 44100.0] as [String : Any]
    //
    //        do {
    //            aRecorder = try AVAudioRecorder(url: recFile, settings: rSettings)
    //        } catch let error as NSError {
    //            print("Error-initRecord : \(error)")
    //        }
    //
    //        aRecorder.delegate = self
    //    }
    //
    //    func record() {
    //        let session = AVAudioSession.sharedInstance()
    //        do {
    //            try session.setCategory(.playAndRecord, mode: .default)
    //            try session.setActive(true)
    //        } catch let error as NSError {
    //            print("AVAudioSession : \(error)")
    //        }
    //    }
    //
    //    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    //
    //    }
    //
    //
    //
    //    func playSet() {
    //        playFile = Bundle.main.url(forResource: "Cruel Summer", withExtension: "mp3")
    //        let asession = AVAudioSession.sharedInstance()
    //        do {
    //            try asession.setCategory(.playAndRecord, mode: .default)
    //            try asession.setActive(true)
    //        } catch let error as NSError {
    //            print("aSession : \(error)")
    //        }
    //    }
    var audioPlayer : AVAudioPlayer! //avaudioplayer인스턴스 변수
    var audioFile : URL! // 재생할 오디오의 파일명 변수
    let MAX_VOLUME : Float = 10.0 //최대 불륨, 실수형 상수
    var progressTimer : Timer! //타이머를 위한 변수
    let timePlayerSelector:Selector = #selector(PlayAndRecordViewController.updatePlayTime)
    let timeRecordSelector:Selector = #selector(PlayAndRecordViewController.updateRecordTime)
    
    //재생 아웃렛 변수
    @IBOutlet weak var pvProgressPlay: UIProgressView!
    @IBOutlet weak var lbCurrentTime: UILabel!
    
    @IBOutlet weak var lbEndTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var slVolume: UISlider!
    
    //녹음 아웃렛 변수
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lbRecordTime: UILabel!
    var audioRecorder : AVAudioRecorder!
    var isRecorderMode = false //현재는 재생 모드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectAudioFile()
        if !isRecorderMode{ //재생 모드일 때
            initPlay()
            btnRecord.isEnabled = false
            lbRecordTime.isEnabled = false
        } else { // 녹음 모드일 때
            initRecord()
        }
    }
    
    
    
    // 재생 모드와 녹음 모드에 따라 다른 파일을 선택하는 함수
    func selectAudioFile(){
        if !isRecorderMode {
            audioFile = Bundle.main.url(forResource: "Cruel Summer", withExtension: "mp3")
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
        }
    }
    
    func initPlay(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-iniPlay : \(error)")
        }
        
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
        
        lbEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lbCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, stop: false)
    }
    
    //재생 모드의 버튼들을 활성화, 비활성화 하는 함수
    func setPlayButtons(_ play:Bool, pause:Bool, stop:Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    
    // 00:00 형태의 문자열로 변환
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //재생 버튼 클릭 시 음악 재생
    @objc func btnPlayAudio() {
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    
    //0.1초마다 호출되어 재생 시간 표시
    @objc func updatePlayTime() {
        lbCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    
    //일시 정지 버튼 클릭 시 음악 일시정지
    @objc func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
    }
    
    //정지 버튼 클릭 시 음악 재생 종료
    @objc func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        setPlayButtons(true, pause: false, stop: false)
        lbCurrentTime.text = convertNSTimeInterval2String(0)
        progressTimer.invalidate()
    }
    
    //볼륨 슬라이더 값을 실제 볼륨 값에 대입
    @objc func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    
    // 재생이 종료되었을 때 호출하는 함수
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        progressTimer.invalidate()
        setPlayButtons(true, pause:false, stop: false)
    }
    
    //스위치를 통한 녹음, 재생 모드 변환
    @objc func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lbRecordTime!.text = convertNSTimeInterval2String(0)
            isRecorderMode = true
            btnRecord.isEnabled = true
            lbRecordTime.isEnabled = true
        } else {
            isRecorderMode = false
            btnRecord.isEnabled = false
            lbRecordTime.isEnabled = false
            lbRecordTime.text = convertNSTimeInterval2String(0)
        }
        selectAudioFile()
        if !isRecorderMode {
            initPlay()
        } else {
            initRecord()
        }
    }
    
    //녹음 모드일 때 호출되는 함수
    @objc func btnRecord(_ sender: UIButton) {
        if (sender as AnyObject).titleLabel?.text == "Record" {//녹음을 종료하는 함수
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
        } else {//녹음을 위한 초기화를 진행하는 함수
            audioRecorder.stop()
            progressTimer.invalidate()
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
        }
    }
    
    //0.1초마다 호출되어 녹음 시간 표시
    @objc func updateRecordTime() {
        lbRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
    }


    // 녹음 모드 초기화
    func initRecord(){
        let recordSettings = [
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0] as [String : Any]
            do {
                audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
            } catch let error as NSError {
                print("Error-initRecord : \(error)")
            }
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        
        slVolume.value = 1.0
        audioPlayer.volume = slVolume.value
        lbEndTime.text = convertNSTimeInterval2String(0)
        lbCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(false, pause: false, stop: false)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActive : \(error)")
        }
    }
}
