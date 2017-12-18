//
//  CreateViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices
import UserNotifications  //ローカル通知に必要なフレームワーク


class CreateViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var createTextFiled: UITextField!
    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var cardTextField: UITextField!
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    @IBOutlet weak var dayCountTextField: UITextField!
    
    @IBOutlet weak var noticeDayTextField: UITextField!
    
    
    let pickerView:UIPickerView! = UIPickerView()
    var myDatePicker = UIDatePicker()
    
    var homeTitle = ""
    
    var Time1:[Int] = [0,1,2,3,4,5,6,7,8,9]
    var Time2:[Int] = [0,1,2,3,4,5,6,7,8,9]
    var Time3:[Int] = [0,1,2,3,4,5,6,7,8,9]
    var Time4:[Int] = [0,1,2,3,4,5,6,7,8,9]
    var Time5:[Int] = [0,1,2,3,4,5,6,7,8,9]
    
    var select1 = 0
    var select2 = 0
    var select3 = 0
    var select4 = 0
    var select5 = 0
    
    
    
    var purposeTime = 0
    
    //for文で回して値とってる
    var NTArray:[Int] = []
    
    var NTMArray:[Int] = []
    
    var startDay = ""
    
    var endDay = ""
    
    var cardArray = ["赤","青","黄色","緑"]
    
    var startPicker:Date = Date()

    var endPicker:Date = Date()
    
    //
    var id = 0
    
    //editからもらったタスクID
    var passedID = -1
    let df = DateFormatter()
    
    var noticeHour = 0
    
    var noticeMinute = 0
    
    let mySystemButton:UIButton = UIButton(type: .system)
    let baseView:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    let pickerBase:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    let pickerSystemButton:UIButton = UIButton(type: .system)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...23{
            NTArray.append(i)
        }
        for i in 0...59{
            NTMArray.append(i)
        }
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]){(granted,error) in }

        // イベントの追加
        myDatePicker.datePickerMode = UIDatePickerMode.date
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        //選択可能な最大値(2017/12/31)
        myDatePicker.maximumDate = df.date(from: "2030/12/31")
        baseView.addSubview(myDatePicker)
        mySystemButton.frame = CGRect(x: self.view.frame.width-60, y: 0, width: 50, height: 20)
        mySystemButton.setTitle("Close", for: .normal)
        mySystemButton.addTarget(self, action: #selector(closeDatePickerView(sender:)), for: .touchUpInside)
        baseView.addSubview(mySystemButton)
        //下にピッタリ配置、横幅ピッタリの大きさにしておく
        baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        
        baseView.frame.size = CGSize(width: self.view.frame.width, height: baseView.frame.height)
        
        baseView.backgroundColor = UIColor.gray
        self.view.addSubview(baseView)
        
        
        //ピッカービューの設定
        pickerView.delegate   = self
        pickerView.dataSource = self
        pickerBase.addSubview(pickerView)
        pickerSystemButton.frame = CGRect(x: self.view.frame.width-60, y: 0, width: 50, height: 20)
        self.navigationItem.title = "タスク設定"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 15)!]
        

    }

    
    override func viewDidAppear(_ animated: Bool) {
        select1 = 0
        select2 = 0
        select3 = 0
        select4 = 0
        select5 = 0
        
        //toInt()
        print(passedID)
        
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");
        if passedID != -1 {
            isData()
            
            print("\(purposeTime)時間")
            addButton.setTitle("更新", for: .normal)
        }else{
            dayCountTextField.text = "\(select1)\(select2)\(select3)\(select4)\(select5)時間"
            noticeDayTextField.text = "\(NTArray[11])時"
            cardTextField.text = cardArray[0]
            dayCountTextField.text = "\(purposeTime)時間"
            
            myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
            df.dateFormat = "yyyy/MM/dd"
            df.locale = Locale(identifier: "ja_JP")
            myDatePicker.date = df.date(from: "2018/01/01")!
            startDay = df.string(from: myDatePicker.date)
            endDay = df.string(from: myDatePicker.date)
            startTextField.text = startDay
            endTextField.text = endDay
            
            addButton.setTitle("追加", for: .normal)
            pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
            myDatePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: myDatePicker.bounds.size.height)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    func isData(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        let predicate = NSPredicate(format: "id = %d",passedID)
        query.predicate = predicate
        do {
            let fetchResult = try viewContext.fetch(query)
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            df.locale = Locale(identifier:"ja_jp")
            for result:AnyObject in fetchResult {
                
                homeTitle = result.value(forKey: "title") as! String
                var forCard:String? = result.value(forKey: "cardDesign") as! String
                var forStart:Date? = result.value(forKey: "startDate") as! Date
                var forEnd:Date? = result.value(forKey: "endDate") as! Date
                noticeHour = result.value(forKey:"noticeHour") as! Int
                
                noticeMinute = result.value(forKey:"noticeMinute") as! Int
                
                purposeTime = result.value(forKey:"totalTime") as! Int
                
                var forDecide:Bool? = result.value(forKey:"forNotice" ) as! Bool?
                
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && homeTitle != nil && forCard != nil {
                    
                    createTextFiled.text = homeTitle
                    cardTextField.text = forCard!
                    startTextField.text = df.string(from: forStart!)
                    endTextField.text = df.string(from: forEnd!)
                    toUpdateSelect()
                    print("1:\(select1)")
                    print("2:\(select2)")
                    print("3:\(select3)")
                    print("4:\(select4)")
                    print("5:\(select5)")
                    dayCountTextField.text = "\(purposeTime / 3600)時間"
                    
                    
                    noticeSwitch.isOn = forDecide!
                    if noticeHour != nil && noticeSwitch.isOn == true && noticeMinute != nil{
                        noticeDayTextField.text = "\(noticeHour)時\(noticeMinute)分"
                    }
                    
                }
            }
        }catch {
            print("read失敗")
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch  pickerView.tag{
        case 4:
            return 6
            
        case 5:
            return 2
        default:
        
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return 0
        case 2:
            return 0
        case 4:
            if component == 5{
                return 1
            }
            return 10
        case 5:
            if component == 0{
                return NTArray.count
            }
            return NTMArray.count

            
        case 7:
            return cardArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return ""
        case 2:
            return ""
        case 4:
            if component == 0 {
                return String(Time1[row])
            }else if component == 1{
                return String(Time2[row])
            }else if component == 2{
                return String(Time3[row])
            }else if component == 3{
                return String(Time4[row])
            }else if component == 4{
                return String(Time5[row])
            }else {
                return "時間"
            }
            
        case 5:
            if component == 0{
                return "\(NTArray[row])時"
            }else {
                return "\(NTMArray[row])分"
            }
            
        case 7:
            return cardArray[row]
        default:
            return ""
        }
        
    }
    
    //列の幅
    func pickerView(pickerView: UIPickerView, widthForComponent component:Int) -> CGFloat {
        
        //サンプル
        switch pickerView.tag {
        case 1:
            return 100
        case 2:
            return 100
        case 4:
            if component == 0{
                return 5
            }else if component == 1{
                return 5
            }else if component == 2{
                return 5
            }else if component == 3{
                return 5
            }else if component == 4{
                return 5
            } else{
                return 5
            }
            return 10
        default:
            return 100
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        myDatePicker.tag = textField.tag
        pickerView.tag = textField.tag

        hideBaseView()
        hidePicker()
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        dayCountTextField.resignFirstResponder()
        cardTextField.resignFirstResponder()
        createTextFiled.resignFirstResponder()
        noticeDayTextField.resignFirstResponder()
        switch textField.tag {
        case 0:
            return true
        case 1:
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.baseView.frame.height)
            }, completion: {finished in print("上に現れました")})
            return false
        case 2:
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.baseView.frame.height)
            }, completion: {finished in print("上に現れました")})
            return false

        case 4:
            forPickerView(textField: dayCountTextField)
            return false
        case 5:
            forPickerView(textField: noticeDayTextField)
            return false
        case 6:
            return false
        case 7:
            forPickerView(textField: cardTextField)
            return false
        default:
            return true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
            
        case 4:
            if component == 0 {
                
                // 1桁のピッカーの設定
                select1 = Time1[row]
            }else if component == 1{
                // 2桁のピッカーの設定
                select2 = Time2[row]
            }else if component == 2{
                // 3桁のピッカーの設定
                select3 = Time3[row]
            }else if component == 3{
                // 4桁のピッカーの設定
                select4 = Time4[row]
            }else if component == 4{
                // 5桁のピッカーの設定
                select5 = Time5[row]
            }
            dayCountTextField.text = "\(select1)\(select2)\(select3)\(select4)\(select5)時間"
        case 5:
            if component == 0 {
                // 1桁のピッカーの設定
                noticeHour = NTArray[row]
            }else if component == 1{
                // 2桁のピッカーの設定
                noticeMinute = NTMArray[row]
            }
            noticeDayTextField.text = "\(noticeHour)時\(noticeMinute)分"
        case 7:
            cardTextField.text! = cardArray[row]
            print(cardTextField.text!)
            
        default:
            print("それ以外")
        }
        
    }
    
    
    //ピッカーの中の数を計算してINTにぶち込む
    func toInt() {
        
        var tenThou = select1 * 10000
        var thou = select2 * 1000
        var hund = select3 * 100
        var ten = select4 * 10
        var one = select5
        var purposeSec = tenThou + thou + hund + ten + one
        purposeTime = purposeSec * 3600
        
    }
    
    func toUpdateSelect(){
        
        print("これ\(purposeTime / 3600)")
        var puroposeHour = purposeTime / 3600
        select1 =  puroposeHour / 10000
        var option1 = puroposeHour % 10000
        select2 = option1 / 1000
        var option2 = option1 % 1000
        select3 = option2 / 100
        var option3 = option2 % 100
        select4 = option3 / 10
        var option4 = option3 % 10
        select5 = option4
        
    }
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        print(df.string(from: sender.date))
        // フォーマットを設定
        if myDatePicker.tag == 1 {
            print("スタート\(df.string(from: sender.date))")
            startTextField.text = df.string(from: sender.date)
            startPicker = myDatePicker.date
            
        } else if myDatePicker.tag == 2{
            print("エンド\(df.string(from: sender.date))")
            endTextField.text = df.string(from: sender.date)
            endPicker = myDatePicker.date
            
        }
    }
  
    //baseViewを隠す
    func hideBaseView(){
        self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
    }
    
    //
    func hidePicker(){
        self.pickerBase.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
    }
    
    //DatePickerが載っているViewを閉じる
    func closeDatePickerView(sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
        }, completion: {finished in print("下に隠れました")})
    }
    
    func closePickerView(sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.pickerBase.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
        }, completion: {finished in print("下に隠れました")})
    }

    //通知用のスイッチ
    @IBAction func AlertSwitch(_ sender: UISwitch) {
        if sender.isOn {
            noticeSwitch.isOn = true
            
            // Notificationのインスタンス作成
            let content = UNMutableNotificationContent()
            
            // タイトル設定
            content.title = "\(homeTitle)の時間です！"
            
            // 本文設定
            content.body = "今日も一日頑張りましょう！"
            
            // 音設定
            content.sound = UNNotificationSound.default()
            
            let date = DateComponents(hour:noticeHour, minute:noticeMinute)
            // トリガー設定（いつ発火するかの設定。今回は10秒後)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
            
            // リクエストの生成（通知IDをセット）
            let request = UNNotificationRequest.init(identifier: "\(homeTitle)", content: content, trigger: trigger)
            
            // 通知のセット
            let center = UNUserNotificationCenter.current()
            center.add(request){(error) in }
            
        }else{
            print("通知スイッチオフ")
            noticeSwitch.isOn = false
            
        }
        
    }
    
    func forPickerView(textField:UITextField){
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        pickerBase.backgroundColor = UIColor.white
        pickerBase.addSubview(pickerView)
        
        textField.inputView = pickerBase
        pickerSystemButton.setTitle("Close", for: .normal)
        pickerSystemButton.addTarget(self, action: #selector(closePickerView(sender:)), for: .touchUpInside)
        pickerBase.addSubview(pickerSystemButton)
        //下にピッタリ配置、横幅ピッタリの大きさにしておく
        pickerBase.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        pickerBase.frame.size = CGSize(width: self.view.frame.width, height: baseView.frame.height)
        pickerBase.backgroundColor = UIColor.gray
        self.view.addSubview(pickerBase)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.pickerBase.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.pickerBase.frame.height)
        }, completion: {finished in print("上に現れました")})
    }
    
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            for result:AnyObject in fetchResults {
                var vId:Int = (result.value(forKey:"id") as? Int)!
                if vId > id {
                    id = vId
                }
            }
                
        }catch {
            print("read失敗")
        }
    }
    
    //追加ボタンが押された時にコアデータにデータを挿入する
    @IBAction func taskAddButton(_ sender: UIButton) {
        print(passedID)
        //すでにデータが存在する場合
        if passedID != -1 {
            print("更新ボタンが押されました")
            
            toInt()

            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
            let predicate = NSPredicate(format: "id = %d",passedID)
            query.predicate = predicate
            do{
                let fetchResult = try viewContext.fetch(query)
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    record.setValue(createTextFiled.text!,forKey:"title")
                    record.setValue(startPicker,forKey:"startDate")
                    record.setValue(endPicker,forKey:"endDate")
                    record.setValue(cardTextField.text, forKey: "cardDesign")
                    record.setValue(noticeSwitch.isOn, forKey: "forNotice")
                    //通知の日時
                    record.setValue(noticeHour, forKey: "noticeHour")
                    record.setValue(noticeMinute, forKey: "noticeMinute")
                    print("1:\(select1)")
                    print("2:\(select2)")
                    print("3:\(select3)")
                    print("4:\(select4)")
                    print("5:\(select5)")
                    //目標時間の設定
                    record.setValue(purposeTime, forKey: "totalTime")
                }
                
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
                
            }catch {
                print("接続失敗")
            }
            
        //新規登録の場合
        }else {
            if createTextFiled.text != "" && startTextField.text != "" && endTextField.text != "" && dayCountTextField.text != "" && cardTextField.text != "" {
                
                print("追加ボタンが押されました")
                read()
                toInt()
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
                let viewContext = appDelegate.persistentContainer.viewContext
        
                let forTask = NSEntityDescription.entity(forEntityName: "ForTasks", in: viewContext)
        
                let newTask = NSManagedObject(entity: forTask!, insertInto: viewContext)
        
                newTask.setValue(createTextFiled.text!,forKey:"title")
                newTask.setValue(false, forKey: "doneID")
                newTask.setValue(startPicker,forKey:"startDate")
                newTask.setValue(endPicker,forKey:"endDate")
                //あとid入れる
                newTask.setValue(id + 1,forKey:"id")
                print(id)
                newTask.setValue(cardTextField.text, forKey: "cardDesign")
                //通知スイッチの値を入れる
                newTask.setValue(noticeSwitch.isOn, forKey: "forNotice")
                newTask.setValue(noticeHour, forKey: "noticeHour")
                newTask.setValue(noticeMinute, forKey: "noticeMinute")
                newTask.setValue(Date(), forKey: "created_at")
                newTask.setValue(purposeTime, forKey: "totalTime")
                newTask.setValue(0, forKey: "totalDoneTime")
                
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
                
            //アラート出す
            }else {
                let alert = UIAlertController(title: "Invailed", message: "空欄があります", preferredStyle: .alert)
                //アラートにOKボタンを追加
                //handler : OKボタンが押された時に行いたい処理を指定する場所
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in print("OK押されました")}))
                //アラートを表示する処理
                //completion : 動作が完了した後に発動するメソッド
                //animated :
                present(alert, animated: true, completion: {() -> Void in print("アラートが表示されました") })
                
            }
        }
    }
    
    //キーボードを出た時に下がる処理
    @IBAction func returnFinish(_ sender: UITextField) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
