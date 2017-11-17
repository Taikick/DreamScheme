//
//  ViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/15.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts
import FontAwesome_swift
import REFrostedViewController

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var myButton: UIButton!
    
    var hometitles:[String] = ["英語を勉強してナンパできるようになる"
        ,"PHPマスター"
        ,"swiftマスター"
    ]
    
    var homeTime:[String] = [
        "2017.12.24-2018.12.24"
        ,"2017.12.24 - 2018.3.9"
        ,"2017"
    ]
    //チャートのデータ
    var homeChartData = ["hogehoge"
        ,"fugafuga"
        ,"mogemoge"
    ]
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var myBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fontawesomeをボタンに使う
        myButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        myButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        myButton.setTitleColor(UIColor.blue, for: .normal)
        myButton.backgroundColor = UIColor.white
        //バーボタンの文字列決定
        myBarButton.title = "タスク開始"
        

    }

    
    //ぼたんが押された時の処理
    @IBAction func tapButton(_ sender: UIButton) {
        hometitles.append("hoge")
        homeTime.append("hoge")
        print(hometitles)
        
        homeTableView.reloadData()
    }
    
    
    
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hometitles.count;
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.tasksLabel.text = hometitles[indexPath.row]
        cell.dateLabel.text = homeTime[indexPath.row]
        return cell
    }
    
    //セルが押された時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目")
        //セグウェを使って移動する時に値を渡す
//        selectedIndex = indexPath.row
        //選択された行番号をほぞん
        
        //セグエに名前を指定して画面遷移処理を発動
//        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    
    //セグエを使って画面遷移している時発動
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンス(オブジェクト)を取得
        //as!DetailViewControllerがダウンキャスト変換している箇所
        let dvc: DetailViewController =
            segue.destination
                as!DetailViewController
        
        //次の画面のプロパティ（メンバ変数）passedIndexに選択された行番号を渡す
        dvc.passedIndex = selectedIndex
        
    }*/

    //ストップウォッチボタンが押された時の処理
    @IBAction func tapWatch(_ sender: Any) {
        if myBarButton.title == "タスク開始" {
            
           myBarButton.title = "タスク終了"
            
        } else {
            
           myBarButton.title = "タスク開始"
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
