//
//  CompareViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//

import UIKit
import Then
import DGCharts

class CompareViewController : UIViewController {
    
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"PaperTexture")
    }
    
    var compareLabel1 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = UIColor(named: "juinjang")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var vsImageView = UIImageView().then {
        $0.image = UIImage(named: "VS")
    }
    var compareLabel2 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = UIColor(named: "juinjang")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var radarChartView = RadarChartView().then {
        $0.webLineWidth = 1.5
        $0.innerWebLineWidth = 1.5
        $0.webColor = .lightGray
        $0.innerWebColor = .lightGray
        
        let xAxis = $0.xAxis
        xAxis.labelFont = .systemFont(ofSize: 14, weight: .semibold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        //xAxis.valueFormatter = XAxisFormatter()
        
        let yAxis = $0.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 6
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        // yAxis.valueFormatter = YAxisFormatter()
        
        $0.rotationEnabled = false
        $0.legend.enabled = false
    }
    
    func setData() {
        let dataSet1 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 1.2),
                RadarChartDataEntry(value: 3.5)
            ]
        )
        let data = RadarChartData(dataSets: [dataSet1])
        radarChartView.data = data
        dataSet1.lineWidth = 2
        let data1Color = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
        dataSet1.colors = [data1Color]
        dataSet1.fillColor = data1Color
        dataSet1.drawFilledEnabled = true
        
        //dataSet1.valueFormatter = DataSetValueFormatter()
    }
    
    func setConstraint() {
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        compareLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(77)
            $0.left.equalToSuperview().offset(45)
            $0.height.equalTo(20)
        }
        vsImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(10)
            $0.width.equalTo(18)
        }
        
        radarChartView.snp.makeConstraints {
            $0.top.equalTo(compareLabel1.snp.bottom).offset(200.3)
            $0.left.right.equalToSuperview().inset(63)
            $0.height.equalTo(264.55)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "reportBG")
        view.addSubview(backgroundImageView)
        view.addSubview(compareLabel1)
        view.addSubview(vsImageView)
        view.addSubview(radarChartView)
        setData()
        
        setConstraint()
    }
}
