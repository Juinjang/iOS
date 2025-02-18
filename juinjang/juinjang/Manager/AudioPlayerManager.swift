//
//  AudioPlayerManager.swift
//  juinjang
//
//  Created by 조유진 on 5/22/24.
//

import Foundation
import AVFoundation

final class AudioPlayerManager: NSObject {
    
    var audioPlayer: AVPlayer?     // 음성 재생 객체
    
    deinit {
        print(String(String(describing: self)), "deinit")
        resetPlayer()
    }
    
    // 재생 시작
    func setPlayer(recordingURL: URL) {
        audioPlayer = AVPlayer(url: recordingURL)
        audioPlayer?.actionAtItemEnd = .pause
    }
    
    func resetPlayer() {
        stopPlaying()
        audioPlayer = nil
    }
    
    func stopPlaying() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: CMTime.zero)
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
    }
    
    func startPlaying() {
        audioPlayer?.play()
    }
    
    func getCurrentTime() -> TimeInterval? {
        guard let audioPlayer else { return nil }
        let currentTime = audioPlayer.currentTime()
        return CMTimeGetSeconds(currentTime)
    }
    
    func getDuration() -> TimeInterval? {
        guard let audioPlayer, let duration = audioPlayer.currentItem?.duration else { return nil }
        print(#function, duration)
        return CMTimeGetSeconds(duration)
    }
    
    func setCurrentTime(time: TimeInterval) {
        guard let audioPlayer else { return }
        let cmTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        audioPlayer.seek(to: cmTime) { completed in
           if completed {
               print("Successfully seeked to time: \(time) seconds")
           } else {
               print("Failed to seek to time: \(time) seconds")
           }
       }
    }
}
