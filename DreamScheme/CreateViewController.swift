//
//  CreateViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/19.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    
    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var createTextFiled: UITextField!
    var passedTitle = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //繰り返し処理を行うスイッチ
    @IBAction func tapForSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("繰り返しスイッチオン")
        }else{
            print("繰り返しスイッチオフ")
        }
    }
    
    //通知用のスイッチ
    @IBAction func AlertSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("通知スイッチオン")
        }else{
            print("通知スイッチオフ")
        }
        
    }
    
    @IBAction func taskAddButton(_ sender: UIButton) {
        print("追加ボタンが押されました")
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
