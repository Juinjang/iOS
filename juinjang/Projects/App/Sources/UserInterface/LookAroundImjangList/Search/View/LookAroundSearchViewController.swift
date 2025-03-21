//
//  LookAroundSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 3/21/25.
//

import UIKit

final class LookAroundSearchViewController: BaseViewController {
    private let mainView = LookAroundSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.navigationView.searchTextField.becomeFirstResponder()
    }
}
