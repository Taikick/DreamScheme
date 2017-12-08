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

class CreateViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var createTextFiled: UITextField!
    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var cardTextField: UITextField!
    
    @IBOutlet weak var forSwitch: UISwitch!
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    @IBOutlet weak var dayCountTextField: UITextField!
    
    @IBOutlet weak var noticeDayTextField: UITextField!
    
    var textField = UITextField()
    
    
    let pickerView = UIPickerView()
    var myDatePicker = UIDatePicker()
    
    
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
    var vi = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...23{
            NTArray.append(i)
        }
        print(passedID)
        self.navigationItem.title = "タスク設定"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSFontAttributeName: UIFont(name: "Times New Roman", size: 15)!]
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        toInt()
        print(passedID)
        
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");
        if passedID != -1 {
            isData()
            addButton.titleLabel?.text = "更新"
        }else{
            dayCountTextField.text = "\(select1)\(select2)\(select3)\(select4)\(select5)時間"
            cardTextField.text = cardArray[0]
            noticeDayTextField.text = "\(NTArray[11])時"
            cardTextField.text = cardArray[0]
            myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
            df.dateFormat = "yyyy/MM/dd"
            df.locale = Locale(identifier: "ja_JP")
            myDatePicker.date = df.date(from: "2018/01/01")!
            startDay = df.string(from: myDatePicker.date)
            endDay = df.string(from: myDatePicker.date)
            startTextField.text = startDay
            endTextField.text = endDay
            
            addButton.titleLabel?.text = "追加"
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
                
                var hometitle:String? = result.value(forKey: "title") as! String
                var forCard:String? = result.value(forKey: "cardDesign") as! String
                var forStart:Date? = result.value(forKey: "startDate") as! Date
                var forEnd:Date? = result.value(forKey: "endDate") as! Date
                var switchDecide:Bool? = result.value(forKey: "forSwitch") as! Bool?
                var forDecide:Bool? = result.value(forKey:"forNotice" ) as! Bool?
                
                
                
                //nilは入らないようにする
                if forStart != nil && forEnd != nil && hometitle != nil && forCard != nil {
                    
                    createTextFiled.text = hometitle!
                    cardTextField.text = forCard!
                    startTextField.text = df.string(from: forStart!)
                    endTextField.text = df.string(from: forEnd!)
                    forSwitch.isOn = switchDecide!
                    noticeSwitch.isOn = forDecide!
                    
                }
            }
        }catch {
            print("read失敗")
        }
    }

    func forPickerView(textField:UITextField){
        
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        vi = UIView(frame: pickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView)
        
        textField.inputView = vi
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        pickerView.tag = textField.tag
        self.view.addSubview(vi)
        vi.addSubview(toolBar)
    }
    
    func forDatePicker(textField:UITextField) {
        //DateFormatterを使って文字型から日付型に変更する
        
        df.dateFormat = "yyyy/MM/dd"
        
        //選択可能な最小値を決定(2017/01/01)
        
        //選択可能な最大値(2017/12/31)
        myDatePicker.maximumDate = df.date(from: "2030/12/31")
        
        //初期値を設定
        
        myDatePicker.date = df.date(from: "2018/01/01")!
        myDatePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: myDatePicker.bounds.size.height)
        
        vi.backgroundColor = UIColor.white
        vi.addSubview(myDatePicker)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ProcessViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProcessViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        myDatePicker.tag = textField.tag
        self.view.addSubview(vi)
        vi.addSubview(toolBar)
    }
    
    func donePressed() {
        vi.removeFromSuperview()
    }
    
    // Cancel
    func cancelPressed() {
        vi.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch  pickerView.tag{
        case 4:
            return 6
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
        case 3:
            return 0
        case 4:
            if component == 5{
                return 1
            }
            return 10
        case 5:
            return NTArray.count
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
            return "\(NTArray[row])時"
        case 7:
            return cardArray[row]
        default:
            return ""
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component:Int) -> CGFloat {
        
        //サンプル
        switch pickerView.tag {
        case 1:
            return 100
        case 2:
            return 100
        case 3:
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
        
        vi.removeFromSuperview()
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
            forDatePicker(textField:startTextField)
            return false
        case 2:
            forDatePicker(textField:endTextField)
            return false
        case 3:
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
            noticeDayTextField.text = "\(NTArray[row])時"
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
        
        var purposeHour = tenThou + thou + hund + ten + one
        purposeTime = purposeHour * 3600
    }
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        
        // フォーマットを設定
        print(df.string(from: sender.date))
        
        var strSelectedDate = df.string(from: sender.date)
        if myDatePicker.tag == 1{
            startTextField.text = strSelectedDate
            startPicker = myDatePicker.date
            
        } else if myDatePicker.tag == 2 {
            endTextField.text = strSelectedDate
            endPicker = myDatePicker.date
            
        }
    }

    //繰り返し処理を行うスイッチ
    @IBAction func tapForSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("繰り返しスイッチオン")
            forSwitch.isOn = true
        }else{
            print("繰り返しスイッチオフ")
            forSwitch.isOn = false
        }
    }
    
    //通知用のスイッチ
    @IBAction func AlertSwitch(_ sender: UISwitch) {
        if sender.isOn {
            noticeSwitch.isOn = true
        }else{
            print("通知スイッチオフ")
            noticeSwitch.isOn = false
        }
        
    }
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForTasks> = ForTasks.fetchRequest()
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            for result:AnyObject in fetchResults {
                id = (result.value(forKey:"id") as? Int)!
            }
        }catch {
            print("read失敗")
        }
    }
    
    
    //追加ボタンが押された時にコアデータにデータを挿入する
    @IBAction func taskAddButton(_ sender: UIButton) {
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
                    
                    //目標時間の設定
                    record.setValue(purposeTime, forKey: "totalTime")
                    
                    record.setValue(forSwitch.isOn, forKey: "forSwitch")
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
        
                print(createTextFiled.text)
                newTask.setValue(false, forKey: "doneID")
        
                newTask.setValue(startPicker,forKey:"startDate")
                print(startPicker)
        
                newTask.setValue(endPicker,forKey:"endDate")
                print(endPicker)

                //あとid入れる
                newTask.setValue(id + 1,forKey:"id")
                print(id)
        
                newTask.setValue(cardTextField.text, forKey: "cardDesign")
                //繰り返しスイッチの値を入れる
                newTask.setValue(forSwitch.isOn, forKey: "forSwitch")
                //通知スイッチの値を入れる
                newTask.setValue(noticeSwitch.isOn, forKey: "forNotice")
        
                newTask.setValue(Date(), forKey: "created_at")
                newTask.setValue(purposeTime, forKey: "totalTime")
                
                newTask.setValue(0, forKey: "totalDoneTime")
                //通知の設定
                
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
