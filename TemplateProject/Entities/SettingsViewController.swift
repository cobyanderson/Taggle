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
    
    @IBOutlet weak var SuccessfullyActed: UILabel!
    
    @IBOutlet weak var TotalFacesMade: UILabel!
    
    @IBOutlet weak var CorrectlyGuessed: UILabel!
    
     @IBOutlet var viewUsername: UILabel!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (NSError) -> Void in
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.presentLogInView()
        }
    }
   
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func makePrompts(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://docs.google.com/forms/d/1q4b5pMdp2Rh4_s-gOTyXBgHiGoGjJ42NeVLSgpcqA80/viewform?usp=send_form")!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wholeUser: PFUser?
        
        let userQuery = PFUser.query()!.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
//        userQuery.includeKey("totalFacesMade")
//        userQuery.includeKey("correctlyGuessed")
//        userQuery.includeKey("successfullyActed")
        userQuery.findObjectsInBackgroundWithBlock {
            ( results: [AnyObject]?, error: NSError?) -> Void in
            let results = results as? [PFUser] ?? []
            
            let wholeUser = results[0]
            
            let nameUser = wholeUser.username
            let playerName = nameUser!.truncate(20, trailing: "...")
            self.viewUsername.text = playerName
          
            
            
            
            
            if let score = wholeUser["totalFacesMade"] as? Int {
            
            self.TotalFacesMade.text = String(score)
            
            //calculates and sets score for Successfully Acted
            let SAgotScore = wholeUser["successfullyActed"] as? Int ?? 0
            let SAcalculatedScore = Float(Float(SAgotScore) / (wholeUser["totalFacesMade"] as! Float)) * 100.0
            let SAstringScore = String(format: "%0.0f", SAcalculatedScore)
            
            self.SuccessfullyActed.text = "\(SAstringScore)%"
            if SAcalculatedScore > 50 {
                self.SuccessfullyActed.textColor = UIColor(red: 34/255, green: 254/255, blue: 155/255, alpha: 1)
            }
            else {
                self.SuccessfullyActed.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
            }
            
            
            
            //calculates and sets score for Correctly Guessed
            let CGgotScore = wholeUser["correctlyGuessed"] as? Int ?? 0
            let CGcalculatedScore = Float(Float(CGgotScore) / (wholeUser["totalFacesMade"] as! Float)) * 100.0
            let CGstringScore = String(format: "%0.0f", CGcalculatedScore)
            
            self.CorrectlyGuessed.text = "\(CGstringScore)%"
            
            if CGcalculatedScore > 50 {
                self.CorrectlyGuessed.textColor = UIColor(red: 34/255, green: 254/255, blue: 115/255, alpha: 1)
            }
            else {
                self.CorrectlyGuessed.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                }
            }
        
        else {
            let viewUsername = "Nobody"
        }
                // Do any additional setup after loading the view.
    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
}

