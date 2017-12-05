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
    
    @IBOutlet weak var logTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                var endTime:Date? = result.value(forKey: "startTime") as? Date
                var moveOrStop:Bool? = result.value(forKey: "moveOrStop") as? Bool
                
                
//                if startTime != nil && endTime != nil && moveOrStop != nil{
                    startTimes.append(startTime!)
                    endTimes.append(endTime!)
//                }
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
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd' 'HH:mm:ss"
        df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
        cell.textLabel?.text = df.string(from: startTimes[indexPath.row])
        if endTimes[indexPath.row] != nil{
            cell.endTimeLabel.text = df.string(from: endTimes[indexPath.row])
        }else {
            cell.endTimeLabel.text = "学習中"
        }
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
