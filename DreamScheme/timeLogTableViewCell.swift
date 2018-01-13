//
//  timeLogTableViewCell.swift
//  DreamScheme
//
//  Created by 加藤　大起 on 2017/12/05.
//  Copyright © 2017年 Taiki Kato. All rights reserved.
//

import UIKit

class timeLogTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var startTimeLabel: UITextField!
    
    @IBOutlet weak var endTimeLabel: UITextField!
    
    @IBOutlet weak var idLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startTimeLabel.returnKeyType = UIReturnKeyType.done
        endTimeLabel.returnKeyType = UIReturnKeyType.done
        startTimeLabel.delegate = self
        endTimeLabel.delegate = self
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        startTimeLabel.resignFirstResponder()
        endTimeLabel.resignFirstResponder()
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
