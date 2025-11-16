//
//  AnalyticsManager.swift
//  Common
//
//  Created by 강동영 on 3/17/25.
//


import FirebaseAnalytics

public struct AnalyticsManager: Sendable {
    public static func log(event: some AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
