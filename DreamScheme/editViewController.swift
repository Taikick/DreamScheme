//
//  editViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/18.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts
import FontAwesome_swift
import CoreData


class editViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //ホームから選ばれて来たID
    var passedIndex = 1
    //選ばれたプロセスを次ページに渡すためのID
    var selectedProcess = -1
    //タイトルを押した時に次のページに飛ばすためのID
    var selectedTitle = -1
    
    @IBOutlet weak var addProButton: UIButton!
    
    @IBOutlet weak var DtitleTableView: UITableView!
    
    @IBOutlet weak var ProcessTableView: UITableView!
    
    @IBOutlet weak var watchButton: UIButton!
    
    @IBOutlet weak var watchLabel: UILabel!
    
    @IBOutlet weak var GoalButton: UIButton!
    
    var logId = 0
    
    var purposeTime = 0
    
    var cardsDesign:[String] = []
    
    var DTitle:String = ""
    
    var DTitleTime:String = ""
    
    var DtitleEnd:String = ""
    //コアから受け取ったユーザーの勉強時間
    var totalTime = 0
    
    var titleID = 0
    
    var DcardDesing = ""
    
    var forStart = Date()
    
    var forEnd = Date()
    
    var ProTitle:[String] = []
    
    var ProTime:[String] = []
    
    //timerの変数
    var timer:Timer!
    var startTime = Date()
    var intDate = 0
    var currentTime = TimeInterval()

    
    //ユーザーの目標時間
    
    var ProEndTime:[String] = []
    
    var ProId:[Int] = []
    
    var doneId:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fontawesomeをボタンに使う
        addProButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        addProButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        addProButton.setTitleColor(UIColor.blue, for: .normal)
        navigationItem.title = "タスク詳細"
        DtitleTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil{
            timer.invalidate()

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if timer != nil{
            timer.invalidate()
        }
        
        selectedProcess = -1
        ProTitle = []
        ProEndTime = []
        ProTime = []
        cardsDesign = []
        //タイトル読み込み用(タイマー関係ない)
        readTitle()
        //プロセスの情報読み込み用(タイマー関係ない)
        read()
        //時間処理↓
        //タイマー起動中に別ページから飛んできた時発動
        onTheWay()
        if doneId == false {
            GoalButton.setTitle("タスク完了！",for: .normal)
            watchLabel.alpha = 1
            watchButton.alpha = 1
        } else if doneId == true {
            watchLabel.alpha = 0
            watchButton.alpha = 0
            GoalButton.setTitle("未達成に戻す",for: .normal)
        }
        print("これ")
        print(totalTime)
        DtitleTableView.reloadData()
        ProcessTableView.reloadData()
    }
    
    //Tタイマーをカウントしてるメソッド
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        currentTime = Date().timeIntervalSince(startTime)
        print("カレント（タイマー中）\(currentTime)")
        //timeHourを計算
        let hour = (Int)(fmod((currentTime/3600), 60))
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        
        // %02d：２桁表示、0で埋める
        let sHour = String(format: "%02d", hour)
        let sMin = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        
        watchLabel.text = "\(sHour):\(sMin):\(sSecond)"
        
    }
    
    //Tストップウォッチボタンが押された時の処理　insertStartTimeとダブり
    @IBAction func tapWatchButton(_ sender: UIButton) {
        if watchButton.titleLabel?.text == "タスク開始" {
            if timer != nil{
                // timerが起動中なら一旦破棄する
                timer.invalidate()
            }
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.timerCounter),
                userInfo: nil,
                repeats: true)
            startTime = Date()
            readLogId()
            insertStartTime()
            watchButton.setTitle("タスク終了", for: .normal)
            
        } else {
            //終わり時間挿入
            insertEndTime()
            //タイムログ取ってきて
            totalTime = 0
            readTimeLogs()
            //トータルタイムアップデート
            upDateTotalTime()
            //テーブルリロード
            DtitleTableView.reloadData()
            ProcessTableView.reloadData()
            watchButton.setTitle("タスク開始", for: .normal)
            if timer != nil{
                // timerが起動中なら一旦破棄する
                timer.invalidate()
            }
        }
    }

    //Tスタート押したら読み込む
    func insertStartTime(){

        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let forTimeLog = NSEntityDescription.entity(forEntityName: "ForTimeLog", in: viewContext)
        
        let newStartTime = NSManagedObject(entity: forTimeLog!, insertInto: viewContext)
        
        newStartTime.setValue(startTime, forKey: "startTime")

        newStartTime.setValue(true, forKey: "moveOrStop")
        
        newStartTime.setValue(passedIndex, forKey: "taskID")
        newStartTime.setValue(logId + 1, forKey: "id")
        
        do{
            try viewContext.save()
        }catch {
            print("接続失敗")
        }
    }
    
    //Tタイマー起動中に別ページから飛んできた時発動
    func onTheWay(){

        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        let predicate = NSPredicate(format: "taskID = %d", passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                
                var start:Date = result.value(forKey: "startTime") as! Date
                var isOntheWay:Bool? = result.value(forKey: "moveOrStop") as! Bool?
                
                if isOntheWay == true{
                    
                    watchButton.setTitle("タスク終了", for: .normal)
                    currentTime = Date().timeIntervalSince(start)
                    timer = Timer.scheduledTimer(
                        timeInterval: 1,
                        target: self,
                        selector: #selector(self.timerCounter),
                        userInfo: nil,
                        repeats: true)
                    startTime = start
                } else{
                    
                }
            }
        }catch {
            print("read失敗")
        }
    }

    //Tエンドタイムの挿入（ダブってる）アップデート
    func insertEndTime(){
        var endTime = Date()
        timer.invalidate()
        watchLabel.text = "00:00:00"
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        let predicate = NSPredicate(format: "taskID = %d", passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            for result:AnyObject in fetchResult {
                
                var ending = result.value(forKey: "endTime")
                
                if ending == nil {
                    //値を更新
                    let record = result as! NSManagedObject
                    record.setValue(endTime,forKey:"endTime")
                    record.setValue(false, forKey: "moveOrStop")

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
    
    //このページの上のテーブル（タイトルを取得）
    func readTitle(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %d",passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                
                var hometitle:String? = result.value(forKey: "title") as? String
                
                
                var forCard:String? = result.value(forKey: "cardDesign") as? String
                
                
                forStart = (result.value(forKey: "startDate") as? Date)!
                
                
                forEnd = (result.value(forKey: "endDate") as? Date)!
                
                var id: Int = (result.value(forKey: "id") as? Int)!
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil && id != nil {
                    DTitle = hometitle!
                    DcardDesing = forCard!
                    DTitleTime = df.string(from: forStart)
                    DtitleEnd = df.string(from: forEnd)
                    titleID = id
                    purposeTime = (result.value(forKey: "totalTime") as? Int)!
                    totalTime = (result.value(forKey: "totalDoneTime") as? Int)!
                    doneId = result.value(forKey:"doneID") as! Bool
                }
            }
        }catch {
            print("read失敗")
        }
    }
    
    //Tウォッチボタン押されら時にタイムログ挿入
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
                    print("fuck\(intDate)")
                    totalTime += intDate
                }
                    
            }
            
            do{
                try viewContext.save()
            }catch {
                print("接続失敗")
            }
            print(totalTime)
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
                record.setValue(totalTime,forKey:"totalDoneTime")
                
            }
        }catch {
            print("read失敗")
        }
    }

    //プロセスの情報読み込み用(タイマー関係ない)
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
        
        let predicate = NSPredicate(format: "forTaskID = %d",passedIndex)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResult {
                var protitle:String? = result.value(forKey: "title") as? String
                
                var forCard:String? = result.value(forKey: "processCard") as? String
                
                print(forCard)
                
                var forStart:Date? = result.value(forKey: "processSrart") as? Date
                
                var forEnd:Date? = result.value(forKey: "processEnd") as? Date
                var id: Int = (result.value(forKey: "id") as? Int)!
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && protitle != nil && forCard != nil && id != nil {
                    
                    ProTitle.append(protitle!)
                    cardsDesign.append(forCard!)
                    ProTime.append(df.string(from: forStart!))
                    ProEndTime.append(df.string(from: forEnd!))
                    ProId.append(id)
                    
                }
                
            }
            
        }catch {
            print("read失敗")
        }
    }

    
    //データの読み込み処理
    func readLogId(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTimeLog> = ForTimeLog.fetchRequest()
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResults {
                
                logId = (result.value(forKey:"id") as? Int)!
                
            }
            
        } catch {
            print("read失敗")
        }
        print("あい\(logId)")
    }
    
    @IBAction func tapGoalButton(_ sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %d", passedIndex)
        query.predicate = predicate

        if GoalButton.titleLabel?.text == "タスク完了！"{
            do {
                let fetchResult = try viewContext.fetch(query)
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    record.setValue(true, forKey: "doneID")
                }
                GoalButton.setTitle("未達成に戻す", for: .normal)
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
            }catch {
                print("read失敗")
            }
        } else if GoalButton.titleLabel?.text == "未達成に戻す"{
            do {
                let fetchResult = try viewContext.fetch(query)
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    record.setValue(false, forKey: "doneID")
                }
                GoalButton.setTitle("未達成に戻す", for: .normal)
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
            }catch {
                print("read失敗")
            }
            
            GoalButton.setTitle("タスク完了", for: .normal)
        }
    }
    
    
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return 1
        }else if tableView.tag == 2{
            return ProTitle.count
        }else {
            return 0
        }
    
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if tableView.tag == 1 {
            let cell = DtitleTableView.dequeueReusableCell(withIdentifier: "DTitleCell", for: indexPath) as! DTitleTableViewCell
            cell.DTitleLabel.text = DTitle
            cell.DTitleDate.text = "\(DTitleTime) - \(DtitleEnd)"
            cell.DTitleLabel.textColor = .white
            cell.DTitleDate.textColor = .white
            cell.DtitleIDLabel.text = String(passedIndex)
            cell.DtitleIDLabel.alpha = 0

            
            var rect = cell.DTitleChart.bounds
            rect.origin.y += 4
            rect.size.height -= 4
            let chartView = HorizontalBarChartView(frame: rect)
            chartView.notifyDataSetChanged()
            
            chartView.data?.notifyDataChanged()
            var entry = [BarChartDataEntry(x: 1, y: Double(totalTime) / 3600)]
            print(entry)
            let set = BarChartDataSet(values: entry, label: "")
            //y軸の設定
            
            chartView.leftAxis.axisMaximum = Double(purposeTime / 3600)
            chartView.rightAxis.axisMaximum = Double(purposeTime / 3600)
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.axisMinimum = 0
            
            
            chartView.data = BarChartData(dataSet: set)
            chartView.drawBordersEnabled = false
            chartView.minOffset = CGFloat(0)
            chartView.sizeToFit()
            //x軸の設
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.forceLabelsEnabled = false
            chartView.xAxis.drawLabelsEnabled = false
            chartView.drawBarShadowEnabled = false
            chartView.legend.enabled = false
            chartView.highlightPerTapEnabled = false
            chartView.drawGridBackgroundEnabled = false
            chartView.leftAxis.enabled = false
            set.drawValuesEnabled = false
            chartView.descriptionTextPosition = nil
            chartView.accessibilityLabel = ""
            chartView.chartDescription?.text = ""
            chartView.animate(yAxisDuration: 2.0)
            chartView.setExtraOffsets(left: 5, top: 0, right: 5, bottom: 15)
            
            
            if DcardDesing == "青"{
                cell.backgroundColor = UIColor(colorLiteralRed: 149/255, green: 191/255, blue: 220/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 159/255, green: 152/255, blue: 201/255, alpha: 1)]
            } else if DcardDesing == "赤"{
                cell.backgroundColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 228/255, green: 182/255, blue: 136/255, alpha: 1)]
            } else if DcardDesing == "黄色"{
                cell.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 212/255, blue: 102/255, alpha: 1)
            set.colors = [UIColor(colorLiteralRed: 216/255, green: 194/255, blue: 39/255, alpha: 1)]
            } else {
                cell.backgroundColor = UIColor(colorLiteralRed: 86/255, green: 186/255, blue: 154/255, alpha: 1)
                            set.colors = [UIColor(colorLiteralRed: 77/255, green: 122/255, blue: 113/255, alpha: 1)]
            }
