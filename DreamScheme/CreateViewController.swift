//
//  CreateViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData

class CreateViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var createTextFiled: UITextField!
    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var weekCountTextField: UITextField!

    @IBOutlet weak var dayCountTextField: UITextField!
    
    @IBOutlet weak var noticeDayTextField: UITextField!
    
    @IBOutlet weak var noticeTimeTextField: UITextField!
    
    @IBOutlet weak var cardTextField: UITextField!
    var textField = UITextField()
    
    
    let pickerView = UIPickerView()
    var myDatePicker = UIDatePicker()
    
    let todoWeekArray = ["毎日","1回","2回","3回","4回","5回","6回"]
    
    let todoDayArray = ["1時間","2時間","3時間","4時間","5時間","6時間","7時間","8時間","9時間","10時間","11時間","12時間","13時間","4時間","15時間","16時間","17時間","18時間","19時間","20時間","21時間","22時間","23時間","24時間"]
    
    var NDArray = ["毎日","月曜","水曜","火曜","水曜","木曜","金曜","土曜","日曜"]
    var NTArray = [
        "午前0時","午前1時","午前2時","午前3時","午前4時","午前5時","午前6時","午前7時","午前8時","午前9時",
        "午前10時","午前11時","午後0時","午後1時","午後2時","午後3時","午後4時","午後5時","午後6時","午後7時","午後8時","午後9時","午後10時","午後11時"
    ]
    
    var cardArray = ["赤","青","黄色","緑"]

    
    var passedTitle = -1
    let df = DateFormatter()
    var vi = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)

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
        myDatePicker.minimumDate = df.date(from: "2017/12/01")
        
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
            return todoWeekArray.count
        case 4:
            return todoDayArray.count
        case 5:
            return NDArray.count
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
        case 3:
            return todoWeekArray[row]
        case 4:
            return todoDayArray[row]
        case 5:
            return NDArray[row]
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
        weekCountTextField.resignFirstResponder()
        dayCountTextField.resignFirstResponder()
        cardTextField.resignFirstResponder()
        createTextFiled.resignFirstResponder()
        noticeDayTextField.resignFirstResponder()
        noticeTimeTextField.resignFirstResponder()
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
            forPickerView(textField:weekCountTextField)
            return false
        case 4:
            forPickerView(textField: dayCountTextField)
            return false
        case 5:
            forPickerView(textField: noticeDayTextField)
            return false
        case 6:
            forPickerView(textField: noticeTimeTextField)
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
        case 3:
            weekCountTextField.text = todoWeekArray[row]
        case 4:
            dayCountTextField.text = todoDayArray[row]
        case 5:
            noticeDayTextField.text = NDArray[row]
        case 6:
            noticeTimeTextField.text = NTArray[row]
        case 7:
            cardTextField.text = cardArray[row]
            
        default:
            print("それ以外")
        }

        
    }
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        
        // フォーマットを設定
        print(df.string(from: sender.date))
        
        let strSelectedDate = df.string(from: sender.date)
        if myDatePicker.tag == 1{
            startTextField.text = strSelectedDate
            
        } else if myDatePicker.tag == 2 {
            endTextField.text = strSelectedDate
        }
    }

    //繰り返し処理を行うスイッチ
    @IBAction func tapForSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("繰り返しスイッチオン")
        }else{
            print("繰り返しスイッチオフ")
        }
    }
    
    //通知用のスイッチ
    @IBAction func AlertSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("通知スイッチオン")
        }else{
            print("通知スイッチオフ")
        }
        
    }
    
    //追加ボタンが押された時にコアデータにデータを挿入する
    @IBAction func taskAddButton(_ sender: UIButton) {
        print("追加ボタンが押されました")
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let forTask = NSEntityDescription.entity(forEntityName: "ForTasks", in: viewContext)
        
        let newTask = NSManagedObject(entity: forTask!, insertInto: viewContext)
        newTask.setValue(createTextFiled.text,forKey:"title")
        
        if myDatePicker.tag == 1{
        newTask.setValue(myDatePicker.date,forKey:"startDate")
            print(myDatePicker.date)
        } else {
        newTask.setValue(myDatePicker.date,forKey:"endDate")
            print(myDatePicker.date)
        }
        //あとid入れる
        do{
            try viewContext.save()
        }catch {
            print("接続失敗")
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
