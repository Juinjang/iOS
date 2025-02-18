//
//  GraphViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//
import UIKit
import Then
import DGCharts
import Charts

final class GraphViewController : BaseViewController {
    
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"PaperTexture")
    }
    
    var label1 = UILabel().then {
        $0.text = "이곳은 한 마디로..."
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.6)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var noteImageView = UIImageView().then {
        $0.image = UIImage(named:"noteline")
    }
    
    var indoorImageView = UIImageView().then {
        $0.image = UIImage(named: "house")
    }
    var indoorLabel = UILabel().then {
        $0.text = "상당히 쾌적한 실내"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var indoorRateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var publicImageView = UIImageView().then {
        $0.image = UIImage(named: "building")
    }
    var publicLabel = UILabel().then {
        $0.text = "훌륭한 공용공간"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicRateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var locationimageView = UIImageView().then {
        $0.image = UIImage(named: "location")
    }
    var locationLabel = UILabel().then {
        $0.text = "좋은 편인 입지 여건"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationRateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var graphContainerView = UIView().then{
        $0.backgroundColor = .white
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
        xAxis.labelTextColor = UIColor(red: 0.292, green: 0.292, blue: 0.292, alpha: 1)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = XAxisFormatter()
        xAxis.axisLineColor = UIColor(named: "juinjang")!
        
        let yAxis = $0.yAxis
        yAxis.labelCount = 5
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.valueFormatter = YAxisFormatter()
        
        $0.rotationEnabled = false
        $0.legend.enabled = false
    }
    
    func updateLabel(with status1: String, status2: String, status3: String) {
        print("실행")
        indoorLabel.text = "\(status1) 실내"
        indoorLabel.asColor(targetString: status1, color: UIColor(named: "juinjang"))
        locationLabel.text = "\(status2) 입지 여건"
        locationLabel.asColor(targetString: status2, color: UIColor(named: "juinjang"))
        publicLabel.text = "\(status3) 공용공간"
        publicLabel.asColor(targetString: status3, color: UIColor(named: "juinjang"))
    }
    
    func updateRate(rate: String, label: UILabel){
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "grayStar")
        let text2 = " " + rate
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        label.attributedText = text3
    }
    
    func setData(indoor: Float, location: Float, publicSpace: Float) {
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
                RadarChartDataEntry(value: Double(indoor)),
                RadarChartDataEntry(value: Double(location)),
                RadarChartDataEntry(value: Double(publicSpace))
            ]
        )
        
        let data = RadarChartData(dataSets: [dataSet5, dataSet4, dataSet3, dataSet2, dataSet1, compareDataSet1])
        radarChartView.data = data
        
        dataSet1.lineWidth = 0
        dataSet2.lineWidth = 0
        dataSet3.lineWidth = 0
        dataSet4.lineWidth = 0
        dataSet5.lineWidth = 0
        
        // entries의 값을 가져옴
        let entries = compareDataSet1.entries.map { entry in
            return (entry as? RadarChartDataEntry)?.value ?? 0.0
        }

        // 하나만 1이고 나머지가 0인지 확인
        if (entries.filter { $0 == 0 }.count == 2) {
            compareDataSet1.lineWidth = 1
            compareDataSet1.setColor(UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1))
        } else {
            compareDataSet1.lineWidth = 0 // 기본 lineWidth 값을 설정
        }
        
        let dataColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 0.3)
        let dataColor1 = UIColor.red
        dataSet1.colors = [dataColor]
        
        dataSet1.fillColor = dataColor
        dataSet1.drawFilledEnabled = true
        
        dataSet2.fillColor = dataColor
        dataSet2.drawFilledEnabled = true
        dataSet3.drawFilledEnabled = true
        dataSet4.drawFilledEnabled = true
        dataSet5.drawFilledEnabled = true
        compareDataSet1.drawFilledEnabled = true
        dataSet3.fillColor = dataColor
        dataSet4.fillColor = dataColor
        dataSet5.fillColor = dataColor
        compareDataSet1.fillAlpha = CGFloat(0.6)
        compareDataSet1.fillColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        
        dataSet1.valueFormatter = DataSetValueFormatter()
        dataSet2.valueFormatter = DataSetValueFormatter()
        dataSet3.valueFormatter = DataSetValueFormatter()
        dataSet4.valueFormatter = DataSetValueFormatter()
        dataSet5.valueFormatter = DataSetValueFormatter()
        
        compareDataSet1.valueFormatter = DataSetValueFormatter()
    }
    
    func setConstraint() {
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        locationimageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        locationLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(locationimageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        locationRateLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
            $0.width.equalTo(55)
        }
        
        publicImageView.snp.makeConstraints{
            $0.top.equalTo(locationimageView.snp.bottom).offset(25)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        publicLabel.snp.makeConstraints{
            $0.top.equalTo(locationLabel.snp.bottom).offset(18)
            $0.left.equalTo(publicImageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        publicRateLabel.snp.makeConstraints{
            $0.top.equalTo(locationRateLabel.snp.bottom).offset(19)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
            $0.width.equalTo(55)
        }
        
        indoorImageView.snp.makeConstraints{
            $0.top.equalTo(publicImageView.snp.bottom).offset(24)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        indoorLabel.snp.makeConstraints{
            $0.top.equalTo(publicLabel.snp.bottom).offset(18)
            $0.left.equalTo(indoorImageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        indoorRateLabel.snp.makeConstraints{
            $0.top.equalTo(publicRateLabel.snp.bottom).offset(19)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
            $0.width.equalTo(55)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "reportBG")
        view.addSubview(backgroundImageView)
        view.addSubview(label1)
        
        // 스택뷰 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16 // 두 뷰 사이의 간격
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // 스택뷰에 noteImageView와 radarChartView 추가
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(noteImageView)
        stackView.addArrangedSubview(radarChartView)

        // 스택뷰를 뷰에 추가
        view.addSubview(stackView)

        // 스택뷰 제약 조건 설정
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.left.right.equalToSuperview().inset(24) // 좌우 여백 설정
        }

        label1.snp.makeConstraints {
            $0.left.equalToSuperview()
        }
        
        // noteImageView의 높이를 설정
        noteImageView.snp.makeConstraints {
            $0.height.equalTo(128) // noteImageView의 높이
        }

        // radarChartView의 비율 조정
        radarChartView.snp.makeConstraints {
            $0.height.equalTo(350) // radarChartView의 높이
            $0.width.equalTo(700) // radarChartView의 너비
        }
        
        noteImageView.addSubview(locationimageView)
        noteImageView.addSubview(locationLabel)
        noteImageView.addSubview(locationRateLabel)
        
        noteImageView.addSubview(publicImageView)
        noteImageView.addSubview(publicLabel)
        noteImageView.addSubview(publicRateLabel)
        
        noteImageView.addSubview(indoorImageView)
        noteImageView.addSubview(indoorLabel)
        noteImageView.addSubview(indoorRateLabel)
        
        setConstraint()
    }
}


final class DataSetValueFormatter: ValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}

final class XAxisFormatter: AxisValueFormatter {
    
    let titles = [" \n실내","입지\n여건","공용\n공간"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value) % titles.count
        return titles[index]
    }
}


final class YAxisFormatter: AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        ""
    }
}
