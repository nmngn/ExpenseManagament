//
//  PieChartTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/10/2022.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var blankView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blankView.isHidden = false
    }
    
    func setupData(data: [MergedDataModel], usedMoney: Int) {
        var dataEntries: [ChartDataEntry] = []
        
        if !data.isEmpty {
            blankView.isHidden = true
        } else {
            blankView.isHidden = false
        }

        
        for i in 0 ..< data.count {
            let dataEntry = PieChartDataEntry(value: Double(data[i].amount) / Double(usedMoney) * 100, label: parseCategory(data[i].category), data: data[i].amount.formattedWithSeparator)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: data.count)

        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)

        chartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.5)
            colors.append(color)
        }
        return colors
    }
}
