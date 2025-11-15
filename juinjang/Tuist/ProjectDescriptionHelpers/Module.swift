//
//  Module.swift
//  Manifests
//
//  Created by KimDongWoo on 8/29/25.
//

import ProjectDescription

// MARK: - Module
public enum Module: Sendable, Equatable {
    case app
    case core
    case data
    case domain
    case designSystem
    case presentation
    case spm(SPM) 
}
