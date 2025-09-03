//
//  Untitled.swift
//  Scenes
//
//  Created by KimDongWoo on 8/26/25.
//

import DomainUsecaseInterfaces

class TempStore {
    let usecase: TempUsecaseProtocol
    
    init(usecase: TempUsecaseProtocol) {
        self.usecase = usecase
    }
}
