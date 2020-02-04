//
//  AppDelegate.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/2.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import CoreData
import XMPPFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate, XMPPRosterDelegate {

    var window: UIWindow?
    var contactJid: XMPPJID?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let nvBarAppearance = UINavigationBar.appearance()
        nvBarAppearance.isTranslucent = false
        nvBarAppearance.barTintColor = UIColor(hex: 0x25b6ed)
        nvBarAppearance.tintColor = UIColor.white
        nvBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let manager = XmppManager.defaultManager
        manager.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        manager.xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "xmpp_based_qq")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - XMPPDelegate
    func xmppRoster(_ sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        var isExist = false
        let user = XmppUser.defaultUser
        for jid in user.addFridends {
            if presence.from().user == jid.user && presence.from().domain == jid.domain {
                isExist = true
            }
        }
        if !isExist {
            user.addFridends.append(presence.from())
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addNewContact"), object: nil)
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        let user = XmppUser.defaultUser
        if presence.type() == "available" && presence.from() != user.jid {
            for contact in user.contacts {
                if presence.from().user == contact.jid?.user {
                    if !contact.isOnline! {
                        contact.isOnline = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"contactIsAvailable"), object: contact)
                    }
                }
            }
        }
        if presence.type() == "unavailable" && presence.from() != user.jid {
            for contact in user.contacts {
                if presence.from().user == contact.jid?.user {
                    if contact.isOnline! {
                        contact.isOnline = false
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue:"contactIsAvailable"), object: contact)
                    }
                }
            }
        }
        if presence.type() == "unsubscribe" {
            XmppManager.defaultManager.xmppRoster?.removeUser(presence.from())
        }
    }

    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        let req = message.elements(forName: "request")
        if req.count != 0 {
            if req[0].xmlns() == "urn:xmpp:receipts" {
                let msg = XMPPMessage(type: message.attributeStringValue(forName: "type"), to: message.from(), elementID: message.attributeStringValue(forName: "id"), child: DDXMLElement(name: "received", xmlns: "urn:xmpp:receipts"))
                XmppManager.defaultManager.xmppStream?.send(msg)
            }
        } else {
            let received = message.elements(forName: "received")
            if received.count != 0
            {
                if received[0].xmlns() == "urn:xmpp:receipts" {
                  print("message send success!")
                }
            }
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        let presence = XMPPPresence(type: "available")
        XmppManager.defaultManager.xmppStream?.send(presence)
        XmppManager.defaultManager.xmppRoster?.fetch()
    }
    
}

