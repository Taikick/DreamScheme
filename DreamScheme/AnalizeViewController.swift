//
//  AnalizeViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class AnalizeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var userTasks:[String] = ["英語でナンパ","プログラミング"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTasks.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasksCell = tableView.dequeueReusableCell(withIdentifier: "AnalizeCell") as! AnalizeTableViewCell
        tasksCell.AnaizeListLabel.text = userTasks[indexPath.row]
        
        return tasksCell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
