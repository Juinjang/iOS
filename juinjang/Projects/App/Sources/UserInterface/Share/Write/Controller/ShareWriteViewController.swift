//
//  ShareWriteViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 5/3/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

final class ShareWriteViewController: BaseViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let mainView = ShareWriteView()
    
    init(reactor: ShareWriteViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func bind(reactor: ShareWriteViewReactor) {
        
    }
}
