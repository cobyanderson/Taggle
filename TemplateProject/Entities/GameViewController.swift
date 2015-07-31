//
//  GameViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit

class GameViewController: UIViewController {
    
    var game: PFObject?

    @IBAction func quitGame(sender: AnyObject) {
            let alert = UIAlertController(title: "Quit Game", message: "Do you really want to be a jerk?", preferredStyle: UIAlertControllerStyle.Alert)
            let noAction = UIAlertAction(title: "Yes I do, Quit.", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            let yesAction = UIAlertAction(title: "Nah, keep playing.", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            presentViewController(alert, animated: true) { () -> Void in }
            
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
