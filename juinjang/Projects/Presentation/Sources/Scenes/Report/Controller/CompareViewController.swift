//
//  CompareViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//

import UIKit
import Then
import DGCharts
import Alamofire

final class CompareViewController : BaseViewController, SendCompareImjangData, SendSearchCompareImjangData {
    
    func sendData(isSelected: Bool, compareImjangId: Int, compareImjangName: String) {
        print("sendData")
        isCompared = isSelected
        getReportInfo(limjangId: compareImjangId)
        isCompare()
        compareLabel2.text = compareImjangName
        chartCompareLabel2.text = compareImjangName
    }
    
    var isCompared : Bool = false
    var imjangId : Int
    var comparedImjangId : Int = 0
    var imjangList: [ListDto] = []
    
    var indoorRate1 : Float = 0.0
    var locationRate1 : Float = 0.0
    var publicRate1 : Float = 0.0
    
    var indoorRate2 : Float = 0.0
    var locationRate2 : Float = 0.0
    var publicRate2 : Float = 0.0
    
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage.Report.paperTexture
    }
    
    var compareLabel1 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = .main
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var vsImageView = UIImageView().then {
        $0.image = UIImage.Report.VS
    }
    var compareLabel2 = UILabel().then {
        $0.text = "비교건물명"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = .gray500
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var compareView1 = UIImageView().then {
        $0.image = UIImage.Report.compareView1
    }
    
    var compareView2 = UIButton().then {
        $0.setBackgroundImage(UIImage.Report.compareEmpty, for: .normal)
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var closeButton = UIButton().then {
        $0.setImage(UIImage.Report.xButton, for: .normal)
    }
    var chartCompareImageView1 = UIImageView().then {
        $0.image = UIImage.Report.chartCompare1
    }
    var chartCompareLabel1 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var chartCompareImageView2 = UIImageView().then {
        $0.image = UIImage.Report.chartCompare2
    }
    var chartCompareLabel2 = UILabel().then {
        $0.text = "비교건물명"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var insideLabel1 = UILabel().then {
        $0.text = "실내"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var insideLabel2 = UILabel().then {
        $0.text = "실내"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var insideRateLabel1 = UILabel().then {
        $0.textColor = .gray450
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var insideRateLabel2 = UILabel().then {
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var publicSpaceLabel1 = UILabel().then {
        $0.text = "공용 공간"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicSpaceLabel2 = UILabel().then {
        $0.text = "공용 공간"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicSpaceRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage.Report.grayStar
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var publicSpaceRateLabel2 = UILabel().then {
        $0.text = "4.5"
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var locationConditionLabel1 = UILabel().then {
        $0.text = "입지 여건"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage.Report.grayStar
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionLabel2 = UILabel().then {
        $0.text = "입지 여건"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionRateLabel2 = UILabel().then {
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var totalLabel1 = UILabel().then {
        $0.text = "총점"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage.star
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = .main
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalLabel2 = UILabel().then {
        $0.text = "총점"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray450
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalRateLabel2 = UILabel().then {
        $0.textColor = .main
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var radarChartView = RadarChartView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.webLineWidth = 0
        $0.innerWebLineWidth = 1.5
        $0.innerWebColor = .clear
        $0.frame = CGRect(x: 60, y: 300, width: 300, height: 300)
        $0.highlightPerTapEnabled = false
        
        let xAxis = $0.xAxis
        xAxis.labelFont = UIFont(name: "Pretendard-SemiBold`", size: 14) ?? .systemFont(ofSize: 14)
        xAxis.labelTextColor = .gray450
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = XAxisFormatter()
        xAxis.axisLineColor = .main
        
        let yAxis = $0.yAxis
        yAxis.labelCount = 5
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.valueFormatter = YAxisFormatter()
        
        $0.rotationEnabled = false
        $0.legend.enabled = false
    }
    
    var compareDataSet2 = RadarChartDataSet(
        entries: [
            RadarChartDataEntry(value: 2.8),
            RadarChartDataEntry(value: 4.0),
            RadarChartDataEntry(value: 3.2)
        ]
    ).then {
        $0.fillColor = .clear
    }
    
    func isCompare() {
        print("이즈컴페어 : \(isCompared)")
        if isCompared == true {
            compareView2.setBackgroundImage(UIImage.Report.compareView2, for: .normal)
            closeButton.isHidden = false
            compareLabel2.isHidden = false
            chartCompareLabel1.isHidden = false
            chartCompareImageView1.isHidden = false
            chartCompareLabel2.isHidden = false
            chartCompareImageView2.isHidden = false
            insideLabel2.isHidden = false
            insideRateLabel2.isHidden = false
            publicSpaceLabel2.isHidden = false
            publicSpaceRateLabel2.isHidden = false
            locationConditionLabel2.isHidden = false
            locationConditionRateLabel2.isHidden = false
            totalLabel2.isHidden = false
            totalRateLabel2.isHidden = false
            compareView2.addSubview(insideLabel2)
            compareView2.addSubview(insideRateLabel2)
            compareView2.addSubview(publicSpaceLabel2)
            compareView2.addSubview(publicSpaceRateLabel2)
            compareView2.addSubview(locationConditionLabel2)
            compareView2.addSubview(locationConditionRateLabel2)
            compareView2.addSubview(totalLabel2)
            compareView2.addSubview(totalRateLabel2)
            view.addSubview(closeButton)
            view.addSubview(compareLabel2)
            view.addSubview(chartCompareLabel1)
            view.addSubview(chartCompareImageView1)
            view.addSubview(chartCompareLabel2)
            view.addSubview(chartCompareImageView2)
            closeButton.snp.makeConstraints{
                $0.right.equalToSuperview().inset(18)
                $0.top.equalTo(compareView2.snp.top).offset(-10)
                $0.height.equalTo(22)
            }
            compareLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(77)
                $0.centerX.equalTo(compareView2)
            }
            chartCompareImageView1.snp.makeConstraints{
                $0.top.equalTo(compareView1.snp.bottom).offset(28)
                $0.left.equalToSuperview().offset(21)
                $0.height.equalTo(11)
            }
            chartCompareLabel1.snp.makeConstraints{
                $0.top.equalTo(compareView1.snp.bottom).offset(25)
                $0.left.equalTo(chartCompareImageView1.snp.right).offset(4)
                $0.height.equalTo(17)
            }
            chartCompareImageView2.snp.makeConstraints{
                $0.top.equalTo(chartCompareImageView1.snp.bottom).offset(8)
                $0.left.equalToSuperview().offset(21)
                $0.height.equalTo(11)
            }
            chartCompareLabel2.snp.makeConstraints{
                $0.top.equalTo(chartCompareLabel1.snp.bottom).offset(2)
                $0.left.equalTo(chartCompareImageView2.snp.right).offset(4)
                $0.height.equalTo(17)
            }
            locationConditionLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(12)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            locationConditionRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(12)
                $0.right.equalToSuperview().inset(13)
                $0.height.equalTo(20)
            }
            publicSpaceLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(36)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            publicSpaceRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(36)
                $0.right.equalToSuperview().inset(13)
                $0.height.equalTo(20)
            }
            insideLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(60)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            insideRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(60)
                $0.right.equalToSuperview().inset(13)
                $0.height.equalTo(20)
            }
            totalLabel2.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(12)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            totalRateLabel2.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(12)
                $0.right.equalToSuperview().inset(13)
                $0.height.equalTo(20)
            }
        }
    }
    
    func callRequest(sort: Filter = .update, setScrap: Bool = false, excludingId: Int? = nil) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: sort.sortValue)) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let result = response.result else { return }
            
            let filteredList = result.limjangList.filter { item in
                if let excludingId = excludingId {
                    return item.limjangId != excludingId
                }
                return true
            }
            
            self.imjangList = filteredList
        }
    }
    
    func getReportInfo(limjangId: Int) {
        print("비교매물")
        print(limjangId)
        
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<ReportResponseDto>.self, api: .fetchReportInfo(imjangId: limjangId)) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response, let result = response.result else {
                    print("fetch Report Info Response is Empty")
                    return
                }
                setData(reportDto: result.reportDTO)
            } else {
                print("fetch Report Info Error")
            }
        }
    }
    
    func setData(reportDto: ReportDTO) {
        updateRate(rate: String(format: "%.2f", reportDto.indoorRate), label: insideRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.locationConditionsRate), label: locationConditionRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.publicSpaceRate), label: publicSpaceRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.totalRate), label: totalRateLabel2)
        
        
        compareDataSet2 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: Double(reportDto.indoorRate)),
                RadarChartDataEntry(value: Double(reportDto.locationConditionsRate)),
                RadarChartDataEntry(value: Double(reportDto.publicSpaceRate))
            ]
        )
        
        compareDataSet2.fillAlpha = CGFloat(0.7)
        compareDataSet2.fillColor = .mainWhite
        setCompareData()
    }
    
    func updateRate(rate: String, label: UILabel){
        let text1 = NSTextAttachment()
        text1.image = UIImage.Report.grayStar
        if label == totalRateLabel1 || label == totalRateLabel2 {
            text1.image = UIImage.star
        }
        let text2 = " " + rate
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        label.attributedText = text3
    }
    
    func setData(indoor: Float, location: Float, publicSpace: Float) {
        indoorRate1 = indoor
        locationRate1 = location
        publicRate1 = publicSpace
    }
    
    func setCompareData() {
        let dataSet1 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 1.0),
                RadarChartDataEntry(value: 1.0),
                RadarChartDataEntry(value: 1.0)
            ]
        )
        let dataSet2 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 2.0),
                RadarChartDataEntry(value: 2.0),
                RadarChartDataEntry(value: 2.0)
            ]
        )
        let dataSet3 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 3.0)
            ]
        )
        let dataSet4 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 4.0)
            ]
        )
        let dataSet5 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0)
            ]
        )
        
        let compareDataSet1 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: Double(indoorRate1)),
                RadarChartDataEntry(value: Double(locationRate1)),
                RadarChartDataEntry(value: Double(publicRate1))
            ]
        )
        
        let data = RadarChartData(dataSets: [dataSet5, dataSet4, dataSet3, dataSet2, dataSet1,  compareDataSet1,compareDataSet2])
        radarChartView.data = data
        
        dataSet1.lineWidth = 0
        dataSet2.lineWidth = 0
        dataSet3.lineWidth = 0
        dataSet4.lineWidth = 0
        dataSet5.lineWidth = 0
        compareDataSet1.lineWidth = 0
        compareDataSet2.lineWidth = 0
        
        // entries의 값을 가져옴
        let entries = compareDataSet2.entries.map { entry in
            return (entry as? RadarChartDataEntry)?.value ?? 0.0
        }
        
        if (entries.filter { $0 == 0 }.count == 2) {
            compareDataSet2.lineWidth = 1
            compareDataSet2.setColor(.mainWhite)
        } else {
            compareDataSet2.lineWidth = 0 // 기본 lineWidth 값을 설정
        }
        
        let dataColor = UIColor.main.withAlphaComponent(0.3)
        
        dataSet1.fillColor = dataColor
        dataSet2.fillColor = dataColor
        dataSet3.fillColor = dataColor
        dataSet4.fillColor = dataColor
        dataSet5.fillColor = dataColor
        compareDataSet1.fillAlpha = CGFloat(0.55)
        compareDataSet1.fillColor = .main
        
        
        dataSet1.drawFilledEnabled = true
        dataSet2.drawFilledEnabled = true
        dataSet3.drawFilledEnabled = true
        dataSet4.drawFilledEnabled = true
        dataSet5.drawFilledEnabled = true
        compareDataSet1.drawFilledEnabled = true
        compareDataSet2.drawFilledEnabled = true
        
        dataSet1.valueFormatter = DataSetValueFormatter()
        dataSet2.valueFormatter = DataSetValueFormatter()
        dataSet3.valueFormatter = DataSetValueFormatter()
        dataSet4.valueFormatter = DataSetValueFormatter()
        dataSet5.valueFormatter = DataSetValueFormatter()
        compareDataSet1.valueFormatter = DataSetValueFormatter()
        compareDataSet2.valueFormatter = DataSetValueFormatter()
    }
    
    func addTarget() {
        compareView2.addTarget(self, action: #selector(compareButtonTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)
    }
    @objc private func compareButtonTap() {
        
        if imjangList.isEmpty {
            // 매물이 하나도 없을 때 팝업을 띄움
            let popupViewController = NoMaemullPopupViewController(ment: "비교할 매물이 아직 없어요.\n다른 매물이 생기면 다시 와주세요!")
            popupViewController.modalPresentationStyle = .overFullScreen
            self.present(popupViewController, animated: false)
        } else {
            // 매물이 있을 때 `SelectMaemullViewController`로 이동
            let vc = SelectMaemullViewController(dependency: SelectMaemullViewController.Dependency(noteRepository: NoteRepository()), imjangId: self.imjangId)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func closeBtnTap() {
        isCompared = false
        compareView2.setBackgroundImage(UIImage.Report.compareEmpty, for: .normal)
        insideLabel2.isHidden = true
        insideRateLabel2.isHidden = true
        publicSpaceLabel2.isHidden = true
        publicSpaceRateLabel2.isHidden = true
        locationConditionLabel2.isHidden = true
        locationConditionRateLabel2.isHidden = true
        totalLabel2.isHidden = true
        totalRateLabel2.isHidden = true
        closeButton.isHidden = true
        compareLabel2.isHidden = true
        chartCompareLabel1.isHidden = true
        chartCompareImageView1.isHidden = true
        chartCompareLabel2.isHidden = true
        chartCompareImageView2.isHidden = true
        
        compareDataSet2.fillColor = .clear
        setCompareData()
    }
    
    func setConstraint() {
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        compareLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(77)
            $0.centerX.equalTo(compareView1)
            $0.height.equalTo(20)
        }
        vsImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(11)
            $0.width.equalTo(18)
        }
        
        locationConditionLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        locationConditionRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().inset(13)
            $0.height.equalTo(20)
        }
        
        publicSpaceLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        publicSpaceRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.right.equalToSuperview().inset(13)
            $0.height.equalTo(20)
        }
        insideLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        insideRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().inset(13)
            $0.height.equalTo(20)
        }
        totalLabel1.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        totalRateLabel1.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(13)
            $0.height.equalTo(20)
        }
    }
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        view.addSubview(backgroundImageView)
        view.addSubview(compareLabel1)
        view.addSubview(vsImageView)
        
        // Create a horizontal stack view for compareView1 and compareView2
        let stackView = UIStackView(arrangedSubviews: [compareView1, compareView2]).then {
            $0.axis = .horizontal // 수평 방향
            $0.spacing = 12
            $0.distribution = .fillEqually
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Create a vertical stack view for stackView and radarChartView
        let stackView2 = UIStackView(arrangedSubviews: [stackView, radarChartView]).then {
            $0.axis = .vertical // 수직 방향
            $0.spacing = 16 // 필요에 따라 간격 조정
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(stackView2)

        // Set constraints for stackView2
        stackView2.snp.makeConstraints {
            $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24) // 좌우 여백 설정
        }
        
        // Set constraints for stackView
        stackView.snp.makeConstraints {
            $0.height.equalTo(127) // 필요에 따라 높이 조정
        }
        
        // Set constraints for radarChartView
        radarChartView.snp.makeConstraints {
            $0.height.equalTo(350)
            $0.width.equalTo(700) // 필요에 따라 조정
        }
        
        compareView1.addSubview(insideLabel1)
        compareView1.addSubview(insideRateLabel1)
        compareView1.addSubview(publicSpaceLabel1)
        compareView1.addSubview(publicSpaceRateLabel1)
        compareView1.addSubview(locationConditionLabel1)
        compareView1.addSubview(locationConditionRateLabel1)
        compareView1.addSubview(totalLabel1)
        compareView1.addSubview(totalRateLabel1)
        
        isCompare()
        callRequest(setScrap: true, excludingId: imjangId)
        
        setCompareData()
        
        addTarget()
        setConstraint()
    }
}
