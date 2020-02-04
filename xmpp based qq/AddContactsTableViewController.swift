//
//  AddContactsTableViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/18.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit
import XMPPFramework

class AddContactsTableViewController: UITableViewController, AddReqTableViewCellDelegate, XMPPStreamDelegate,XMPPRosterDelegate {
    
    let user = XmppUser.defaultUser
    let manager = XmppManager.defaultManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        manager.xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        manager.xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(addNewContact), name: NSNotification.Name(rawValue: "addNewContact"), object: nil)
        
    }
    
    func addNewContact() {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (user.addFridends.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addReqTableViewCell", for: indexPath) as! AddReqTableViewCell

        // Configure the cell...
        
        cell.delegate = self
        let jid = user.addFridends[indexPath.row]
        cell.name.text = jid.user

        return cell
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

    // MARK: -AddReqTableViewDelegate
    func agree(with name: String) {
        
        let jid = XMPPJID(user: name, domain: manager.domain, resource: "ios")
        let roster = manager.xmppRoster
        roster?.acceptPresenceSubscriptionRequest(from: jid, andAddToRoster: true)
        for i in 0 ..< user.addFridends.count {
            if user.addFridends[i].user == name {
                user.addFridends.remove(at: i)
            }
        }
        
        let alertController = UIAlertController(title: "添加成功", message: "成功添加\(name)为好友", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    func disagree(with name: String) {
        let jid = XMPPJID(user: name, domain: manager.domain, resource: "ios")
        let roster = manager.xmppRoster
        roster?.rejectPresenceSubscriptionRequest(from: jid)
        manager.xmppRoster?.removeUser(jid)
        for i in 0 ..< user.addFridends.count {
            if user.addFridends[i].user == name {
                user.addFridends.remove(at: i)
            }
        }
        
        let alertController = UIAlertController(title: "拒绝成功", message: "拒绝了\(name)为好友", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()

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
