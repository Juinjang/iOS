//
//  BuildConfig.swift
//  juinjang
//
//  Created by 조유진 on 8/12/25.
//

enum BuildConfig {
    static var isDebug: Bool {
        #if DEBUG || DEV
        return true
        #else
        return false
        #endif
    }

    static var isRelease: Bool { !isDebug }
}
