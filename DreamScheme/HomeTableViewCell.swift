//
//  HomeTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/16.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeBarCharts: UIView!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
