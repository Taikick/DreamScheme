//
//  ProcessTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/11/21.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class ProcessTableViewCell: UITableViewCell {

    @IBOutlet weak var ProLabel: UILabel!
    @IBOutlet weak var ProTimeLabel: UILabel!
    
    @IBOutlet weak var ProIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
