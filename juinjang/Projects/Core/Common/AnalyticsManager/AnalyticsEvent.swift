//
//  AnalyticsEvent.swift
//  Common
//
//  Created by 강동영 on 3/17/25.
//


import Foundation

public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any]? { get }
}

public struct MainViewEvent: AnalyticsEvent {
    public enum Name: String {
        case enter_main_view
    }

    public var name: String
    public var parameters: [String: Any]?

    public init(name: Name, parameters: [String: Any]? = nil) {
        self.name = name.rawValue
        self.parameters = parameters
    }
}
