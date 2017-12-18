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
    @IBOutlet weak var CardTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
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

    
    //オートインクリメント用
    var id:Int = 0
    
    //プロセス指定のID
    var passedProcess = -1
    //タスク指定のID
    var tasksID = -1
    
    var startPicker = Date()
    var endPicker = Date()
    
    var myDatePicker = UIDatePicker()
    let pickerView = UIPickerView()

    
    let mySystemButton:UIButton = UIButton(type: .system)
    let baseView:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    let pickerBase:UIView = UIView(frame: CGRect(x: 0, y: 720, width: 200, height: 250))
    let pickerSystemButton:UIButton = UIButton(type: .system)
    
    let df = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        // イベントの追加
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
        self.navigationItem.title = "プロセス設定"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if passedProcess != -1 {
            processRead()
            myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
            df.dateFormat = "yyyy/MM/dd"
            df.locale = Locale(identifier: "ja_JP");
        }else{
            CardTextField.text = cardArray[0]
        }
        if passedProcess != -1 {
            addButton.setTitle("更新", for: .normal)
            processRead()
        }else{
            addButton.setTitle("追加", for: .normal)
            CardTextField.text = cardArray[0]
        }
        
    }
    func forTextFiled(textField:UITextField){
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
        pickerView.tag = textField.tag
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.pickerBase.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.pickerBase.frame.height)
        }, completion: {finished in print("上に現れました")})
    }
    
    
    //DatePickerで、選択している日付を変えた時、日付用のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");
        print(df.string(from: sender.date))
        // フォーマットを設定
        if myDatePicker.tag == 0 {
            print("スタート\(df.string(from: sender.date))")
            startTextFiled.text = df.string(from: sender.date)
            startPicker = myDatePicker.date
            
        } else if myDatePicker.tag == 1{
            print("エンド\(df.string(from: sender.date))")
            EndTextField.text = df.string(from: sender.date)
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
    
    //PickerViewが載っているViewを閉じる
    func closePickerView(sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.pickerBase.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height)
        }, completion: {finished in print("下に隠れました")})
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
        myDatePicker.tag = textField.tag
        pickerView.tag = textField.tag
        hideBaseView()
        hidePicker()
        startTextFiled.resignFirstResponder()
        EndTextField.resignFirstResponder()
        CardTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        switch textField.tag {
        case 0:
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.baseView.frame.height)
            }, completion: {finished in print("上に現れました")})
            return false
        case 1:
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y:self.view.frame.size.height - self.baseView.frame.height)
            }, completion: {finished in print("上に現れました")})
            return false
        case 4:
            forTextFiled(textField: CardTextField)
            return false
        default:
            return true
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 4:
            CardTextField.text = cardArray[row]
            
        default:
            print("それ以外")
        }
    }
    
    func processRead(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %d",passedProcess)
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
                    titleTextField.text = protitle!
                    CardTextField.text = forCard!
                    startTextFiled.text = df.string(from: forStart!)
                    EndTextField.text = df.string(from: forEnd!)
                    
                }
                
            }
            
        }catch {
            print("read失敗")
        }
    }
    
    //データの読み込み処理
    func read(){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            
            for result:AnyObject in fetchResults {
                
                id = (result.value(forKey:"id") as? Int)!
                
            }
            
        } catch {
            print("read失敗")
        }
        print("あい\(id)")
    }
    


    
    @IBAction func tapAdd(_ sender: UIButton) {
        print("追加ボタンが押されました")
        
        if passedProcess != -1 {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            let query:NSFetchRequest<ForProcess> = ForProcess.fetchRequest()
            let predicate = NSPredicate(format: "id = %d",passedProcess)
            query.predicate = predicate
            do{
                let fetchResult = try viewContext.fetch(query)
                for result:AnyObject in fetchResult {
                    let record = result as! NSManagedObject
                    
                    record.setValue(titleTextField.text!, forKey: "title")
                    print(titleTextField.text!)
                    record.setValue(startPicker, forKey: "processSrart")
                    print(startPicker)
                    record.setValue(endPicker, forKey: "processEnd")
                    print(endPicker)
                    record.setValue(CardTextField.text, forKey: "processCard")
                    print(CardTextField.text)
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
            if startTextFiled.text != "" && EndTextField.text != "" && titleTextField.text != "" &&  CardTextField.text != "" {
                read()
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
                let viewContext = appDelegate.persistentContainer.viewContext
        
                let forProcess = NSEntityDescription.entity(forEntityName: "ForProcess", in: viewContext)
        
                let newProcess = NSManagedObject(entity: forProcess!, insertInto: viewContext)

                newProcess.setValue(titleTextField.text!, forKey: "title")
                newProcess.setValue(startPicker, forKey: "processSrart")
                newProcess.setValue(endPicker, forKey: "processEnd")
        
                newProcess.setValue(CardTextField.text, forKey: "processCard")

                newProcess.setValue(id + 1,forKey:"id")
                //タスクIDの指定
                print(tasksID)
                newProcess.setValue(tasksID, forKey: "forTaskID")
                do{
                    try viewContext.save()
                }catch {
                    print("接続失敗")
                }
            //アラート出す
            } else {
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
    //キーボード下げる処理
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
