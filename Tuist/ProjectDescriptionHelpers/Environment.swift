//
//  Environment.swift
//  Manifests
//
//  Created by 조유진 on 3/11/26.
//

import ProjectDescription
import Foundation

public enum Environment {
    public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
    public static let destinations: Destinations = [.iPhone]
    public static let appVersion = "3.0.0"
    public static let build = "1"
    public static let baseBundleId = "com.juinjangteam"

    /// `tuist generate` 시 `TUIST_CONFIGURATION=Release` 환경 변수가 설정되면 true를 반환합니다.
    public static var isRelease: Bool {
        let config = ProcessInfo.processInfo.environment["TUIST_CONFIGURATION"] ?? ""
        return config.lowercased() == "release"
    }

    /// Debug → .staticFramework / Release → .framework
    public static var moduleProduct: Product {
        isRelease ? .staticFramework : .framework
    }
}
