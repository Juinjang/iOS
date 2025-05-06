//
//  ImjangPeriodView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/5/25.
//

import UIKit
import Then
import SnapKit

struct ImjangPeriod: Equatable {
    var year: String
    var month: String
    var phase: String
}

extension ImjangPeriod {
    static func from(date: Date = Date()) -> ImjangPeriod {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let year = String(components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = components.day ?? 1

        let phase: String
        switch day {
        case 1...10: phase = "초반"
        case 11...20: phase = "중반"
        default: phase = "후반"
        }

        return ImjangPeriod(year: year, month: month, phase: phase)
    }
    
    
}

enum ImjangPeriodType {
    case year(String)
    case month(String)
    case phase(String)
}

final class ImjangPeriodView: BaseView {
    private let baseView = UIView().then {
        $0.backgroundColor = .gray200
        $0.roundCorners(cornerRadius: 15, corner: .all)
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontSize = 24
        $0.fontColor = .gray300
    }
    
    private let subContentLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
    }
    
    
    func configure(model: ImjangPeriodType,
                   isDoneEdit: Bool) {
        isDoneEdit
        ? (contentLabel.fontColor = .main)
        : (contentLabel.fontColor = .gray300)
        
        switch model {
        case .year(let string):
            contentLabel.text = string
            subContentLabel.text = "년"
        case .month(let string):
            contentLabel.text = string
            subContentLabel.text = "월"
        case .phase(let string):
            contentLabel.text = string
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(baseView.with(contentLabel), subContentLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(19)
        }
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        subContentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(baseView.snp.right).offset(5)
        }
    }
}
