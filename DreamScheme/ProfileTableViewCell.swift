//
//  ProfileTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/21.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(titleText: String) {
        
        userInfoLabel.text = titleText
    }
}
