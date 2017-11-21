//
//  DTitleTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/21.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit
import Charts

class DTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var DTitleLabel: UILabel!
    @IBOutlet weak var DTitleDate: UILabel!
    @IBOutlet weak var DTitleChart: BarChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
