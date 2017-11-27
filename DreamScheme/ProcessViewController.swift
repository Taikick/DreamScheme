//
//  ProcessViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/21.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData

class ProcessViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var startTextFiled: UITextField!
    @IBOutlet weak var EndTextField: UITextField!
    @IBOutlet weak var WeekTextField: UITextField!
    @IBOutlet weak var DayTextField: UITextField!
    @IBOutlet weak var CardTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    var NDArray = [
        "毎日","月曜","水曜","火曜","水曜","木曜","金曜","土曜","日曜"
    ]
    var NTArray = [
        "午前0時","午前1時","午前2時","午前3時","午前4時","午前5時","午前6時","午前7時","午前8時","午前9時",
        "午前10時","午前11時","午後0時","午後1時","午後2時","午後3時","午後4時","午後5時","午後6時","午後7時","午後8時","午後9時","午後10時","午後11時"
    ]

    var cardArray = [
        "赤","青","黄色","緑"
    ]

    

    var passedProcess = -1
    
    var startPicker = Date()
    var endPicker = Date()
    
    var myDatePicker = UIDatePicker()
    let pickerView = UIPickerView()

    
    var vi = UIView()
    
    let df = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)

    }
    
    func forTextFiled(textField:UITextField){
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
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ProcessViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProcessViewController.cancelPressed))
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
        vi = UIView(frame: myDatePicker.bounds)
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
        case 2:
            return NDArray.count
        case 3:
            return NTArray.count
        case 4:
            return cardArray.count
        default:
            return 0
        }

    }

    

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch pickerView.tag {
        case 2:
            return NDArray[row]
        case 3:
            return NTArray[row]
        case 4:
            return cardArray[row]
        default:
            return "hoge"
        }

    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        vi.removeFromSuperview()
        startTextFiled.resignFirstResponder()
        EndTextField.resignFirstResponder()
        WeekTextField.resignFirstResponder()
        DayTextField.resignFirstResponder()
        CardTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        switch textField.tag {
        case 0:
            forDatePicker(textField:startTextFiled)
            return false
        case 1:
            forDatePicker(textField:EndTextField)
            return false
        case 2:
            forTextFiled(textField:WeekTextField)
            return false
        case 3:
            forTextFiled(textField:DayTextField)
            return false
        case 4:
            forTextFiled(textField:CardTextField)
            return false
        default:
            return true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 2:
            WeekTextField.text = NDArray[row]
        case 3:
            DayTextField.text = NTArray[row]
        case 4:
            CardTextField.text = cardArray[row]
            
        default:
            print("それ以外")
        }
    }
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        
        // フォーマットを設定
        print(df.string(from: sender.date))
        
        let strSelectedDate = df.string(from: sender.date)
        if myDatePicker.tag == 0{
            startTextFiled.text = strSelectedDate
            startPicker = myDatePicker.date
            print(startTextFiled.text)
        } else if myDatePicker.tag == 1 {
            EndTextField.text = strSelectedDate
            endPicker = myDatePicker.date
        }
    }

    
    @IBAction func tapAdd(_ sender: UIButton) {
        print("追加ボタンが押されました")
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let forProcess = NSEntityDescription.entity(forEntityName: "ForProcess", in: viewContext)
        
        let newProcess = NSManagedObject(entity: forProcess!, insertInto: viewContext)
//        newProcess.setValue(, forKey: )
//        print()
        newProcess.setValue(titleTextField.text!, forKey: "title")
        print(titleTextField.text!)
        newProcess.setValue(startPicker, forKey: "processSrart")
        print(startPicker)
        newProcess.setValue(endPicker, forKey: "processEnd")
        print(endPicker)
        
//        newProcess.setValue(, forKey: "forTaskID")
        //print()
        
    }
    
    @IBAction func tapReturn(_ sender: UITextField) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
