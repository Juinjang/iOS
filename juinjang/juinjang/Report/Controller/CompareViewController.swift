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
    
    var compareView1 = UIImageView().then {
        $0.image = UIImage(named: "compareView1")
    }
    
    var insideLabel1 = UILabel().then {
        $0.text = "실내"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var insideRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "compareStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var publicSpaceLabel1 = UILabel().then {
        $0.text = "공용 공간"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicSpaceRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "compareStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var locationConditionLabel1 = UILabel().then {
        $0.text = "입지 여건"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "compareStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var totalLabel1 = UILabel().then {
        $0.text = "총점"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "compareStarColor")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "juinjang")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    var compareView2 = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "비교매물"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(compareButtonTap), for: .touchUpInside)
    }
    @objc private func compareButtonTap() {
        /*let popupViewController = NoMaemullPopupViewController(ment: "비교할 매물이 아직 없어요.\n다른 매물이 생기면 다시 와주세요!")
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)*/
        let vc = SelectMaemullViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    var radarChartView = RadarChartView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.webLineWidth = 0
        $0.innerWebLineWidth = 1.5
        $0.innerWebColor = .clear
        $0.frame = CGRect(x: 60, y: 300, width: 300, height: 300)
       
        
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
    
    func setData() {
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
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 2.8),
                RadarChartDataEntry(value: 4.0)
            ]
        )
        
        let data = RadarChartData(dataSets: [dataSet5, dataSet4, dataSet3, dataSet2, dataSet1, compareDataSet1])
        radarChartView.data = data
        
        dataSet1.lineWidth = 0
        dataSet2.lineWidth = 0
        dataSet3.lineWidth = 0
        dataSet4.lineWidth = 0
        dataSet5.lineWidth = 0
        compareDataSet1.lineWidth = 0
        
        let dataColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 0.3)
        let dataColor1 = UIColor.red
        
        dataSet1.fillColor = dataColor
        dataSet2.fillColor = dataColor
        dataSet3.fillColor = dataColor
        dataSet4.fillColor = dataColor
        dataSet5.fillColor = dataColor
        compareDataSet1.fillColor = dataColor1
        
        dataSet1.drawFilledEnabled = true
        dataSet2.drawFilledEnabled = true
        dataSet3.drawFilledEnabled = true
        dataSet4.drawFilledEnabled = true
        dataSet5.drawFilledEnabled = true
        compareDataSet1.drawFilledEnabled = true
        
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
        
        compareLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(77)
            $0.left.equalToSuperview().offset(45)
            $0.height.equalTo(20)
        }
        vsImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(11)
            $0.width.equalTo(18)
        }
        
        compareView1.snp.makeConstraints{
            $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
        }
        
        insideLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        insideRateLabel1.snp.makeConstraints{
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
        locationConditionLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        locationConditionRateLabel1.snp.makeConstraints{
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
            $0.right.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
        
        compareView2.snp.makeConstraints{
            $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(24)
        }
        
        radarChartView.snp.makeConstraints {
            $0.top.equalTo(compareView1.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(350)
            $0.width.equalTo(700)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "reportBG")
        view.addSubview(backgroundImageView)
        view.addSubview(compareLabel1)
        view.addSubview(vsImageView)
        view.addSubview(compareView1)
        compareView1.addSubview(insideLabel1)
        compareView1.addSubview(insideRateLabel1)
        compareView1.addSubview(publicSpaceLabel1)
        compareView1.addSubview(publicSpaceRateLabel1)
        compareView1.addSubview(locationConditionLabel1)
        compareView1.addSubview(locationConditionRateLabel1)
        compareView1.addSubview(totalLabel1)
        compareView1.addSubview(totalRateLabel1)
        view.addSubview(compareView2)
        
        view.addSubview(radarChartView)
        setData()
        
        setConstraint()
    }
}
