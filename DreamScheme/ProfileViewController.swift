//
//  ProfileViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices



class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
    @IBOutlet weak var profileSettings: UITableView!
    
    let Settings:[String] = ["未達成のタスク","達成済のタスク","総合タスク数","総合タスク時間"]
    
    let unReachTask = "3個"
    let totalTime = "hogehoge"
    
    var countUnreach = -1
    var countFin = -1
    var countAllTime = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        myImageView.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1), size: CGSize(width: 300.0, height: 300.0))
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
        //バーの左側にボタンを配置します(ライブラリ特有)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        self.navigationItem.title = "タスク状況"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        CountUnreachTasks()
        CountFinTasks()
        CountAllTime()
        profileTableView.reloadData()
    }
    //未達成のタスクの数を取る
    func CountUnreachTasks(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "doneID = %@",NSNumber(value: false) as CVarArg)
        query.predicate = predicate
        
        
		
        var tasksCount:[String] = []
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                var forTask:String? = result.value(forKey: "title") as! String?
            tasksCount.append(forTask!)
            }
            
            countUnreach = tasksCount.count
        }catch {
            print("read失敗")
        }
    }
    
    
    //未達成のタスクの数を取る
    func CountFinTasks(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "doneID = %@",NSNumber(value: true) as CVarArg)
        query.predicate = predicate
        
        
        
        var tasksCount:[String] = []
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                var forTask:String? = result.value(forKey: "title") as! String?
                tasksCount.append(forTask!)
            }
            
            countFin = tasksCount.count
        }catch {
            print("read失敗")
        }
    }
    
    //全部の時間を数える
    func CountAllTime(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
    
        var tasksCount:[String] = []
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                
                var forTask:Int? = result.value(forKey: "totalDoneTime") as! Int?
                
                if forTask != nil {
                    countAllTime += forTask!
                }
            }
        }catch {
            print("read失敗")
        }
    }

    
    /// セルの個数指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.count
    }
    
    /// セルに値を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell

        cell.userLabel.text = Settings[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.userInfoLabel.text = "\(countUnreach)個"
        case 1:
            cell.userInfoLabel.text = "\(countFin)個"
        case 2:
            cell.userInfoLabel.text = "\(countUnreach + countFin)個"
        default:
            cell.userInfoLabel.text = "\(countAllTime / 3600)時間"
        }
        return cell
    }

}
