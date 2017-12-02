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

    @IBOutlet weak var dayCountTextField: UITextField!
    
    @IBOutlet weak var noticeDayTextField: UITextField!
    
    @IBOutlet weak var cardTextField: UITextField!
    
    @IBOutlet weak var forSwitch: UISwitch!
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    var textField = UITextField()
    
    
    let pickerView = UIPickerView()
    var myDatePicker = UIDatePicker()
    
    let todoDayArray = ["1時間","2時間","3時間","4時間","5時間","6時間","7時間","8時間","9時間","10時間","11時間","12時間","13時間","4時間","15時間","16時間","17時間","18時間","19時間","20時間","21時間","22時間","23時間","24時間"]
    
    var NTArray = [
        "午前0時","午前1時","午前2時","午前3時","午前4時","午前5時","午前6時","午前7時","午前8時","午前9時",
        "午前10時","午前11時","午後0時","午後1時","午後2時","午後3時","午後4時","午後5時","午後6時","午後7時","午後8時","午後9時","午後10時","午後11時"
    ]
    
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
        print(passedID)
        
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");
        if passedID != -1 {
            isData()
        }else{
            dayCountTextField.text = todoDayArray[0]
            cardTextField.text = cardArray[0]
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        if createTextFiled.text == "" || startTextField.text == "" || endTextField.text == "" || weekCountTextField.text == "" || dayCountTextField.text == "" || cardTextField.text == ""{
        //            addButton.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 0.1185787671)
        //            addButton.isEnabled = false
        print(passedID)
        
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");
        if passedID != -1 {
            isData()
        }else{
            dayCountTextField.text = todoDayArray[0]
            cardTextField.text = cardArray[0]
        }
        if passedID != -1{
            addButton.titleLabel?.text = "更新"
        } else {
            addButton.titleLabel?.text = "追加"
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
        return 1
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
            return todoDayArray.count
        case 6:
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
            return todoDayArray[row]
        case 6:
            return NTArray[row]
        case 7:
            return cardArray[row]
        default:
            return ""
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
            dayCountTextField.text = todoDayArray[row]
        case 7:
            cardTextField.text! = cardArray[row]
            print(cardTextField.text!)
            
        default:
            print("それ以外")
        }

        
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
        
        if passedID != -1 {
            print("更新ボタンが押されました")
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
            
            
            
        }else {
            if createTextFiled.text != nil || startTextField.text != nil || endTextField.text != nil || dayCountTextField.text != nil || cardTextField.text != nil {
                print("追加ボタンが押されました")
                read()
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
        
                
        

            
            
        
                //イメージパスと時間に０
        
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
            //アラート出す
            }else {
                
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
