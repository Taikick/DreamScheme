//
//  ProfileViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import CoreData


class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profileSettings: UITableView!
    let Settings:[String] = ["未達成のやるべきこと","総合タスク時間"]
    
    let unReachTask = "3個"
    let totalTime = "hogehoge"
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonWithImage(UIImage.fontAwesomeIcon(name: .user, textColor: .blue, size: CGSize(width: 40.0, height: 40.0)))
    }
    /// セルの個数指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.count
    }
    
    /// セルに値を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell

        cell.textLabel?.text = Settings[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.userInfoLabel.text = unReachTask
        default:
            cell.userInfoLabel.text = totalTime
        }
        return cell
    }
    

    
    


}
