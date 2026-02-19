//
//  PlayTimeTracker.swift
//  juinjang
//
//  Created by 조유진 on 6/22/25.
//

import UIKit

/// 1️⃣ 플레이타임 트래커
final class PlayTimeTracker {
    static let shared = PlayTimeTracker()
    
    private let userDefaultsKey = "totalPlayTime"
    private var sessionStart: Date?
    private(set) var totalPlayTime: TimeInterval = 0
    
    private init() {
        totalPlayTime = UserDefaults.standard.double(forKey: userDefaultsKey)
        registerLifecycleNotifications()
    }
    
    private func registerLifecycleNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func handleDidBecomeActive() {
        sessionStart = Date()
    }
    
    @objc private func handleWillResignActive() {
        guard let start = sessionStart else { return }
        let interval = Date().timeIntervalSince(start)
        totalPlayTime += interval
        sessionStart = nil
        save()
    }
    
    private func save() {
        UserDefaults.standard.set(Int(totalPlayTime) / 60, forKey: userDefaultsKey)
    }
    
    
    func getPlayTime() -> TimeInterval {
        if let start = sessionStart {
            return totalPlayTime + Date().timeIntervalSince(start)
        }
        return totalPlayTime
    }
}
