//
//  Environment.swift
//  Manifests
//
//  Created by KimDongWoo on 8/29/25.
//

import ProjectDescription

public enum Environment {
    public static let deploymentTarget: DeploymentTargets = .iOS("16.0")
    public static let destinations = Destinations.iOS
    public static let baseBundleId = "com.juinjangteam"
}
