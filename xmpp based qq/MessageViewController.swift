//
//  MessageViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/12.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    
    @IBAction func showSlideView(_ sender: UISwipeGestureRecognizer) {
        let sliderVC: UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "SliderViewController")
        self.present(sliderVC, animated: false, completion: nil)
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
