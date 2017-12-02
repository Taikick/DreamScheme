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
    
    
    
    var entry = [BarChartDataEntry(x: 1, y: 80.0)]
    
    var cardsDesign:[String] = []
    
    var DTitle:String = ""
    
    var DTitleTime:String = ""
    
    var DtitleEnd:String = ""
    
    var titleID = 0
    
    var DcardDesing = ""
    

    var ProTitle:[String] = [
    ]
    
    var ProTime:[String] = [

    ]
    
    var ProEndTime:[String] = []
    
    var ProId:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedIndex)
        readTitle()
        read()
        print(ProTitle)
        //fontawesomeをボタンに使う
        addProButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        addProButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        addProButton.setTitleColor(UIColor.blue, for: .normal)
    }
    
    //ボタンを押した時の処理
    
    @IBAction func tapButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDProcess", sender: nil)
    }

    
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
                
                print(hometitle)
                var forCard:String? = result.value(forKey: "cardDesign") as? String
                print(forCard)
                
                var forStart:Date? = result.value(forKey: "startDate") as? Date
                print(forStart)
                
                var forEnd:Date? = result.value(forKey: "endDate") as? Date
                print(forEnd)
                var id: Int = (result.value(forKey: "id") as? Int)!
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier:"ja_jp") as Locale!
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil && id != nil {
                    
                    DTitle = hometitle!
                    DcardDesing = forCard!
                    DTitleTime = df.string(from: forStart!)
                    DtitleEnd = df.string(from: forEnd!)
                    titleID = id
                    
                }
            }
        }catch {
            print("read失敗")
        }
    }
    
    
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
                
                print(protitle)
                var forCard:String? = result.value(forKey: "processCard") as? String
                print(forCard)
                
                var forStart:Date? = result.value(forKey: "processSrart") as? Date
                print(forStart)
                
                var forEnd:Date? = result.value(forKey: "processEnd") as? Date
                print(forEnd)
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

    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return 1
        }else if tableView.tag == 2{
            return ProTime.count
        }else {
            return 0
        }
    
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if tableView.tag == 1 {
            let cell = DtitleTableView.dequeueReusableCell(withIdentifier: "DTitleCell", for: indexPath) as! DTitleTableViewCell
            cell.DTitleLabel.text = DTitle
            cell.DTitleDate.text = DTitleTime
            cell.DtitleIDLabel.text = String(passedIndex)
            cell.DtitleIDLabel.alpha = 0
            if DcardDesing == "青"{
                cell.backgroundColor = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
            } else if DcardDesing == "赤"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5359856592)
            } else if DcardDesing == "黄色"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.7487157534)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 0.6764501284)
            }
            
            var rect = cell.DTitleChart.bounds
            rect.origin.y += 4
            rect.size.height -= 4
            let chartView = HorizontalBarChartView(frame: rect)
            let set = BarChartDataSet(values: entry, label: "タスク時間")
            chartView.data = BarChartData(dataSet: set)
            chartView.drawBordersEnabled = false
            chartView.minOffset = CGFloat(0)
            chartView.sizeToFit()
            //x軸の設
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.forceLabelsEnabled = false
            chartView.xAxis.drawLabelsEnabled = false
            chartView.accessibilityLabel = ""
            chartView.chartDescription?.text = ""
            chartView.animate(yAxisDuration: 2.0)
            //        chartView.xAxis.labelCount = 100
            //        chartView.xAxis.axisMinimum = 1
            //y軸の設定
            chartView.leftAxis.labelCount = 5
            chartView.leftAxis.axisMinimum = 0
            chartView.leftAxis.axisMaximum = 100
            chartView.rightAxis.labelCount = 5
            chartView.rightAxis.axisMinimum = 0
            chartView.rightAxis.axisMaximum = 100.0
            chartView.leftAxis.axisMinimum = 0
            set.formLineWidth = 3
            set.formSize = 10
            cell.DTitleChart.noDataText = ""
            cell.DTitleChart.addSubview(chartView)
            return cell
            
        } else if tableView.tag == 2{
            let cell = ProcessTableView.dequeueReusableCell(withIdentifier: "ProcessCell", for: indexPath) as! ProcessTableViewCell
            cell.ProLabel.text = ProTitle[indexPath.row]
            cell.ProTimeLabel.text = "\(ProTime[indexPath.row]) - \(ProEndTime[indexPath.row])"
            cell.ProIDLabel.text = String(ProId[indexPath.row])
            //色系
            if cardsDesign[indexPath.row] == "青"{
                cell.backgroundColor = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
            } else if cardsDesign[indexPath.row] == "赤"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5359856592)
            } else if cardsDesign[indexPath.row] == "黄色"{
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.7487157534)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 0.6764501284)
            }
            return cell
        }else {
            let cell = DTitleTableViewCell()
            return cell
        }
    }
    //テーブルをスワイプし削除ボタンを出す
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView.tag == 2 {
                ProTitle.remove(at: indexPath.row)
                ProTime.remove(at: indexPath.row)
                ProcessTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            performSegue(withIdentifier: "moveCreate", sender: nil)
        } else if tableView.tag == 2 {
            print(ProId[indexPath.row])
            selectedProcess = ProId[indexPath.row]
            performSegue(withIdentifier: "toDProcess", sender: nil)
        }
        //セグエに名前を指定して画面遷移処理を発動

    }
    
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンス(オブジェクト)を取得
        //as!DetailViewControllerがダウンキャスト変換している箇所
        if segue.identifier == "toDProcess" {
            
            let toProcess: ProcessViewController = segue.destination as! ProcessViewController
            toProcess.passedProcess = selectedProcess
        } else if segue.identifier == "moveCreate" {
            
            let moveCreate: CreateViewController = segue.destination as! CreateViewController
            moveCreate.passedID = passedIndex
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
