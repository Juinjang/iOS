//
//  OpenNewPageImageType.swift
//  juinjang
//
//  Created by 강동영 on 2/22/25.
//

import UIKit

public enum OpenNewPageImageType {
    case investor
    case userMovingInDirectly
    case apartment
    case villa
    case officetel
    case house
    
    // DesignSystem으로 이동 필요
    public var image: UIImage {
        switch self {
        case .investor:
            UIImage.OpenNewPage.investor
        case .userMovingInDirectly:
            UIImage.OpenNewPage.userMovingInDirectly
        case .apartment:
            UIImage.OpenNewPage.apartment
        case .villa:
            UIImage.OpenNewPage.villa
        case .officetel:
            UIImage.OpenNewPage.officetel
        case .house:
            UIImage.OpenNewPage.house
        }
    }
}
