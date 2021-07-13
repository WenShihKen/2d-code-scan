//
//  TestingChartViewController.swift
//  app
//
//  Created by PhoenixWrong on 2017/8/27.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import Charts

class TestingChartViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var Chartview: BarChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Chartview.delegate = self as ChartViewDelegate
        Chartview.xAxis.valueFormatter = self
        
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        setChart(values: unitsSold)
    }
    
    func setChart(values: [Double]) {
        Chartview.noDataText = "You need to provide data for the chart."
        
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        Chartview.data = BarChartData(dataSet: chartData)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestingChartViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[ Int(value) % months.count]
    }
}
