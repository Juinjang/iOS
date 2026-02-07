//
//  Project+Extensions.swift
//  Manifests
//
//  Created by KimDongWoo on 9/1/25.
//

import ProjectDescription

extension Project {
    public init(moduleType: Module,
                targets: [Target]) {
        self.init(
            name: moduleType.moduleName,
            targets: targets
        )
    }
}
