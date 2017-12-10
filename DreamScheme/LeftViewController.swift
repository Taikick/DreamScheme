//
//  LeftViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/18.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FontAwesome_swift

class LeftViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet var userIcon:UIImageView!
    
    var moveList = ["ホーム","タスク状況","達成済タスク","時間分析"]
    
    var selectedPage = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIcon.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1), size: CGSize(width: 150.0, height: 130.0))

    }
    
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moveList.count
    }
    
    //セルに表示する文字列の決定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pagesCell = tableView.dequeueReusableCell(withIdentifier: "pagesCell", for:indexPath)
        pagesCell.textLabel?.textColor = UIColor.white
        pagesCell.textLabel?.text = moveList[indexPath.row]
        return pagesCell
    }
    
    //セルをタップしたら発動するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)が行目、\(moveList[indexPath.row])がタップされました")
        //セグウェを使って移動する時に値を渡す
        
        selectedPage = indexPath.row
        if selectedPage == 0 {
            changeViewController("Main")
        } else if selectedPage == 1 {
            changeViewController("Profile")
        
        } else if selectedPage == 2{
            changeViewController("Goal")
        } else {
            changeViewController("Analize")
        }
        
    }
    
    func changeViewController(_ code:String) {
        switch code {
        case "Main":
            let ProVCS = storyboard?.instantiateViewController(withIdentifier: "Main")
            
            let ProVC = UINavigationController(rootViewController: ProVCS!)
            self.slideMenuController()?.changeMainViewController(ProVC, close: true)
        
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
