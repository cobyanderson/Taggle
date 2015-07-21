//
//  SettingsViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var viewUsername: UILabel!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let wholeUser  = PFUser.currentUser() {
            let nameUser = wholeUser.username
            self.viewUsername.text = nameUser
        }
        else {
            let viewUsername = "Nobody"
        }
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
