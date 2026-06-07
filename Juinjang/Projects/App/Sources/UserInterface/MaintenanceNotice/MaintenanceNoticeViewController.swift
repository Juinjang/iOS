//
//  MaintenanceNoticeViewController.swift
//  App
//
//  Created by 조유진 on 6/7/26.
//

import UIKit
import ReactorKit

final class MaintenanceNoticeViewController: UIViewController {
    private let contentView = MaintenanceNoticeView()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseStoreManager.shared.fetchMaintenanceAsObservable()
            .asObservable()
            .subscribe(with: self) { owner, maintenance in
                owner.contentView.configureDurationDate(
                    startDate: maintenance.startDate,
                    endDate: maintenance.endDate
                )
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = contentView
    }
    
}
