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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(titleText: String) {
        
        userInfoLabel.text = titleText
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userInfoLabel = UILabel()
        userInfoLabel.frame = CGRect(x:self.frame.width / 2,y:0,width:self.frame.width / 2,height:self.frame.height)
        userInfoLabel.textAlignment = .center
        self.accessoryView = userInfoLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
