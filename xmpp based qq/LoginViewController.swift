//
//  ViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/2.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import XMPPFramework

class LoginViewController: UIViewController, UITextFieldDelegate, XMPPStreamDelegate {
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.userIDTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let manager = XmppManager.defaultManager
        manager.login(withUsername: self.userIDTextField.text!, password: self.passwordTextField.text!)
        
        userIDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        XmppUser.defaultUser.isLogin = true
        let manager = XmppManager.defaultManager
        manager.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - XMPPStreamDelegate
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        let user = XmppUser.defaultUser
        if user.isLogin! {
            let manager = XmppManager.defaultManager
            let presence = XMPPPresence(type: "available")
            manager.xmppStream?.send(presence)
            manager.xmppRoster?.fetch()
            user.jid = manager.xmppStream?.myJID
            user.password = self.passwordTextField.text
            self.performSegue(withIdentifier: "toContact", sender: nil)
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
         let alertController = UIAlertController(title: "ERROR", message: "Please check your net state!", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? ContactsTableViewController {
            let manager = XmppManager.defaultManager
            manager.xmppRoster?.addDelegate(des, delegateQueue: DispatchQueue.main)
            manager.xmppPhoto?.addDelegate(des, delegateQueue: DispatchQueue.main)
            manager.xmppvCard?.addDelegate(des, delegateQueue: DispatchQueue.main)
        }
    }
    
}

