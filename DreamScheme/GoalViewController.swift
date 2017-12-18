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
    
    var ids:[Int] = []
    //処理まだ
    var totalDoneTime:[Int] = []
    //処理まだ
    var purposeTime:[Int] = []

    
    var entry = [
        
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 3.0)],
        [BarChartDataEntry(x: 1.0, y: 100.0)]
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
        //バーの左側にボタンを配置します(ライブラリ特有)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        self.navigationItem.title = "達成済タスク"
    }

    override func viewWillAppear(_ animated: Bool) {
        //goalTableView.reloadData()
        //        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardsDesign = []
        hometitles = []
        homeTime = []
        homeLastTime = []
        totalDoneTime = []
        purposeTime = []
        ids = []
        read()
        goalTableView.reloadData()
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
        cell.idLabel.text = String(ids[indexPath.row])
        cell.idLabel.alpha = 0
        var rect = cell.BarView.bounds
        rect.origin.y += 4
        rect.size.height -= 4
        let chartView = HorizontalBarChartView(frame: rect)
        
        var entry:[BarChartDataEntry] = [BarChartDataEntry(x: 1, y: Double(totalDoneTime[indexPath.row]) / 3600)]
        let set = BarChartDataSet(values: entry, label: "")
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
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = Double(purposeTime[indexPath.row] / 3600)
        chartView.leftAxis.labelCount = 5
        chartView.rightAxis.labelCount = 5
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = Double(purposeTime[indexPath.row] / 3600)
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
            cell.backgroundColor = UIColor(colorLiteralRed: 149/255, green: 191/255, blue: 220/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 159/255, green: 152/255, blue: 201/255, alpha: 1)]
        } else if cardsDesign[indexPath.row] == "赤"{
            cell.backgroundColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 228/255, green: 182/255, blue: 136/255, alpha: 1)]
        } else if cardsDesign[indexPath.row] == "黄色"{
            cell.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 212/255, blue: 102/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 216/255, green: 194/255, blue: 39/255, alpha: 1)]
        } else {
            cell.backgroundColor = UIColor(colorLiteralRed: 86/255, green: 186/255, blue: 154/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 77/255, green: 122/255, blue: 113/255, alpha: 1)]
        }
        chartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 0)
        set.valueTextColor = UIColor.clear
        chartView.xAxis.labelTextColor = UIColor.clear
        var subviews = cell.BarView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        cell.BarView.addSubview(chartView)
        return cell
    }
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "doneID = %@",NSNumber(value: true) as CVarArg)
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
                
                var id: Int? = result.value(forKey: "id") as? Int
                print(id!)
                var totalTime = result.value(forKey: "totalTime") as? Int
                
                var doneTime = result.value(forKey: "totalDoneTime") as? Int
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil && id != nil{
                    
                    hometitles.append(hometitle!)
                    cardsDesign.append(forCard!)
                    homeTime.append(df.string(from: forStart!))
                    homeLastTime.append(df.string(from: forEnd!))
                    ids.append(id!)
                    purposeTime.append(totalTime!)
                    totalDoneTime.append(doneTime!)
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
        selectedProcess = ids[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
                if editingStyle == .delete {
                    
                    print("\(indexPath.row)行目が削除されました")
                    
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let viewContext = appDelegate.persistentContainer.viewContext
                    
                    let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
                    
                    let predicate = NSPredicate(format: "id = %d", ids[indexPath.row])
                    print(ids[indexPath.row])
                    query.predicate = predicate
                    do {
                        let fetchResult = try viewContext.fetch(query)
                        
                        for result:AnyObject in fetchResult {
                            
                            let record = result as! NSManagedObject
                            viewContext.delete(record)
                            
                        }
                        try viewContext.save()
                        
                        goalTableView.reloadData()
                        print("消えたよ")
                        hometitles.remove(at: indexPath.row)
                        homeTime.remove(at: indexPath.row)
                        ids.remove(at: indexPath.row)
                        goalTableView.deleteRows(at: [indexPath], with: .fade)
                        
                        
                    }catch {
                        print("read失敗")
                    }
                }
        }
    }

}
