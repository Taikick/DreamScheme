//
//  ProfileViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices



class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
    @IBOutlet weak var profileSettings: UITableView!
    
    let Settings:[String] = ["未達成のやるべきこと","総合タスク時間"]
    
    let unReachTask = "3個"
    let totalTime = "hogehoge"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImageView.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1), size: CGSize(width: 300.0, height: 300.0))
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NavigationBarに乗っている部品の色を変更します
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 225/255, green: 95/255, blue: 95/255, alpha: 1)
        //バーの左側にボタンを配置します(ライブラリ特有)
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
        self.navigationItem.title = "タスク状況"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    /// セルの個数指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.count
    }
    
    /// セルに値を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell

        cell.userLabel.text = Settings[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.userInfoLabel.text = unReachTask
        default:
            cell.userInfoLabel.text = totalTime
        }
        return cell
    }

}
