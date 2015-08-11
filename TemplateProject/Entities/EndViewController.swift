//
//  EndViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 8/10/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import UIKit
import AssetsLibrary

class EndViewController: UIViewController {
    
    var game: PFObject?
    var imageKey = "picture1"
    @IBAction func pressedDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    @IBOutlet weak var picture: UIImageView!
//    @IBOutlet weak var choice1: UIButton!
//    @IBOutlet weak var choice2: UIButton!
//    @IBOutlet weak var choice3: UIButton!
//    @IBOutlet weak var choice4: UIButton!
//    @IBOutlet weak var choice5: UIButton!
//    @IBOutlet weak var choice6: UIButton!
    
    @IBAction func saveImage(sender: AnyObject) {
        if let wnd = self.view{
            
            var temporaryView = UIView(frame: wnd.bounds)
            
            temporaryView.backgroundColor = UIColor.whiteColor()
            temporaryView.alpha = 1
            
            let label = UILabel(frame: wnd.bounds)
            label.textAlignment = NSTextAlignment.Center
            label.text = "Saved"
            label.textColor = UIColor.blackColor()
            label.font = UIFont(name: "STHeitiSC-Medium", size: 50)
    
            temporaryView.addSubview(label)
            temporaryView.bringSubviewToFront(label)
            label.center = temporaryView.center
            
            wnd.addSubview(temporaryView)
            UIView.animateWithDuration(1.0, animations: {
                temporaryView.alpha = 0.0
                }, completion: {(finished:Bool) in
                    temporaryView.removeFromSuperview()
                    //dismiss here
            })
        }
        
        
    }
    
    @IBAction func pressed1(sender: AnyObject) {
        imageKey = "picture1"
        viewDidLoad()
    }
    @IBAction func pressed2(sender: AnyObject) {
        imageKey = "picture2"
        viewDidLoad()
    }
    @IBAction func pressed3(sender: AnyObject) {
        imageKey = "picture3"
        viewDidLoad()
    }
    @IBAction func pressed4(sender: AnyObject) {
        imageKey = "picture4"
        viewDidLoad()
    }
    @IBAction func pressed5(sender: AnyObject) {
        imageKey = "picture5"
        viewDidLoad()
    }
    @IBAction func pressed6(sender: AnyObject) {
        imageKey = "picture6"
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        let playerAnswers = game!["pickedAnswers"] as! [String]
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.picture.addSubview(activityIndicator)
        activityIndicator.center = self.picture.center
   
        let imageFile: PFFile = game![imageKey] as! PFFile
        imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
            self.picture.image = UIImage(data: data!, scale: 1.0)
            activityIndicator.stopAnimating()
            }, progressBlock: { (Int32) -> Void in
                activityIndicator.startAnimating()
        })
        
        
//        choice1.setTitle(playerAnswers[0], forState: .Normal)
//        choice2.setTitle(playerAnswers[1], forState: .Normal)
//        choice3.setTitle(playerAnswers[2], forState: .Normal)
//        choice4.setTitle(playerAnswers[3], forState: .Normal)
//        choice5.setTitle(playerAnswers[4], forState: .Normal)
//        choice6.setTitle(playerAnswers[5], forState: .Normal)
        
    
    }
}