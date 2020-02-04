//
//  ContactsTableViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/18.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import XMPPFramework

class ContactsTableViewController: UITableViewController, XMPPRosterDelegate, XMPPvCardTempModuleDelegate {
    
    var chatTo: XmppContactModel?
    let user = XmppUser.defaultUser
    let manager = XmppManager.defaultManager
    let addFriendsCellIdentifier = "addFriendsCell"
    let contactCellIdentifier = "contactCell"
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "确认退出", message: "确定要退出当前账号？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let doAction = UIAlertAction(title: "确认", style: .destructive) {
            (action) -> Void in
            self.user.contacts.removeAll()
            self.user.addFridends.removeAll()
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(doAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.hidesBackButton = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewContact), name: NSNotification.Name(rawValue:"addnewContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactIsAvailable), name: NSNotification.Name(rawValue: "contactIsAvailable"), object: nil)
        
    }
    
    func addNewContact() {
        let indexPath = IndexPath(row: 0, section: 0)
        let array = self.tableView.indexPathsForVisibleRows
        for obj in array! {
            if obj == indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func contactIsAvailable() {
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        manager.xmppRoster?.fetch()
        print("fetch")
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return self.user.contacts.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        
        if indexPath.section == 0 {
            let cell: AddFriendsCell = tableView.dequeueReusableCell(withIdentifier: addFriendsCellIdentifier, for: indexPath) as! AddFriendsCell
            if user.addFridends.count != 0 {
                let label = cell.newFriends
                label?.isHidden = false
                label?.layer.cornerRadius = 10
                label?.layer.masksToBounds = true
                label?.text = "\(String(describing: user.addFridends.count))"
            } else {
                cell.newFriends.isHidden = true
            }
            return cell
        } else {
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as! ContactTableViewCell
            let contact = user.contacts[indexPath.row]
            if contact.card?.photo == nil {
                cell.photoImage.image = UIImage(named: "defaultPhoto")
            } else {
                cell.photoImage.image = UIImage(data: (contact.card?.photo)!)
            }
            
            cell.username.text = contact.jid?.user
            if (contact.isOnline)! {
                cell.state.text = "在线"
                cell.stateImage.image = UIImage(named: "online")
            } else {
                cell.state.text = "离线"
                cell.stateImage.image = UIImage(named: "offline")
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "toAddContactsTableViewController", sender: self)
        } else {
            chatTo = user.contacts[indexPath.row]
            self.performSegue(withIdentifier: "toChatViewController", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5.0
        } else {
            return 20.0
        }
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

    // MARK: - XMPPRosterDelegate
    
    func xmppRosterDidEndPopulating(_ sender: XMPPRoster!) {
        self.tableView.reloadData()
    }
    
    
    func xmppRoster(_ sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        let sub = item.attribute(forName: "subscription")?.stringValue
        if sub == "both" || sub == "from" || sub == "to" {
            let jid =  XMPPJID(string: item.attribute(forName: "jid")?.stringValue)
            var isExist = false
            for contact in self.user.contacts {
                if contact.jid?.user == jid?.user {
                    isExist = true
                }
            }
            if !isExist {
                let card = manager.xmppvCard?.vCardTemp(for: jid, shouldFetch: true)
                manager.xmppvCard?.fetchvCardTemp(for: jid, ignoreStorage: true)
                let contact = XmppContactModel()
                contact.jid = jid
                contact.card = card
                contact.isOnline = false
                self.user.contacts.append(contact)
            }
        }
    }
    
    // MARK: -XMPPvCardTempModelDelegate
    
    func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule!, didReceivevCardTemp vCardTemp: XMPPvCardTemp!, for jid: XMPPJID!) {
        if jid.user == self.user.jid?.user {
            self.user.card = vCardTemp
        } else {
            for contact in self.user.contacts {
                if contact.jid == jid {
                    contact.card = vCardTemp
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "toChatViewController":
            let vc = segue.destination as! ChatViewController
            vc.chatTo = self.chatTo
            vc.navigationItem.title = self.chatTo?.card?.nickname
        default:
            break
        }
        
        
    }
    

}
