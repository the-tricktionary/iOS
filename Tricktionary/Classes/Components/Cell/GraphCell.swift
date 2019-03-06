//
//  GraphCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import Charts

class GraphCell: BaseCell {
    
    // MARK: Variables
    
    fileprivate let view: UIView = UIView()
    fileprivate let chart: LineChartView = LineChartView()
    fileprivate let chartData: [Double]
    fileprivate let duration: Int
    fileprivate let labelsX = 9
    
    // MARK: Life cycle
    
    init(chartData: [Double], duration: Int) {
        self.chartData = chartData
        self.duration = duration
        super.init(style: .default, reuseIdentifier: nil)
        
        setupSubviews()
        setup()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        contentView.addSubview(view)
        view.addSubview(chart)
    }
    
    fileprivate func setup() {
        
        if !chartData.isEmpty {
            let series = ChartSeries(data: recalcSpeedData())
            series.area = true
            series.color = UIColor.green
            let data = recalcSpeedData()
            var values: [ChartDataEntry] = [ChartDataEntry]()
            data.forEach { (pair) in
                values.append(ChartDataEntry(x: pair.x, y: pair.y))
            }
            let dataSet = LineChartDataSet(values: values, label: nil)
            dataSet.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
                return CGFloat(self.chart.leftAxis.axisMinimum)
            }
            dataSet.drawFilledEnabled = true
            dataSet.drawCirclesEnabled = false
            dataSet.axisDependency = .left
            dataSet.drawCirclesEnabled = false
            dataSet.lineWidth = 2.0
            dataSet.circleRadius = 3.0
            dataSet.fillAlpha = 1.0
            dataSet.drawFilledEnabled = true
            dataSet.cubicIntensity = 0.5
            dataSet.drawCircleHoleEnabled = false
            dataSet.circleHoleRadius = 0.2
            dataSet.drawValuesEnabled = false
            
            let chartData = LineChartData(dataSet: dataSet)
            chart.data = chartData
//            chart.xLabels = [Double]()
//            var step = 0
//            for _ in 1...labelsX {
//                print("\(step)")
//                chart.xLabels?.append(Double(step))
//                step += duration / labelsX
//            }
//            chart.xLabelsFormatter = { String(Int(round($1))) }
//            chart.minY = 0
//            chart.add(series)
        }
    }
    
    fileprivate func setupViewConstraints() {
        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo((UIScreen.main.bounds.height / 3))
        }
        
        chart.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(250)
        }
    }
    
    fileprivate func recalcSpeedData() -> [(x: Double, y: Double)] {
        var returnValues = [(x: Double, y: Double)]()
        for (index, _) in chartData.enumerated() {
            if index > 0 {
                let x = (Double(duration) / Double(self.chartData.count)) * Double(index)
                print("Actual value: \(self.chartData[index]) - Last value: \(self.chartData[index - 1]) = \(self.chartData[index] - self.chartData[index - 1])")
                let y = Double(100) * (Double(1) / (self.chartData[index] - self.chartData[index - 1]))
                print("X: \(x), Y: \(y)")
                returnValues.append((x: x, y: y))
            }
        }
        return returnValues
    }
}