////////////バグ
            chartView.leftAxis.labelCount = 5
            chartView.rightAxis.labelCount = 5
            
            set.formLineWidth = 3
            set.formSize = 10
            set.valueTextColor = UIColor.clear
            cell.DTitleChart.noDataText = ""
            var subviews = cell.DTitleChart.subviews
            for subview in subviews {
                subview.removeFromSuperview()
            }
            cell.DTitleChart.addSubview(chartView)
            return cell
            
        } else if tableView.tag == 2{
            let cell = ProcessTableView.dequeueReusableCell(withIdentifier: "ProcessCell", for: indexPath) as! ProcessTableViewCell
            cell.ProLabel.text = ProTitle[indexPath.row]
            cell.ProTimeLabel.text = "\(ProTime[indexPath.row]) - \(ProEndTime[indexPath.row])"
            cell.ProTimeLabel.alpha = 1
            cell.ProLabel.textColor = .white
            cell.ProTimeLabel.textColor = .white
            cell.ProIDLabel.text = String(ProId[indexPath.row])
            cell.ProIDLabel.alpha = 0
            //色系
            if cardsDesign[indexPath.row] == "青"{
                cell.backgroundColor = UIColor(colorLiteralRed: 149/255, green: 191/255, blue: 220/255, alpha: 1)
            } else if cardsDesign[indexPath.row] == "赤"{
                cell.backgroundColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
            } else if cardsDesign[indexPath.row] == "黄色"{
                cell.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 212/255, blue: 102/255, alpha: 1)
            } else {
                cell.backgroundColor = UIColor(colorLiteralRed: 86/255, green: 186/255, blue: 154/255, alpha: 1)
            }
            return cell
        }else {
            let cell = DTitleTableViewCell()
            return cell
        }
    }
    
    
    //セルをスワイプし削除ボタンを出す
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            DtitleTableView.isEditing = false

        }
        if tableView.tag == 2 {
            if editingStyle == .delete {

                print("\(indexPath.row)行目が削除されました")
                        
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                let viewContext = appDelegate.persistentContainer.viewContext
                
                let query:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
                
                let predicate = NSPredicate(format: "id = %d", ProId[indexPath.row])
                print(ProId[indexPath.row])
                query.predicate = predicate
                do {
                    let fetchResult = try viewContext.fetch(query)
                            
                    for result:AnyObject in fetchResult {
                        
                        let record = result as! NSManagedObject
                        viewContext.delete(record)
                                
                    }
                    try viewContext.save()
                            
                    ProcessTableView.reloadData()
                    print("消えたよ")
                    ProTitle.remove(at: indexPath.row)
                    ProTime.remove(at: indexPath.row)
                    ProId.remove(at: indexPath.row)
                    ProcessTableView.deleteRows(at: [indexPath], with: .fade)
                    
                }catch {
                    print("read失敗")
                }
            }
            
        }
    }
    
    //処理完結してる
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンス(オブジェクト)を取得
        //as!DetailViewControllerがダウンキャスト変換している箇所
        if segue.identifier == "toDProcess" {
            //プロセスタップ
            let toProcess: ProcessViewController = segue.destination as! ProcessViewController
            toProcess.passedProcess = selectedProcess
            toProcess.tasksID = passedIndex
        } else if segue.identifier == "moveCreate" {
            //タスクタップ
            let moveCreate: CreateViewController = segue.destination as! CreateViewController
            moveCreate.passedID = passedIndex
        }else if segue.identifier == "toTimeLog"{
            let toTimeLog: timeLogViewController = segue.destination as! timeLogViewController
            toTimeLog.passedIndex = passedIndex
            print(passedIndex)
        }
    }
    //タイムログバタンが押された時の処理（ただの移動）
    @IBAction func tapToTimeLog(_ sender: UIButton) {
        performSegue(withIdentifier: "toTimeLog", sender: nil)
    }
    
    //プロセス追加ボタンを押した時の処理（ただの移動）
    @IBAction func tapButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDProcess", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            performSegue(withIdentifier: "moveCreate", sender: nil)
        } else if tableView.tag == 2 {
            selectedProcess = ProId[indexPath.row]
            performSegue(withIdentifier: "toDProcess", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
