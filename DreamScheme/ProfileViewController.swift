//
//  ProfileViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

extension Array {
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        var indexArray:[Int] = []
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}

class ProfileViewController: UIViewController,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    //ピッカービュー
    private var myPickerView:UIPickerView!
    private let pickerViewHeight:CGFloat = 160
    
    //pickerViewの上にのせるtoolbar
    private var pickerToolbar:UIToolbar!
    private let toolbarHeight:CGFloat = 40.0
    
    @IBOutlet weak var profileSettings: UITableView!
    let Settings:[String] = ["言語設定","未達成のやるべきこと","総合タスク時間","将来の夢"]
    
    let language = ["日本語","English"]
    let unReachTask = "3個"
    let totalTime = "hogehoge"
    let dream = "hogehoge"
    
    var currentLang:String!

    
    var pickerIndexPath:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismiss(animated: true, completion: nil)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        profileTableView.layer.cornerRadius = 10.0;
        profileTableView.clipsToBounds = true
        // 6.指示を出しているのがViewControllerだと伝える設定
        //self : 自分自身(ViewControllerのこと)
        //データソース（表示するデータの設定を指示する人）
        myPickerView.dataSource = self
        //デリゲート（完治したイベントを委任する人、代理人（店長））
        myPickerView.delegate = self
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        self.view.addSubview(profileTableView)
        
        //配列でピッカービュー使う要素だけ初期値設定
        currentLang = language[0]
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame:CGRect(x:0,y:height,width:width,height:toolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.doneTapped))
        pickerToolbar.items = [flexible,doneBtn]
        self.view.addSubview(pickerToolbar)
        
        
    }
    func doneTapped(){
        UIView.animate(withDuration: 0.2){
            self.pickerToolbar.frame = CGRect(x:0,y:self.view.frame.height,
                                              width:self.view.frame.width,height:self.toolbarHeight)
            self.myPickerView.frame = CGRect(x:0,y:self.view.frame.height + self.toolbarHeight,
                                           width:self.view.frame.width,height:self.pickerViewHeight)
            self.profileTableView.contentOffset.y = 0
        }
        self.profileTableView.deselectRow(at: pickerIndexPath, animated: true)
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: pickerIndexPath) as! ProfileTableViewCell
        //        let cell = profileTableView.cellForRow(at:pickerIndexPath) as! ProfileTableViewCell
        cell.textLabel?.text = Settings[indexPath.row]
        switch(pickerIndexPath.row){
        case 0:
            cell.userInfoLabel.text = language[indexPath.row]
        case 1:
            cell.userInfoLabel.text = unReachTask
        case 2:
            cell.userInfoLabel.text = totalTime
        default:
            cell.userInfoLabel.text = dream
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ピッカービューとセルがかぶる時はスクロール
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: pickerIndexPath) as! ProfileTableViewCell
        let cellLimit:CGFloat = cell.frame.origin.y + cell.frame.height
        let pickerViewLimit:CGFloat = myPickerView.frame.height + toolbarHeight
        if(cellLimit >= pickerViewLimit){
            print("位置変えたい")
            UIView.animate(withDuration: 0.2) {
                tableView.contentOffset.y = cellLimit - pickerViewLimit
            }
        }
        switch(indexPath.row){
        case 0:
            let index = language.findIndex{$0 == cell.userInfoLabel.text}
            if(index.count != 0){
                    myPickerView.selectRow(index[0],inComponent:0,animated:true)
            }
            case 1:
                print("hoge")
            case 2:
                print("hoge")
            default:
                print("hoge")
                
        }
        pickerIndexPath = indexPath
        //ピッカービューをリロード
        myPickerView.reloadAllComponents()
        //ピッカービューを表示
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame = CGRect(x:0,y:self.view.frame.height - self.pickerViewHeight - self.toolbarHeight,width:self.view.frame.width,height:self.toolbarHeight)
            self.myPickerView.frame = CGRect(x:0,y:self.view.frame.height - self.pickerViewHeight,width:self.view.frame.width,height:self.pickerViewHeight)
        }
    }
        
    //3.ピッカービューの列数を決定する
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    //4.ピッカービューの行数を決定する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // ここでラベル上のテキストだけを返す
        
        switch (pickerIndexPath.row){
        case 0:
            return language.count
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    //ラベルをカスタマイズ
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        switch(pickerIndexPath.row){
        case 0:
            label.text = language[row]
        case 1:
            label.text = unReachTask
        case 2:
            label.text = totalTime
        default:
            label.text = dream
        }
        return label
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = profileTableView.cellForRow(at:pickerIndexPath) as! ProfileTableViewCell
        switch(pickerIndexPath.row){
        case 0:
            cell.userInfoLabel.text = language[row]
            currentLang = language[row]
        case 1:
            cell.userInfoLabel.text = unReachTask
        case 2:
            cell.userInfoLabel.text = totalTime
        default:
            cell.userInfoLabel.text = dream
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
