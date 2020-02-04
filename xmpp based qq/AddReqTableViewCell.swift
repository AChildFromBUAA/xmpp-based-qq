//
//  AddReqTableViewCell.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/21.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

protocol AddReqTableViewCellDelegate {
    func agree(with name: String)
    func disagree(with name: String)
}


class AddReqTableViewCell: UITableViewCell {
    
    var delegate: AddReqTableViewCellDelegate?
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBAction func agree(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.agree(with: self.name.text!)
        }
    }

    @IBAction func disagree(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.disagree(with: self.name.text!)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
