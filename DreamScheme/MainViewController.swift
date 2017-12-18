//
//  ViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/15.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts
import CoreData
import FontAwesome_swift
import SlideMenuControllerSwift

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var selectedIndex = 0
    
    @IBOutlet weak var myButton: UIButton!
    
    var cardsDesign:[String] = []
    var hometitles:[String] = []
    var homeTime:[String] = []
    var homeLastTime:[String] = []
    var ids:[Int] = []
    var purposeTime:[Int] = []
    var totalDoneTime:[Int] = []
    
    
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        myButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        myButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        myButton.setTitleColor(UIColor.blue, for: .normal)
        
        
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
        //バーの左側にボタンを配置します(ライブラリ特有)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        self.navigationItem.title = "ホーム"
    }
    override func viewDidAppear(_ animated: Bool) {
        print(purposeTime)
        cardsDesign = []
        hometitles = []
        homeTime = []
        homeLastTime = []
        totalDoneTime = []
        purposeTime = []
        ids = []
        read()
        homeTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
//        homeTableView.reloadData()
//        read()
        //        timer.invalidate()
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
                var id: Int = (result.value(forKey: "id") as? Int)!
                var totalTime = result.value(forKey: "totalTime") as? Int
                
                var doneTime = result.value(forKey: "totalDoneTime") as? Int
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil && totalTime != nil && id != nil{

                    hometitles.append(hometitle!)
                    cardsDesign.append(forCard!)
                    homeTime.append(df.string(from: forStart!))
                    homeLastTime.append(df.string(from: forEnd!))
                    ids.append(id)
                    purposeTime.append(totalTime!)
                    totalDoneTime.append(doneTime!)
                }
            }
            
        }catch {
            print("read失敗")
        }
    }

    //トップに戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //トップ画面に戻る。
        self.slideMenuController()?.openLeft()

    }
    
    
    //ぼたんが押された時の処理
    @IBAction func tapButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    
    
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hometitles.count;
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.tasksLabel.text = hometitles[indexPath.row]
        cell.tasksLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.dateLabel.text = "\(homeTime[indexPath.row]) - \(homeLastTime[indexPath.row])"
        cell.dateLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.forIdLabel.text = String(ids[indexPath.row])
        cell.forIdLabel.alpha = 0
        var rect = cell.BarChrats.bounds
        rect.origin.y += 4
        rect.size.height -= 4
        let chartView = HorizontalBarChartView(frame: rect)
        //ここにデータイレリ処理を書いていく
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
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = Double(purposeTime[indexPath.row] / 3600)
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.enabled = false
        chartView.rightAxis.labelCount = 5
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.axisMaximum = Double(purposeTime[indexPath.row] / 3600)
        chartView.accessibilityLabel = ""
        cell.BarChrats.noDataText = ""
        chartView.xAxis.drawLabelsEnabled = true
        chartView.descriptionTextPosition = nil
        chartView.drawBarShadowEnabled = false
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
        var subviews = cell.BarChrats.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        cell.BarChrats.addSubview(chartView)
        return cell
    }
    
    //セルが押された時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ids[indexPath.row])
        //セグウェを使って移動する時に値を渡す
        selectedIndex = ids[indexPath.row]
        //選択された行番号をほぞん
        
        //セグエに名前を指定して画面遷移処理を発動
        performSegue(withIdentifier: "toCreate", sender: nil)
    }
    
    
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンス(オブジェクト)を取得
        if segue.identifier == "toEdit"{
            let toCreate: CreateViewController = segue.destination as! CreateViewController
            //次の画面のプロパティ（メンバ変数）passedIndexに選択された行番号を渡す

        }
        
        if segue.identifier == "toCreate" {
            
            let toEdit: editViewController = segue.destination as! editViewController
            print(selectedIndex)
            toEdit.passedIndex = selectedIndex
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let viewContext = appDelegate.persistentContainer.viewContext
            
            let queryL:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
            
            let predicateL = NSPredicate(format: "taskID = %d", ids[indexPath.row])
            queryL.predicate = predicateL
            do {
                let fetchResult = try viewContext.fetch(queryL)
                
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    viewContext.delete(record)
                    
                }
                try viewContext.save()
                
            }catch {
                print("read失敗")
            }
            
            let queryP:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
            
            let predicateP = NSPredicate(format: "forTaskID = %d", ids[indexPath.row])
            queryP.predicate = predicateP
            do {
                let fetchResult = try viewContext.fetch(queryP)
                
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    viewContext.delete(record)
                    print(record)
                }
                
                try viewContext.save()
                
                
            }catch {
                print("read失敗")
            }

            
            let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
            
            let predicate = NSPredicate(format: "id = %d", ids[indexPath.row])
            query.predicate = predicate
            do {
                let fetchResult = try viewContext.fetch(query)
                
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    
                    viewContext.delete(record)
                    
                    
                }
                try viewContext.save()
                hometitles.remove(at: indexPath.row)
                homeTime.remove(at: indexPath.row)
                ids.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                homeTableView.reloadData()
                
            }catch {
                print("read失敗")
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
