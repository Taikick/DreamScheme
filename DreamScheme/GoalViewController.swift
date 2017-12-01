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
    
    var selectedIndex = 0
    var selectedProcess = -1
    
    var cardsDesign:[String] = []
    
    var hometitles:[String] = []
    
    var homeTime:[String] = []
    
    var homeLastTime:[String] = []

    
    var entry = [
        
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)] ,       [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)]
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
    }

    override func viewWillAppear(_ animated: Bool) {
        //goalTableView.reloadData()
        //        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        read()
    }
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hometitles.count;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = goalTableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalTableViewCell
        
        cell.TasksLabel.text = hometitles[indexPath.row]
        cell.TasksLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.DateLabel.text = "\(homeTime[indexPath.row]) - \(homeLastTime[indexPath.row])"
        cell.DateLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        var rect = cell.BarView.bounds
        rect.origin.y += 4
        rect.size.height -= 4
        let chartView = HorizontalBarChartView(frame: rect)
        let set = BarChartDataSet(values: entry[indexPath.row], label: "")
        chartView.data = BarChartData(dataSet: set)
        chartView.drawBordersEnabled = false
        chartView.minOffset = CGFloat(0)
        chartView.sizeToFit()
        //x軸の設
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.forceLabelsEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.chartDescription?.text = ""
        set.drawValuesEnabled = false
        chartView.animate(yAxisDuration: 2.0)
        chartView.legend.enabled = false
        chartView.borderLineWidth = 1.0
        //y軸の設定
        chartView.leftAxis.enabled = false
        chartView.rightAxis.labelCount = 5
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = 100.0
        chartView.accessibilityLabel = ""
        cell.BarView.noDataText = ""
        chartView.xAxis.drawLabelsEnabled = true
        chartView.descriptionTextPosition = nil
        chartView.highlightPerTapEnabled = false
        chartView.drawGridBackgroundEnabled = false
        set.formLineWidth = 1
        set.formSize = 3
        
        //色系
        if cardsDesign[indexPath.row] == "青"{
            cell.backgroundColor = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
            set.colors = [#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 0.8272153253)]
        } else if cardsDesign[indexPath.row] == "赤"{
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5359856592)
            set.colors = [#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 0.9017016267)]
        } else if cardsDesign[indexPath.row] == "黄色"{
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.7487157534)
            set.colors = [#colorLiteral(red: 1, green: 0.9334713866, blue: 0.2072222195, alpha: 1)]
        } else {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 0.6764501284)
            set.colors = [#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)]
        }
        chartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 0)
        set.valueTextColor = UIColor.clear
        chartView.xAxis.labelTextColor = UIColor.clear
        cell.BarView.addSubview(chartView)
        return cell
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
                
                print(hometitle)
                var forCard:String? = result.value(forKey: "cardDesign") as? String
                print(forCard)
                
                var forStart:Date? = result.value(forKey: "startDate") as? Date
                print(forStart)
                
                var forEnd:Date? = result.value(forKey: "endDate") as? Date
                print(forEnd)
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil {
                    
                    hometitles.append(hometitle!)
                    cardsDesign.append(forCard!)
                    homeTime.append(df.string(from: forStart!))
                    homeLastTime.append(df.string(from: forEnd!))
                    
                }
            }
            
        }catch {
            print("read失敗")
        }
    }

    //セルが押された時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目")
        //セグウェを使って移動する時に値を渡す
        selectedIndex = 0
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
            toEdit.passedIndex = selectedIndex
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
