//
//  ModelMappable.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

public protocol DomainMappable {
    associatedtype Model
    func toDomain() -> Model
}

public protocol PresentationMappable {
    associatedtype Model
    func toPresentation() -> Model
}
