//
//  GoalViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts
import CoreData

class GoalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var goalTableView: UITableView!
    
    var selectedIndex = -1
    var selectedProcess = -1
    var goalTitles:[String] = [
        "英語を勉強してナンパできるようになる"
        ,"PHPマスター"
        ,"swiftマスター"
    ]
    
    var goalTime:[String] = [
        "2017.12.24-2018.12.24"
        ,"2017.12.24 - 2018.3.9"
        ,"2017"
    ]
    
    var entry = [
        
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)]
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
    }

    override func viewWillAppear(_ animated: Bool) {
        //goalTableView.reloadData()
        //        timer.invalidate()
    }
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalTitles.count;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = goalTableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalTableViewCell
        
        cell.TasksLabel.text = goalTitles[indexPath.row]
        cell.DateLabel.text = goalTime[indexPath.row]
        
        
        var rect = cell.BarView.bounds
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
        cell.BarView.addSubview(chartView)
        return cell
    }
    //セルが押された時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目")
        //セグウェを使って移動する時に値を渡す
        selectedIndex = indexPath.row
        selectedProcess = indexPath.row
        //選択された行番号をほぞん
        performSegue(withIdentifier: "GoalToDetail", sender: nil)
        //セグエに名前を指定して画面遷移処理を発動

    }
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // GoalToDetail
        if segue.identifier == "GoalToDetail" {
            
            let toEdit: editViewController = segue.destination as! editViewController
            toEdit.passedIndex = selectedProcess
        }
        
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
