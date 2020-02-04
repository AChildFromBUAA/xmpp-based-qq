//
//  ChatTableViewCell.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/18.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    var photo: UIImageView
    var bubble: UIImageView
    var contentLabel: UILabel
    let mainWidth = UIScreen.main.bounds.size.width
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        self.photo = UIImageView()
        self.photo.layer.cornerRadius = 20.0;
        self.photo.clipsToBounds = true;

        
        self.bubble = UIImageView()

        
        self.contentLabel = UILabel();
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = UIFont.systemFont(ofSize: 17.0)
        self.bubble.addSubview(self.contentLabel)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.bubble)
        self.contentView.addSubview(self.photo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.photo = UIImageView()
        self.photo.layer.cornerRadius = 20.0;
        self.photo.clipsToBounds = true;
        
        
        self.bubble = UIImageView()
        
        
        self.contentLabel = UILabel();
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = UIFont.systemFont(ofSize: 17.0)
        self.bubble.addSubview(self.contentLabel)

        super.init(coder: aDecoder)
        self.contentView.addSubview(self.bubble)
        self.contentView.addSubview(self.photo)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh(model:XmppChatModel) {
        let message: NSString = model.message! as NSString
        let size = CGSize(width: mainWidth/14*9, height: CGFloat.greatestFiniteMagnitude)
        let dic = Dictionary(dictionaryLiteral: (NSFontAttributeName, UIFont.systemFont(ofSize: 17)))
        let rect = message.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        
        var bubbleImage: UIImage
        var photoImage: UIImage
        
        if !model.isSend! {
            self.photo.frame = CGRect(x: 10, y: 20, width: 40, height: 40)
            self.bubble.frame = CGRect(x: 60, y: 10, width: rect.size.width+20, height: rect.size.height+20)
            bubbleImage = UIImage(named: "receiveImage")!
        } else {
            self.photo.frame = CGRect(x: mainWidth-50, y: 20, width: 40, height: 40)
            self.bubble.frame = CGRect(x: mainWidth-70-rect.size.width, y: 15, width: rect.size.width+20, height: rect.size.height+25)
            bubbleImage = UIImage(named: "sendImage")!
        }
        if (model.img != nil) {
            photoImage = model.img!
        } else {
            photoImage = UIImage(named: "defaultPhoto")!
        }
        bubbleImage = bubbleImage.stretchableImage(withLeftCapWidth: Int(bubbleImage.size.width/10*9.0), topCapHeight: Int(bubbleImage.size.height/10*9.0))
        self.bubble.image = bubbleImage
        self.photo.image = photoImage
        self.contentLabel.frame = CGRect(x: model.isSend! ? 5 : 13, y: 5, width: rect.size.width, height: rect.size.height)
        self.contentLabel.text = model.message
    }
    
}
