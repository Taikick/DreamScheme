//
//  CreateViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

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
    
    let todoWeekArray = ["毎日","1回","2回","3回","4回","5回","6回"]
    
    let todoDayArray = ["1時間","2時間","3時間","4時間","5時間","6時間","7時間","8時間","9時間","10時間","11時間","12時間","13時間","4時間","15時間","16時間","17時間","18時間","19時間","20時間","21時間","22時間","23時間","24時間"]
    
    var NDArray = ["毎日","月曜","水曜","火曜","水曜","木曜","金曜","土曜","日曜"]
    var NTArray = [
        "午前0時","午前1時","午前2時","午前3時","午前4時","午前5時","午前6時","午前7時","午前8時","午前9時",
        "午前10時","午前11時","午後0時","午後1時","午後2時","午後3時","午後4時","午後5時","午後6時","午後7時","午後8時","午後9時","午後10時","午後11時"
    ]
    
    var cardArray = ["赤","青","黄色","緑"]
    var array = ["楽天", "ソニー", "APPLE", "amazon", "softbank"]
    
    var passedTitle = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTextFiled.tag = 0
        startTextField.tag = 1
        endTextField.tag = 2
        weekCountTextField.tag = 3
        dayCountTextField.tag = 4
        noticeDayTextField.tag = 5
        noticeTimeTextField.tag = 6
        cardTextField.tag = 7
    }
    
    func forPickerView(textField:UITextField){
        
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        let vi = UIView(frame: pickerView.bounds)
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
    }
    func donePressed() {
        view.endEditing(true)
    }
    
    // Cancel
    func cancelPressed() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch textField.tag {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            <#code#>
        case 4:
            <#code#>
        case 5:
            return NDArray.count
        case 6:
            return NTArray.count
        case 7:
            return cardArray.count
        default:
            <#code#>
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    
    @IBAction func taskAddButton(_ sender: UIButton) {
        print("追加ボタンが押されました")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
