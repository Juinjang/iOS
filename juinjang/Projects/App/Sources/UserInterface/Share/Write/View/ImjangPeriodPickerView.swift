//
//  ImjangPeriodPickerView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/6/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class ImjangPeriodPickerView: BaseAlertViewController {
    private let baseView = UIView()
    
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "임장 시기"
    }
    
    private let pickerSelectView = UIView().then {
        $0.backgroundColor = .main100
        $0.roundCorners(cornerRadius: 8, corner: .all)
    }
    
    private lazy var pickerView: UIPickerView = {
        return UIPickerView().then {
            $0.delegate = self
            $0.dataSource = self
        }
    }()
    
    private let years: [String] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 50)...(currentYear + 50)).map { "\($0)년" }
    }()
    private let months: [String] = (1...12).map { "\($0)월" }
    private let phases: [String] = ["초반", "중반", "후반"]
    
    private let selectedPeriod: ImjangPeriod
    
    private let disposeBag = DisposeBag()
    
    let selectPeriodRelay = PublishRelay<ImjangPeriod>()
    
    init(selectPeriod: ImjangPeriod? = nil) {
        self.selectedPeriod = selectPeriod ?? ImjangPeriod.from()
        super.init(
            height: 281,
            isBackgroundDismissEnabled: true,
            contentViews: [baseView],
            buttons: [
                .cancel(title: "닫기", width: 106),
                .confirm(title: "확인")
            ]
        )
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let selectedYearIndex = years.firstIndex(of: "\(selectedPeriod.year)년") ?? 0
        let selectedMonthIndex = months.firstIndex(of: "\( Int(selectedPeriod.month) ?? 0)월") ?? 0
        let selectedPhaseIndex = phases.firstIndex(of: selectedPeriod.phase) ?? 0

        pickerView.selectRow(selectedYearIndex,
                             inComponent: 0,
                             animated: false)
        pickerView.selectRow(selectedMonthIndex,
                             inComponent: 1,
                             animated: false)
        pickerView.selectRow(selectedPhaseIndex,
                             inComponent: 2,
                             animated: false)
    }
    
    private func bind() {
        eventRelay
            .filter { $0 == .confirm }
            .map { [weak self] _ -> ImjangPeriod in
                guard let self = self else {
                    return ImjangPeriod(year: "", month: "", phase: "")
                }
                
                let selectedYearIndex = pickerView.selectedRow(inComponent: 0)
                let selectedMonthIndex = pickerView.selectedRow(inComponent: 1)
                let selectedPhaseIndex = pickerView.selectedRow(inComponent: 2)
                
                let year = years[selectedYearIndex].replacingOccurrences(of: "년", with: "")
                let month = months[selectedMonthIndex].replacingOccurrences(of: "월", with: "")
                let phase = phases[selectedPhaseIndex]
                
                return ImjangPeriod(
                    year: year,
                    month: String(format: "%02d", Int(month) ?? 1),
                    phase: phase
                )
            }
            .bind(to: selectPeriodRelay)
            .disposed(by: disposeBag)
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
        
        baseView.add(titleLabel, pickerSelectView, pickerView)
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(172)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        pickerSelectView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.horizontalEdges.equalTo(pickerView.snp.horizontalEdges)
            $0.centerY.equalTo(pickerView.snp.centerY)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(113)
        }
    }
}

extension ImjangPeriodPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        return DSLabel(.body).then {
            $0.fontSize = 18
            $0.fontColor = .black
            $0.fontAlignment = .center
            $0.text = {
                switch component {
                case 0: return years[row]
                case 1: return months[row]
                case 2: return phases[row]
                default: return ""
                }
            }()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch component {
        case 0: return years[row]
        case 1: return months[row]
        case 2: return phases[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
}

extension ImjangPeriodPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach { subview in
            subview.backgroundColor = .clear
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return years.count
        case 1: return months.count
        case 2: return phases.count
        default: return 0
        }
    }
}
