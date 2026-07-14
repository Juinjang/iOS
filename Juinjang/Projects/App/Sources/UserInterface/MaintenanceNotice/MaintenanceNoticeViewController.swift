//
//  MaintenanceNoticeViewController.swift
//  App
//
//  Created by 조유진 on 6/7/26.
//

import UIKit

final class MaintenanceNoticeViewController: UIViewController {
    private let contentView = MaintenanceNoticeView()
    
    private let maintenance: Maintenance
    
    // MARK: - Init
     
    init(maintenance: Maintenance) {
        self.maintenance = maintenance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.configureDurationDate(
            startDate: maintenance.startDate,
            endDate: maintenance.endDate
        )
    }
    
    override func loadView() {
        view = contentView
    }
    
}
