//
//  Untitled.swift
//  Scenes
//
//  Created by KimDongWoo on 8/26/25.
//

import DomainUsecaseInterfaces
import DomainRepositoryInterfaces
import DomainServices
import DomainUsecases
import DataLogging
import DataStorage

class TempStore {
    let usecase: TempUsecaseProtocol
    
    init(usecase: TempUsecaseProtocol) {
        self.usecase = usecase
    }
}
