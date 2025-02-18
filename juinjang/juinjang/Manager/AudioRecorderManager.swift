//
//  AudioRecorderManager.swift
//  juinjang
//
//  Created by 조유진 on 5/19/24.
//

import Foundation
import AVFoundation

final class AudioRecorderManager: NSObject {
    static let shared = AudioRecorderManager()
    
    var audioRecorder: AVAudioRecorder? // 음성 녹음 객체
    var isRecording = false
    var isRecordingPaused = false
}

extension AudioRecorderManager {
    func setupRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            session.requestRecordPermission { allowed in
                print(allowed)
            }
        } catch {
            print("세션 설정 실패")
        }
        
        let fileURL = getDocumentsDirectory().appendingPathComponent("recording-\(Date().timeIntervalSince1970).m4a")
        print(fileURL)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print("레코더 설정 실패")
        }
    }
    
    // 녹음 시작
    func startRecording() {
        print(#function)
        if let audioRecorder, !audioRecorder.isRecording {
            audioRecorder.record()
            isRecording = true
            isRecordingPaused = false
        }
    }
    
    func pauseRecording() {
        print(#function)
        if let audioRecorder, audioRecorder.isRecording {
            audioRecorder.pause()
            isRecording = false
            isRecordingPaused = true
        }
    }
    
    func stopRecording() {
        print(#function)
        if let audioRecorder {
            audioRecorder.stop()
            isRecording = false
            isRecordingPaused = false
        }
    }
    
    func getRecordURL() -> URL? {
        guard let audioRecorder else { return nil }
        print(audioRecorder.url)
        return audioRecorder.url
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

