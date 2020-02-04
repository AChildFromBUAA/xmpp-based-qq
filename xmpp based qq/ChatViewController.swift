//
//  ChatViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/21.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import CoreData
import XMPPFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, XMPPStreamDelegate {

    var chatTo: XmppContactModel?
    var chatData: [XMPPMessageArchiving_Message_CoreDataObject]?
    let manager = XmppManager.defaultManager
    let user = XmppUser.defaultUser
    let chatTableViewCellIdentifier = "chatTableViewCell"
    let mainWidth = UIScreen.main.bounds.size.width

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let message = XMPPMessage(type: "chat", to: self.chatTo?.jid)
        message?.addBody(self.textView.text)
        let receipt = XMLElement(name: "request", xmlns: "urn:xmpp:receipts")
        message?.addChild(receipt!)
        manager.xmppStream?.send(message)
        self.textView.text = ""
        self.sendButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.manager.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textView.delegate = self
        self.reloadMessage()

    }
    
    func reloadMessage() {
        let context = manager.xmppMesaage
        let fetchReq = NSFetchRequest<XMPPMessageArchiving_Message_CoreDataObject>()
        let entity = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: context!)
        fetchReq.entity = entity
        let managerBare: String = (self.manager.xmppStream?.myJID.bare())!
        let chatToBare: String = (self.chatTo?.jid?.bare())!
        let predicate = NSPredicate(format: "streamBareJidStr == %@ AND bareJidStr == %@", managerBare, chatToBare)
        fetchReq.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchReq.sortDescriptors?.append(sortDescriptor)
        let fetchedObjects = try! context?.fetch(fetchReq)
        self.chatData?.removeAll()
        self.chatData = fetchedObjects
        
        self.tableView.reloadData()
        print("reload")
        if self.chatData?.count != 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: (self.chatData?.count)!-1), at: .middle, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.chatData?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellIdentifier, for: indexPath) as! ChatTableViewCell
        
        let msg = self.chatData?[indexPath.section]
        let model = XmppChatModel()
        if (msg?.isOutgoing)! {
            model.img = user.img
        } else {
            if ((chatTo?.card?.photo) != nil) {
                model.img = UIImage(data: (chatTo?.card?.photo)!)
            }
        }
        model.isSend = msg?.isOutgoing
        model.message = msg?.body
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        model.time = formatter.string(from: (msg?.timestamp)!)
        model.msg = msg
        cell.refresh(model: model)
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = self.chatData?[indexPath.section]
        let size = CGSize(width: mainWidth/14*9, height: CGFloat.greatestFiniteMagnitude)
        let dic = Dictionary(dictionaryLiteral: (NSFontAttributeName, UIFont.systemFont(ofSize: 17)))
        let body = msg?.body
        let rect = body?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        let height = rect?.height
        return height!+40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: 25))
        let label = UILabel(frame:CGRect(x:0, y:19, width:mainWidth, height:15))
        label.textAlignment = .center;
        label.font = UIFont.systemFont(ofSize: 15)
        let message = self.chatData?[section];
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: (message?.timestamp)!)
        label.text = date
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - XMPPStreamDelegate
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        self.reloadMessage()
        self.tableView.reloadData()
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
        self.reloadMessage()
    }
    
    // MARK: - textViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count != 0 || textView.text != ""  {
            self.sendButton.isUserInteractionEnabled  =  true
        } else {
            self.sendButton.isUserInteractionEnabled  = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.reloadInputViews()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
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
