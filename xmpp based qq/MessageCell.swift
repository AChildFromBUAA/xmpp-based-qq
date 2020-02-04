//
//  MessageCell.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/15.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
