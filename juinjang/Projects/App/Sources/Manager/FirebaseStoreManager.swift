//
//  FirebaseStoreManager.swift
//  juinjang
//
//  Created by KimDongWoo on 8/8/25.
//

import FirebaseFirestore
import RxSwift

struct iOSSetting: Decodable {
    let isTesting: Bool
}

final class FirebaseStoreManager {
    static let shared = FirebaseStoreManager()
    
    private let store = Firestore.firestore()
    
    func fetchIOSSetting(completion: @escaping (Result<iOSSetting, Error>) -> Void) {
        let docRef = store.collection("juinjang").document("ios_setting")
        
        docRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let snapshot = snapshot, snapshot.exists {
                    let data = try snapshot.data(as: iOSSetting.self)
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "NoDocument", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchIOSSettingAsObservable() -> Observable<iOSSetting> {
        return Observable.create { observer in
            self.fetchIOSSetting { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
