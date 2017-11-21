//
//  AnalizeViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts

class AnalizeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var userTasks:[String] = ["英語でナンパ","プログラミング"]
    
    @IBOutlet weak var radarChartView: RadarChartView!
    var dataEntries: [ChartDataEntry] = []

    var subjects = [
        "国語", "英語", "数学", "理科", "社会"
    ]
    //点数
    let array = [100.0, 100.0, 100.0, 100.0, 100.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(dataPoints: subjects, values: array)
        print("array:")
        print(array)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        radarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = RadarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = RadarChartData(dataSet: chartDataSet)
        radarChartView.data = chartData
        //radarChartのオプション
        radarChartView.sizeToFit()
        radarChartView.descriptionText = ""
        
        //ここから軸の設定。表示範囲は0から100までとし、20刻みでグリッド線を入れる
        radarChartView.yAxis.labelCount = 6
        radarChartView.yAxis.axisMinValue = 0.0
        radarChartView.yAxis.axisMaxValue = 100.0
        //ここまで軸の設定
        
        radarChartView.rotationEnabled = false
        chartDataSet.drawFilledEnabled = true
        //値は整数で表示
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = NumberFormatter() as? IValueFormatter
        radarChartView.yAxis.valueFormatter = numberFormatter as? IAxisValueFormatter
        //その他のオプション!
        radarChartView.legend.enabled = false
        radarChartView.yAxis.gridAntialiasEnabled = true
        radarChartView.animate(yAxisDuration: 2.0)
    }

    

    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTasks.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasksCell = tableView.dequeueReusableCell(withIdentifier: "AnalizeCell") as! AnalizeTableViewCell
        tasksCell.setCell(titleText: userTasks[indexPath.row])
        
        return tasksCell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
