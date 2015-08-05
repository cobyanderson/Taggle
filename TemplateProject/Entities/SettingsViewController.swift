//
//  SettingsViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit
import ParseUI
import FBSDKCoreKit

class SettingsViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (NSError) -> Void in
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.presentLogInView()
        }
    }
    @IBOutlet var viewUsername: UILabel!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let wholeUser  = PFUser.currentUser() {
            let nameUser = wholeUser.username
            let playerName = nameUser!.truncate(20, trailing: "...")
            self.viewUsername.text = playerName
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
}

