//
//  BuildConfig.swift
//  juinjang
//
//  Created by 조유진 on 8/12/25.
//

public enum BuildConfig {
    public static var isDebug: Bool {
        #if DEBUG || DEV
        return true
        #else
        return false
        #endif
    }

    public static var isRelease: Bool { !isDebug }
}
