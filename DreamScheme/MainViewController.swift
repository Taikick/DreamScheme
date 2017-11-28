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

    
    
    
    var selectedIndex = -1
    
    @IBOutlet weak var myButton: UIButton!
    
    
    
    
    var entry:[[BarChartDataEntry]] = [
        
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)],
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)],
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)],
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)],
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)],
        [BarChartDataEntry(x: 1, y: 3.0)],
        [BarChartDataEntry(x: 1, y: 80.0)],
        [BarChartDataEntry(x: 1, y: 10.0)]
    ]
    
    var cardsDesign:[String] = []
    
    var hometitles:[String] = []
    
    var homeTime:[String] = []
    
    var homeLastTime:[String] = []
    
    
    //時間のラベル
    @IBOutlet weak var timeHour: UILabel!
    
    //分のラベル
    @IBOutlet weak var timeMinute: UILabel!
    
    //秒のラベル
    @IBOutlet weak var timeSecond: UILabel!
    
    
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var myBarButton: UIBarButtonItem!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        read()
    }
    
    //timerの変数
    var timer:Timer!
    var startTime = Date()
    //ストップウォッチボタンが押された時の処理
    @IBAction func tapWatch(_ sender: Any) {
        
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        if myBarButton.title == "タスク開始" {
            
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.timerCounter),
                userInfo: nil,
                repeats: true)
            startTime = Date()
            myBarButton.title = "タスク終了"
        } else {
            if timer != nil{
                timer.invalidate()
                timeHour.text = "00"
                timeMinute.text = "00"
                timeSecond.text = "00"
            }
            myBarButton.title = "タスク開始"
        }
    }
    
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
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
        
        timeHour.text = sHour
        timeMinute.text = sMin
        timeSecond.text = sSecond
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
          read()
//        print("ホームタイム\(homeTime.count)")
//        print("ホームタイトル\(hometitles.count)")
//        print("ホームラストタイム\(homeLastTime.count)")
//        print(cardsDesign)
        //fontawesomeをボタンに使う
        myButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        myButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        myButton.setTitleColor(UIColor.blue, for: .normal)
        //バーボタンの文字列決定
        myBarButton.title = "タスク開始"
        
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(red: 129/255, green: 212/255, blue: 78/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor.white
        //バーの左側にボタンを配置します(ライブラリ特有)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))

    }
    override func viewWillAppear(_ animated: Bool) {
        homeTableView.reloadData()
        read()
//        timer.invalidate()
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
        var rect = cell.BarChrats.bounds
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
        cell.BarChrats.noDataText = ""
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
        cell.BarChrats.addSubview(chartView)
        return cell
    }
    
    //セルが押された時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目")
        //セグウェを使って移動する時に値を渡す
        selectedIndex = indexPath.row
        //選択された行番号をほぞん
        
        //セグエに名前を指定して画面遷移処理を発動
        performSegue(withIdentifier: "toCreate", sender: nil)
    }
    
    
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンス(オブジェクト)を取得
        //as!DetailViewControllerがダウンキャスト変換している箇所
        if segue.identifier == "toEdit"{
            let toCreate: CreateViewController = segue.destination as! CreateViewController
            //次の画面のプロパティ（メンバ変数）passedIndexに選択された行番号を渡す

        }
        
        if segue.identifier == "toCreate" {
            
            let toEdit: editViewController = segue.destination as! editViewController
            toEdit.passedIndex = selectedIndex
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            hometitles.remove(at: indexPath.row)
            homeTime.remove(at: indexPath.row)
            entry.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
