//
//  RegisterViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/17.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import XMPPFramework

class RegisterViewController: UIViewController, XMPPStreamDelegate {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPsd: UITextField!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.account.resignFirstResponder()
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
        self.confirmPsd.resignFirstResponder()
    }
    
    @IBAction func register(_ sender: UIButton) {
        let account = self.account.text
        let username = self.username.text
        let password = self.password.text
        let confirm = self.confirmPsd.text
        
        if account == nil || account == "" || username == nil || username == "" || password == nil || password == "" || confirm == nil || confirm == "" {
            self.showAlert(withMessage: "信息不完善，请补充")
        } else if password != confirm {
            self.showAlert(withMessage: "两次密码输入不一致")
        } else {
            XmppManager.defaultManager.registe(withUsername: account!, password: password!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        XmppUser.defaultUser.isLogin = false
        let manager = XmppManager.defaultManager
        manager.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        manager.xmppvCard?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(withMessage msg: String) {
        let alertController = UIAlertController(title: "错误提示", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - XMPPStreamDelegate
    func xmppStreamDidRegister(_ sender: XMPPStream!) {
        XmppManager.defaultManager.login(withUsername: self.account.text!, password: self.password.text!)
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        self.showAlert(withMessage: "注册失败！")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        let card = XMPPvCardTemp.v()
        card?.nickname = self.username.text
        XmppManager.defaultManager.xmppvCard?.updateMyvCardTemp(card)
        self.performSegue(withIdentifier: "pickPhoto", sender: self)
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
