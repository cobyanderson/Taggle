//
//  GameViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var game: PFObject?
    var opponentName: String?
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var taggleView: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var whoGuessed: UILabel!
    
    @IBOutlet weak var guessedAnswer: UILabel!
    
    
    @IBAction func quitGame(sender: AnyObject) {
            let alert = UIAlertController(title: "Quit Game", message: "Do you really want to be a jerk?", preferredStyle: UIAlertControllerStyle.Alert)
            let yesAction = UIAlertAction(title: "Yes I do, Quit.", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.game?.deleteInBackground()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            let noAction = UIAlertAction(title: "Nah, keep playing.", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            presentViewController(alert, animated: true) { () -> Void in }
            
        
    }
    @IBAction func nextButtonPressed(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let pictureObject: PFObject = PFObject(className: "Game")
            pictureObject.setObject(false, forKey: "picture")
            pictureObject.saveInBackground()
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if let game = game {
            println(game)
            if let firstPlayer = game["firstPlayer"] as? PFUser, secondPlayer = game["secondPlayer"] as? PFUser {
                if firstPlayer != PFUser.currentUser() {
                    opponentName = firstPlayer.username!
                }
                else {
                    opponentName = secondPlayer.username!
                }
                self.navigationItem.title = "Taggle with \(opponentName!)"
            }
        
        }
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
