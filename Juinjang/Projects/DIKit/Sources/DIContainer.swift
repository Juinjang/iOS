//
//  DIContainer.swift
//  DIKit
//
//  Created by 조유진 on 2/14/26.
//

import Foundation

public class DIContainer {
    public static let shared = DIContainer()
    
    private var instances: [ObjectIdentifier: Any] = [:]
    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private let lock = NSRecursiveLock()
    
    private init() {}
    
    // MARK: - Register
    
    // 이미 생성된 인스턴스를 singleton으로 등록
    public func register<T>(instance: T) {
        let key = ObjectIdentifier(T.self)
        
        lock.lock()
        defer { lock.unlock() }
        
        instances[key] = instance
        print("[DIContainer] \(T.self) 인스턴스 등록")
    }
    
    // 팩토리를 lazy singleton 형태로 등록
    public func register<T>(factory: @escaping () -> T) {
        let key = ObjectIdentifier(T.self)
        
        lock.lock()
        defer { lock.unlock() }
        
        factories[key] = { factory() as Any }
    }
    
    // MARK: - Resolve
    
    public func resolve<T>() -> T {
        let key = ObjectIdentifier(T.self)
        
        lock.lock()
        defer { lock.unlock() }
        
        // (1) 이미 생성된 인스턴스가 있다면 반환
        if let instance = instances[key] as? T { return instance }
        
        // (2) 팩토리가 있다면 lazy 생성 후 캐싱
        if let factory = factories[key],
           let instance = factory() as? T {
            instances[key] = instance
            factories.removeValue(forKey: key)
            print("[DIContainer] \(T.self) 팩토리 Lazy 생성 & 캐싱")
            return instance
        }
        
        fatalError("[DIContainer] \(T.self) 없음 🙀")
    }
}
