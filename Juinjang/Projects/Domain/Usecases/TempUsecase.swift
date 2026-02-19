//
//  Untitled.swift
//  Domain
//
//  Created by KimDongWoo on 8/26/25.
//

import DomainServices
import DomainUsecaseInterfaces

internal class TempUsecase: TempUsecaseProtocol {
    private let temp = TempService()
}
