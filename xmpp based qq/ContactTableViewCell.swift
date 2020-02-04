//
//  ContactTableViewCell.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/18.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var state: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
