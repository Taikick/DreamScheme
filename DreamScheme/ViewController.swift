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

    
    var hometitles:[String] = ["英語を勉強してナンパできるようになる"
        ,"PHPマスター"
        ,"swiftマスター"]
    var homeTime:[String] = [
    "2017.12.24-2018.12.24"
    ,"2017.12.24 - 2018.3.9"
    ,"2017"]
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hometitles.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        cell.tasksLabel.text = hometitles[indexPath.row]
        cell.dateLabel.text = homeTime[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

