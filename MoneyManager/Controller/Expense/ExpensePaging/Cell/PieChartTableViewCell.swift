//
//  PieChartTableViewCell.swift
//  MoneyManager
//
//  Created by Nam Ngây on 24/10/2022.
//

import UIKit
import PieCharts

class PieChartTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: PieChart!
    
    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
    ]
    var pieModel: [PieSliceModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: chartView.frame.width,
                                  height: chartView.frame.height)
        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
    }
    
    func setupData(data: [Transaction], usedMoney: Int) {
        pieModel.removeAll()
        chartView.removeSlices()
        chartView.models = pieModel
        for (index, value) in data.enumerated() {
            pieModel.append(PieSliceModel(value: Double(value.amount), color: colors[index], obj: value.title))
        }
        chartView.models = pieModel
    }

    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = { slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = { slice in
            return slice.data.model.obj as! String
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
}
