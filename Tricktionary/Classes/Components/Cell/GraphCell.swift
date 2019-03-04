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

class GraphCell: BaseCell {
    
    // MARK: Variables
    
    fileprivate let view: UIView = UIView()
    fileprivate let chart: Chart = Chart()
    fileprivate let chartData: [(x: Double, y: Double)]
    
    // MARK: Life cycle
    
    init(chartData: [(x: Double, y: Double)]) {
        self.chartData = chartData
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
        
        let series: ChartSeries?
        if chartData.isEmpty {
            let chartSeries: ChartSeries = ChartSeries([Double]())
            for x in 0...30 {
                chartSeries.data.append((x: Double(x), y: Double(x/2)))
            }
            series = chartSeries
        } else {
            series = ChartSeries(data: chartData)
        }
        chart.add(series!)
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
}
