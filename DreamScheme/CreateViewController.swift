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
    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var createTextFiled: UITextField!
    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var weekCountTextField: UITextField!

    @IBOutlet weak var dayCountTextField: UITextField!
    
    @IBOutlet weak var noticeDayTextField: UITextField!
    
    @IBOutlet weak var noticeTimeTextField: UITextField!
    
    @IBOutlet weak var cardTextField: UITextField!
    
    @IBOutlet weak var forSwitch: UISwitch!
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
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
    
    var startPicker:Date = Date()

    var endPicker:Date = Date()
    
    var id = 0
    
    var passedTitle = -1
    let df = DateFormatter()
    var vi = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ja_JP");


        weekCountTextField.text = todoWeekArray[0]
        dayCountTextField.text = todoDayArray[0]
        noticeDayTextField.text = NDArray[0]
        noticeTimeTextField.text = NTArray[0]
        cardTextField.text = cardArray[0]
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
        
        newTask.setValue(weekCountTextField.text, forKey: "weekly")
        
        newTask.setValue(dayCountTextField.text, forKey: "purposeTime")
        
        newTask.setValue(Date(), forKey: "created_at")
        
        newTask.setValue(noticeDayTextField.text, forKey: "noticeWeek")
        
        newTask.setValue(noticeTimeTextField.text, forKey: "noticeDay")
        
        //イメージパスと時間に０
        
        
        do{
            try viewContext.save()
        }catch {
            print("接続失敗")
        }
        
    }
    
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {    //追記
            print("行けたお")
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.present(controller, animated: true, completion: nil)
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                
                let picker = UIImagePickerController()
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = false
                picker.delegate = self
                picker.videoQuality = UIImagePickerControllerQualityType.typeHigh
                
                self.present(picker, animated: true, completion: nil)
            }
            
            //UserDefaultから取り出す
            // ユーザーデフォルトを用意する
            let myDefault = UserDefaults.standard
            
            // データを取り出す
            let strURL = myDefault.string(forKey: "selectedPhotoURL")
            
      
            
        }

        
    }
    
    //カメラロールで写真を選んだ後
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        
        let strURL:String = assetURL.description
        
        print(strURL)
        
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを書き込んで
        myDefault.set(strURL, forKey: "selectedPhotoURL")
        
        // 即反映させる
        myDefault.synchronize()
        
        if strURL != nil{
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                self.taskImage.image = image
            }
            
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    //キーボードを出た時に下がる処理
    @IBAction func returnFinish(_ sender: UITextField) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
