//
//  BarChartTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Nguyễn on 26/10/2022.
//

import UIKit
import Charts

class BarChartTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var barChart: BarChartView!
    
    let category = ["Xe cộ", "Máy móc", "Sức khoẻ", "Nhà cửa", "Công việc", "Ăm uống", "Mua sắm", "Khác"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        barChart.delegate = self
        
        let legend = barChart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: self.category)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barChart.rightAxis.enabled = false
        barChart.zoom(scaleX: 2, scaleY: 2, x: 0, y: 0)
        
    }
    
    func setupData(list: [Transaction]) {
        var flexible = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        var stable = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        let flexibleList = list.filter({$0.type == false})
        for item in flexibleList {
            switch item.category {
            case "car":
                flexible[0] += Double(item.amount)
            case "device":
                flexible[1] += Double(item.amount)
            case "health":
                flexible[2] += Double(item.amount)
            case "house":
                flexible[3] += Double(item.amount)
            case "office":
                flexible[4] += Double(item.amount)
            case "food":
                flexible[5] += Double(item.amount)
            case "shopping":
                flexible[6] += Double(item.amount)
            case "other":
                flexible[7] += Double(item.amount)
            default:
                break
            }
        }
        
        let stableList = list.filter({$0.type == true})
        for item in stableList {
            switch item.category {
            case "car":
                stable[0] += Double(item.amount)
            case "device":
                stable[1] += Double(item.amount)
            case "health":
                stable[2] += Double(item.amount)
            case "house":
                stable[3] += Double(item.amount)
            case "office":
                stable[4] += Double(item.amount)
            case "food":
                stable[5] += Double(item.amount)
            case "shopping":
                stable[6] += Double(item.amount)
            case "other":
                stable[7] += Double(item.amount)
            default:
                break
            }
        }
        
        setChart(stable: stable, flexible: flexible)
    }
    
    func setChart(stable: [Double], flexible: [Double]) {
        barChart.noDataText = "Không có dữ liệu"
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0 ..< self.category.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: stable[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: flexible[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Cố định")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Linh hoạt")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let groupCount = self.category.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        barChart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barChart.notifyDataSetChanged()
        
        barChart.data = chartData
        
        barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
}
