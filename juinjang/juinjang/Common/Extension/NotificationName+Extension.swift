//
//  NotificationName+Extension.swift
//  juinjang
//
//  Created by 조유진 on 5/25/24.
//

import Foundation

extension Notification.Name {
    static let editRecordName: Notification.Name = Notification.Name("editRecordName")
    static let editRecordScript: Notification.Name = Notification.Name("editRecordScript")
    static let addRecordResponse: Notification.Name = Notification.Name("addRecordResponse")
    static let removeRecordResponse: Notification.Name = Notification.Name("removeRecordResponse")
    static let refreshTokenExpired: Notification.Name = Notification.Name("refreshTokenExpired")
    static let refreshMainImjang: Notification.Name = Notification.Name("refreshMainImjang")
    static let refreshImjangList: Notification.Name = Notification.Name("refreshImjangList")
    static let refreshSearchList: Notification.Name = Notification.Name("refreshSearchList")
}
