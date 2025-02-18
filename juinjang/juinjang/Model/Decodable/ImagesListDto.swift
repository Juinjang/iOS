//
//  ImagesListDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ImagesListDto: Codable {
    let images: [ImageDto]
}

struct ImageDto: Codable {
    let imageId: Int
    let imageUrl: String
}
