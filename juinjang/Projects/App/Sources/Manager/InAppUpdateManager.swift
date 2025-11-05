//
//  InAppUpdateManager.swift
//  juinjang
//
//  Created by 조유진 on 8/9/25.
//

import Foundation
import UIKit
import RxSwift

final class InAppUpdateManager {
    static let shared = InAppUpdateManager()
    
    private init() { }
    
    private struct AppStoreLookupResponse: Decodable {
        struct Result: Decodable { let version: String? }
        let results: [Result]
    }

    func requestLatestVersion() -> Single<String?> {
        return Single<String?>.create { observer in
            guard
                let url = URL(string: APIKey.appStoreVersionURL),
                let _ = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else {
                observer(.success(nil))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data,
                      let response = try? JSONDecoder().decode(AppStoreLookupResponse.self, from: data),
                      let appStoreVersion = response.results.first?.version else {
                    observer(.success(nil))
                    return
                }
                observer(.success(appStoreVersion))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }

      
    //버전 업데이트 체크
    func isNeedAppUpdate(latestVersion: String) -> Bool {
        guard let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        if compareVersion(currentVersion: currentAppVersion, latestVersion: latestVersion) {
            return true
        } else {
            return false
        }
    }
    
    // 업데이트 해야되면 true 반환
    private func compareVersion(currentVersion: String, latestVersion: String) -> Bool {
        return currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending
    }
    
    // 앱 스토어로 이동
    func openAppStore() {
        guard let url = URL(string: APIKey.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
