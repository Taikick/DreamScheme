//
//  editViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/18.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts


class editViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var passedIndex = -1
    
    @IBOutlet weak var DtitleTableView: UITableView!
    var entry = [
        
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)]
        
    ]
    
    
    var DTitle:[String] = [
        "英語を勉強してナンパできるようになる"
    ]
    
    var DTitleTime:[String] = [
        "2017.12.24-2018.12.24"
    ]

    var ProTitle:[String] = [
        "英語を勉強してナンパできるようになる"
    ]
    
    var ProTime:[String] = [
        "2017.12.24-2018.12.24"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DTitle.count;
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DtitleTableView.dequeueReusableCell(withIdentifier: "DTitleCell", for: indexPath) as! DTitleTableViewCell
        if tableView.tag == 0 {
            cell.DTitleLabel.text = DTitle[indexPath.row]
            cell.DTitleDate.text = DTitleTime[indexPath.row]
            var rect = cell.DTitleChart.bounds
            rect.origin.y += 4
            rect.size.height -= 4
            let chartView = HorizontalBarChartView(frame: rect)
            let set = BarChartDataSet(values: entry[1], label: "タスク時間")
            chartView.data = BarChartData(dataSet: set)
            chartView.drawBordersEnabled = false
            chartView.minOffset = CGFloat(10.0)
            chartView.sizeToFit()
            //x軸の設
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.forceLabelsEnabled = false
            chartView.xAxis.drawLabelsEnabled = false
            //        chartView.xAxis.labelCount = 100
            //        chartView.xAxis.axisMinimum = 1
            //y軸の設定
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.axisMaximum = 100
            set.formLineWidth = 3
            set.formSize = 10
            cell.DTitleChart.addSubview(chartView)
            
        } else {
            
        }
        return cell
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
