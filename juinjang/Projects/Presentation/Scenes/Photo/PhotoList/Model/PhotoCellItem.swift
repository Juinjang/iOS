//
//  PhotoCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/24/25.
//

final class PhotoCellItem: BaseCellItem {
    let imageUrl: String
    
    init(id: String,
         imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(id: id)
    }
}

extension PhotoCellItem {
    func toDTO() -> ImageDto {
        return ImageDto(imageId: Int(id) ?? 0, imageUrl: imageUrl)
    }
}
