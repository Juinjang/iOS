//
//  ImjangShareSelectViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit
import ReactorKit

final class ImjangShareSelectViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let mainView = ImjangShareSelectView()
    
    init(reactor: ImjangShareSelectViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bind(reactor: ImjangShareSelectViewReactor) {
        
    }
}
