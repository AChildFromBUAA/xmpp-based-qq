//
//  XmppManger.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/16.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import Foundation
import XMPPFramework

enum connectType {
    case doNil, doLogin, doRegister
}

class XmppManager: NSObject, XMPPStreamDelegate {
    
    var xmppStream: XMPPStream?
    var xmppRoster: XMPPRoster?
    var xmppRosterStorage: XMPPRosterCoreDataStorage?
    
    var xmppvCard: XMPPvCardTempModule?
    var xmppvCardStorage: XMPPvCardCoreDataStorage?
    var xmppPhoto: XMPPvCardAvatarModule?
    
    var xmppMessageArchiving: XMPPMessageArchiving?
    var xmppMesaage: NSManagedObjectContext?
    
    var password: String?
    var registePsd: String?
    let domain = "10.137.222.108"
    let host = "10.137.222.108"
    var type:connectType = connectType.doNil
    
    class var defaultManager: XmppManager {
        struct Static {
            static let instance: XmppManager = XmppManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        self.xmppStream = XMPPStream()
        self.xmppStream?.hostName = host
        self.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        self.xmppRosterStorage = XMPPRosterCoreDataStorage.sharedInstance()
        self.xmppRoster = XMPPRoster(rosterStorage: self.xmppRosterStorage, dispatchQueue: DispatchQueue.global(qos: .default))
        self.xmppRoster?.activate(self.xmppStream)
        self.xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppRoster?.autoFetchRoster = false
        
        self.xmppvCardStorage = XMPPvCardCoreDataStorage.sharedInstance()
        self.xmppvCard = XMPPvCardTempModule(vCardStorage: self.xmppvCardStorage)
        self.xmppvCard?.activate(self.xmppStream)
        self.xmppvCard?.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppPhoto = XMPPvCardAvatarModule(vCardTempModule: self.xmppvCard)
        self.xmppPhoto?.activate(self.xmppStream)
        self.xmppPhoto?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        let messageArchivingStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        self.xmppMessageArchiving = XMPPMessageArchiving(messageArchivingStorage: messageArchivingStorage, dispatchQueue: DispatchQueue.main)
        self.xmppMessageArchiving?.activate(self.xmppStream)
        self.xmppMessageArchiving?.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppMesaage = messageArchivingStorage?.mainThreadManagedObjectContext
        
        self.xmppStream?.enableBackgroundingOnSocket = true
        
    }
    
    func login(withUsername username:String, password: String) {
        self.password = password
        self.type = connectType.doLogin
        self.connectToSerer(withName: username)
    }
    
    func registe(withUsername username: String, password: String) {
        self.registePsd = password
        self.type = connectType.doRegister
        self.connectToSerer(withName: username)
    }
    
    func connectToSerer(withName name:String) {
        if (self.xmppStream?.isConnected())! {
            self.xmppStream?.disconnect()
        }
        
        self.xmppStream?.myJID = XMPPJID(user: name, domain: self.domain, resource: "ios")
        do {
            try self.xmppStream?.connect(withTimeout: 30)
        } catch _ {
           print("cannot connect")
        }
    }
    
    func disconnect() {
        self.xmppStream?.disconnect()
    }
    
    // MARK:- xmppDelegate
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        switch self.type {
        case .doLogin:
            do {
                try  self.xmppStream?.authenticate(withPassword: self.password)
            } catch _ {
                print("authenticate error")
            }
        case .doRegister:
            do {
                try self.xmppStream?.register(withPassword: self.registePsd)
            } catch _ {
                print("register error")
            }
        default:
            break;
        }
    }
    
    
}
