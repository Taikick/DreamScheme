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

        
        //let date = Date(fromISO8601: dateString)
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
        }catch {
            print("read失敗")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
