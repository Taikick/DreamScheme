//
//  AnalizeViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts
import CoreData

class AnalizeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var AnalizeTableView: UITableView!
    @IBOutlet weak var radarChartView: RadarChartView!
    
    var titles:[String] = []
    
    var totalDoneTime:[Int] = []
    var DtotalDoneTime:[Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        
        self.navigationItem.title = "時間分析"
        AnalizeTableView.layer.cornerRadius = 10.0;
        AnalizeTableView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        read()
        for toDouble in totalDoneTime{
            DtotalDoneTime.append(Double(toDouble))
        }
        setChart(dataPoints: titles, values: DtotalDoneTime)
    }
    
    
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "doneID = %@",NSNumber(value: false) as CVarArg)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                
                var hometitle:String? = result.value(forKey: "title") as? String
                
                var doneTime = result.value(forKey: "totalDoneTime") as? Int
                
                titles.append(hometitle!)
                totalDoneTime.append(doneTime!)
                
            }
            
        }catch {
            print("read失敗")
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        radarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x:Double(i) , y: values[i])
            dataEntries.append(dataEntry)
            print(dataEntries)
        }
        let chartDataSet = RadarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = RadarChartData(dataSet: chartDataSet)
        
        //radarChartのオプション
        radarChartView.sizeToFit()
        radarChartView.descriptionText = ""
        
        //ここから軸の設定。表示範囲は0から100までとし、20刻みでグリッド線を入れる
        radarChartView.yAxis.labelCount = 5
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 80.0
        radarChartView.yAxis.drawZeroLineEnabled = true
        radarChartView.yAxis.forceLabelsEnabled = false
        radarChartView.yAxis.drawTopYLabelEntryEnabled = true;
        radarChartView.xAxis.drawAxisLineEnabled = true
        radarChartView.innerWebColor = UIColor.white
        radarChartView.xAxis.axisLineColor = UIColor.white
        radarChartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 7)
        
        //ここまで軸の設定
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:titles)
        radarChartView.xAxis.granularity = 1
        radarChartView.rotationEnabled = false
        chartDataSet.drawFilledEnabled = true
        radarChartView.descriptionTextPosition = nil
        radarChartView.innerWebLineWidth = 0
        
        //値は整数で表示
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter as? IValueFormatter
        radarChartView.yAxis.valueFormatter = numberFormatter as? IAxisValueFormatter
        //その他のオプション!
        radarChartView.legend.enabled = false
        radarChartView.yAxis.gridAntialiasEnabled = true
        radarChartView.animate(yAxisDuration: 2.0)
        radarChartView.data = chartData
    }

    

    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasksCell = tableView.dequeueReusableCell(withIdentifier: "AnalizeCell") as! AnalizeTableViewCell
        tasksCell.setCell(titleText: titles[indexPath.row])
        
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
