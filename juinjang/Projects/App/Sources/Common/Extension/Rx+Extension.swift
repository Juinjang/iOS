//
//  Rx+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/22/25.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIButton {
    var throttleTap: Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(500),
                      latest: false,
                      scheduler: MainScheduler.instance)
    }
}
