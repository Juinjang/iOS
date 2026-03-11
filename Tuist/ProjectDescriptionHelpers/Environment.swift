//
//  Environment.swift
//  Manifests
//
//  Created by 조유진 on 3/11/26.
//

import ProjectDescription

public enum Environment {
    public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
    public static let destinations: Destinations = [.iPhone]
    public static let appVersion = "3.0.0"
    public static let build = "1"
    public static let baseBundleId = "com.juinjangteam"
}
