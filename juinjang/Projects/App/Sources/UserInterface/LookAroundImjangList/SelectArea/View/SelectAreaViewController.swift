//
//  SelectAreaViewController.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SelectAreaViewController: BaseViewController {
    private let mainView = SelectAreaView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        view = mainView
    }
}
