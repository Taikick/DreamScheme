//
//  SlideViewController.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/18.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideViewController: SlideMenuController {
   
        override func awakeFromNib() {
            let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main")
//            let aa = storyboard?.accessibilityNavigationStyle
//            let nextView = storyboard.instantiateViewController(withIdentifier: "mains")
//            let navi = UINavigationController(rootViewController: nextView)
            let leftVC = storyboard?.instantiateViewController(withIdentifier: "Left")
            
            //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
            let navigationController = UINavigationController(rootViewController: mainVC!)
            //ライブラリ特有のプロパティにセット
            mainViewController = navigationController
            leftViewController = leftVC
            super.awakeFromNib()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    }

//}

