//
//  timeLogTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/12/05.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class timeLogTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
