//
//  AddNewViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/21.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import XMPPFramework


class AddNewViewController: UIViewController,XMPPRosterDelegate {

    @IBOutlet weak var account: UITextField!
    let user = XmppUser.defaultUser
    let manager = XmppManager.defaultManager
    
    @IBAction func add(_ sender: UIButton) {
        
        if let name = self.account.text {
             let jid = XMPPJID(user: name, domain: manager.domain, resource: "ios")
            for obj in user.addFridends {
                if obj.user == jid?.user {
                    tipWith("添加用户已经在你的请求列表中!")
                    return
                }
            }
            
            for obj in user.contacts {
                if obj.jid?.user == jid?.user{
                    tipWith("用户已经是你的好友!")
                    return
                }
            }
            
            if user.jid?.user == jid?.user {
                tipWith("不能添加自己为好友!")
                return
            }
            manager.xmppRoster?.subscribePresence(toUser: jid)
            tipWith("已发送!")
            self.account.text = ""
        }
        
    }
    
    func tipWith(_ msg: String!) {
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
