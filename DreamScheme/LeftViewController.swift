//
//  LeftViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/18.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LeftViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var moveList = ["プロフィール","達成済タスク","時間分析"]
    
    var selectedPage = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(red: 129/255, green: 212/255, blue: 78/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor.white
        
        
    }
    
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moveList.count
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pagesCell = tableView.dequeueReusableCell(withIdentifier: "pagesCell", for:indexPath)
        pagesCell.textLabel?.textColor = UIColor.blue
        pagesCell.textLabel?.text = moveList[indexPath.row]
        return pagesCell
    }
    
    //セルをタップしたら発動するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目、\(moveList[indexPath.row])がタップされました")
        //セグウェを使って移動する時に値を渡す
        
        selectedPage = indexPath.row
        
        if selectedPage == 0 {
            changeViewController("Profile")
        
        } else if selectedPage == 1{
            changeViewController("Goal")
        } else {
            changeViewController("Analize")
        }
        
    }
    
    func changeViewController(_ code:String) {
        switch code {
        case "Profile":
            let ProVCS = storyboard?.instantiateViewController(withIdentifier: "Profile")
            
            let ProVC = UINavigationController(rootViewController: ProVCS!)
            self.slideMenuController()?.changeMainViewController(ProVC, close: true)
            
        case "Goal":
            print("Goal")
            let ProVCS = storyboard?.instantiateViewController(withIdentifier: "Goal")
            
            let ProVC = UINavigationController(rootViewController: ProVCS!)
            self.slideMenuController()?.changeMainViewController(ProVC, close: true)

        case "Analize":
            print("Analize")
            let ProVCS = storyboard?.instantiateViewController(withIdentifier: "Analize")
            
            let ProVC = UINavigationController(rootViewController: ProVCS!)
            self.slideMenuController()?.changeMainViewController(ProVC, close: true)

        default:
            print("aaa")
        }
    }
    
    //セグエを使って画面遷移している時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
