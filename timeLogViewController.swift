//
//  timeLogViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/12/05.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData

class timeLogViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var passedIndex = -1
    
    var startTimes:[Date] = []
    
    var endTimes:[Date] = []
    
    var moveOrStops:[Bool] = []
    
    var ids:[Int] = []
    
    let df = DateFormatter()
    
    var totalTime = 0
    
    var countIndex = 0
    
    @IBOutlet weak var logTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "タイムログ一覧"
        var rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: "barButtonTapped")

        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        startTimes = []
        endTimes = []
        moveOrStops = []
        ids = []
        read()
        
        logTableView.reloadData()
        print(startTimes)
        print(endTimes)
    }

    
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        let predicate = NSPredicate(format: "taskID = %d",passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                var startTime:Date? = result.value(forKey: "startTime") as? Date
                var endTime:Date? = result.value(forKey: "endTime") as? Date
                var moveOrStop:Bool = result.value(forKey: "moveOrStop") as! Bool
                var id:Int? = result.value(forKey: "id") as! Int
                startTimes.append(startTime!)
                ids.append(id!)
                moveOrStops.append(moveOrStop)
                if moveOrStop == false{
                    endTimes.append(endTime!)
                }
            }
            
        }catch {
            print("read失敗")
        }
    }

    
    
    /// セルの個数指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countIndex = startTimes.count
        return startTimes.count
    }
    
    /// セルに値を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = logTableView.dequeueReusableCell(withIdentifier: "timeLogCell", for: indexPath) as! timeLogTableViewCell
        
        df.dateFormat = "yyyy/MM/dd' 'HH:mm:ss"
        df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
        cell.startTimeLabel.text = df.string(from: startTimes[indexPath.row])
        cell.idLabel.text = "\(ids[indexPath.row])"
        cell.idLabel.alpha = 0
        
        if moveOrStops[indexPath.row] == false {
            cell.endTimeLabel.text = df.string(from: endTimes[indexPath.row])
        }else {
            cell.endTimeLabel.text = "学習中"
        }
        
        return cell
    }
    
    func barButtonTapped() {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        let predicate = NSPredicate(format: "taskID = %d", passedIndex)
        query.predicate = predicate
        
        do {
            let fetchResult = try viewContext.fetch(query)
            var timeLogCell = timeLogTableViewCell()
            
            df.dateFormat = "yyyy/MM/dd' 'HH:mm:ss"
            df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
            //logTableView.reloadData()
            
            var i = 0
            var error:[Int] = []
            
            if startTimes.count > 2{
                for i in 0...startTimes.count - 2 {
                    timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                    if let start = df.date(from: timeLogCell.endTimeLabel.text!), let end = df.date(from: timeLogCell.endTimeLabel.text!){
                        print("最後から二番目までバグなし")
                    }else {
                        timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                        error.append(i)
                        print(error)
                    }
                }
            } else if startTimes.count == 2{
                for i in 0...1 {
                    timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                    if let start = df.date(from: timeLogCell.endTimeLabel.text!), let end = df.date(from: timeLogCell.endTimeLabel.text!){
                        print("最後から二番目までバグなし")
                    }else {
                        timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                        error.append(i)
                        print(error)
                    }
                }
            }
        
            timeLogCell = logTableView.visibleCells[0] as! timeLogTableViewCell
            if timeLogCell.endTimeLabel.text == "学習中" {
                if let start = df.date(from: timeLogCell.endTimeLabel.text!){
                    print("最後バグなし")
                }else {
                    error.append(i)
                    print(error)
                }
            } else if timeLogCell.endTimeLabel.text != "学習中" {
                if let start = df.date(from: timeLogCell.endTimeLabel.text!), let end = df.date(from: timeLogCell.endTimeLabel.text!){
                    print("最後までバグなし")
                }else {
                    timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                    error.append(i)
                    print(error)
                }
            }

            
            if error == [] {
                i = 0
                for result:AnyObject in fetchResult {
                    
                    var record = result as! NSManagedObject
                    timeLogCell = logTableView.visibleCells[i] as! timeLogTableViewCell
                    record.setValue(df.date(from: timeLogCell.endTimeLabel.text!), forKey: "endTime")
                    record.setValue(df.date(from: timeLogCell.startTimeLabel.text!), forKey: "startTime")
                    
                    i += 1
                }
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
                totalTime = 0
                readTimeLogs()
                upDateTotalTime()
 
            } else{
                print("エラー")
                let alert = UIAlertController(title: "警告", message: "「yyyy/MM/dd HH:mm:ss」の形式で記述してください", preferredStyle: .alert)
                
                //アラートにOKボタンを追加
                //handler : OKボタンが押された時に行いたい処理を指定する場所
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in print("OK押されました")}))
                
                //アラートを表示する処理
                //completion : 動作が完了した後に発動するメソッド
                //animated :
                present(alert, animated: true, completion: {() -> Void in print("アラートが表示されました") })

            }
            

        }catch {
            print("read失敗")
        }

    }
    
    
    func readTimeLogs(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        let predicate = NSPredicate(format: "taskID = %d", passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                
                var startTime:Date = result.value(forKey: "startTime") as! Date
                
                var endTime:Date = result.value(forKey: "endTime") as! Date
                
                var getInterval = CFDateGetTimeIntervalSinceDate(endTime as CFDate, startTime as CFDate)
                var intDate = Int(getInterval)
                
                if intDate != nil {
                    totalTime += intDate
                }
                
            }
            do{
                try viewContext.save()
            }catch {
                print("接続失敗")
            }
            
        }catch {
            print("read失敗")
        }
    }
    func upDateTotalTime(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %d", passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            for result:AnyObject in fetchResult {
                let record = result as! NSManagedObject
                print(totalTime)
                record.setValue(totalTime,forKey:"totalDoneTime")
            }
        }catch {
            print("read失敗")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
