//
//  RequestTask.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

enum RequestTask {
    case requestPlain
    case requestQuery(Encodable)
    case requestBody(Encodable)
}
