//
//  AudioRecorder.swift
//  juinjang
//
//  Created by 박도연 on 5/21/24.
//

import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    
    func startRecording() -> URL? {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            return audioFilename
        } catch {
            stopRecording(success: false)
            return nil
        }
    }
    
    func stopRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil

        if !success {
            // Handle failure
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

