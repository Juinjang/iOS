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
    func autoToggle(disposeBag: DisposeBag) {
        self.base.rx.throttleTap
            .withUnretained(self.base)
            .subscribe { button, _ in
                button.isSelected.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    var throttleTap: Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(500),
                      latest: false,
                      scheduler: MainScheduler.instance)
    }
}
