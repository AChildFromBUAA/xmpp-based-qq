//
//  XmppUser.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/17.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import Foundation
import XMPPFramework

class XmppUser {
    var password: String?
    var jid: XMPPJID?
    var img: UIImage?
    var card: XMPPvCardTemp?
    var contacts = [XmppContactModel]()
    var addFridends = [XMPPJID]()
    
    var isLogin: Bool?
    
    class var defaultUser: XmppUser {
        struct Static {
            static let instance: XmppUser = XmppUser()
        }
        return Static.instance
    }
    
    func clear() {
        self.contacts = [XmppContactModel]()
        self.addFridends = [XMPPJID]()
    }

}
