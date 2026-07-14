//
//  FirebaseStoreManager.swift
//  App
//
//  Created by 조유진 on 6/7/26.
//

import FirebaseFirestore
import RxSwift

struct Maintenance: Decodable {
    let needsMaintenance: Bool
    let startDate: Date
    let endDate: Date
}

final class FirebaseStoreManager {
    static let shared = FirebaseStoreManager()
    
    private let store = Firestore.firestore()
    
    func fetchMaintenance(completion: @escaping (Result<Maintenance, Error>) -> Void) {
        let docRef = store.collection("juinjang").document("maintenance")
        
        docRef.getDocument { snapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            do {
                if let snapshot = snapshot, snapshot.exists {
                    let data = try snapshot.data(as: Maintenance.self)
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "NoDocument", code: -1, userInfo: nil)))
                }
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchMaintenanceAsObservable() -> Observable<Maintenance> {
        Observable.create { [weak self] observer in
            guard let self else {
                observer.onError(NSError(domain: "Deallocated", code: -1))
                return Disposables.create()
            }

            self.fetchMaintenance { result in
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
