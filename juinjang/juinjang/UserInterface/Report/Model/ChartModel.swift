//
//  ChartModel.swift
//  juinjang
//
//  Created by 박도연 on 2/2/24.
//

struct ChartData {
    static let chartData: [ChartData]
}
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
                RadarChartDataEntry(value: 3.5),
                RadarChartDataEntry(value: 2.8),
                RadarChartDataEntry(value: 4.0)
            ]
        )
        
        let compareDataSet2 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 2.5),
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 3.2)
            ]
