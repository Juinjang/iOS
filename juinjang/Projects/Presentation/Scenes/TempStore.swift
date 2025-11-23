//
//  Untitled.swift
//  Scenes
//
//  Created by KimDongWoo on 8/26/25.
//

import DomainUsecaseInterfaces

class TempStore {
    let useCase: TempUsecaseProtocol
    
    init(useCase: TempUsecaseProtocol) {
        self.useCase = useCase
    }
}
