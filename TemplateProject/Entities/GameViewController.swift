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
    
    var opponent: PFUser?
    
    var choiceView: ChoiceViewController?
    
    @IBOutlet weak var taggleView: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var whoGuessed: UILabel!
    
    @IBOutlet weak var guessedAnswer: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        imagePicker.delegate = self
        if let game = game {
            if let firstPlayer = game["firstPlayer"] as? PFUser, secondPlayer = game["secondPlayer"] as? PFUser {
                if firstPlayer != PFUser.currentUser() {
                    opponentName = firstPlayer.username!
                    opponent = firstPlayer
                }
                else {
                    opponentName = secondPlayer.username!
                    opponent = secondPlayer
                }
                self.navigationItem.title = "Taggle with \(opponentName!)"
                
                if game["playNumber"] as! Int == 0 || PHASE == 2 {
                    self.comment.text = "Your Turn!"
                    self.whoGuessed.text = "Make \(self.opponentName!) guess:"
                    
                    let unshuffledAnswers: [String] = getRandomPromptList()
                    let answer = unshuffledAnswers.first
                    self.guessedAnswer.text = answer
                    self.guessedAnswer.textColor = UIColor.whiteColor()
                    let query = PFQuery(className: "Game")
                    query.whereKey("objectId", equalTo: self.game!.objectId! )
                    query.findObjectsInBackgroundWithBlock {
                        (results: [AnyObject]?, error: NSError?) -> Void in
                        let results = results as? [PFObject] ?? []
                        let result = results[0]
                        result.setObject(unshuffledAnswers, forKey: "answerChoices")
                        result.saveInBackground()
                    }
                }
                else {
                    if game["isCorrect"] != nil {
                    let isCorrect = game["isCorrect"] as! Bool
                        if isCorrect {
                            self.comment.text = "Nice Acting!"
                            self.guessedAnswer.textColor = UIColor(red: 34/255, green: 250/255, blue: 109/255, alpha: 1)
                        }
                        else {
                            self.comment.text = "More Emotion!"
                            self.guessedAnswer.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                    }
                    self.whoGuessed.text = "\(self.opponentName!) guessed:"
                    self.guessedAnswer.text = game["pickedAnswer"] as? String
                    }
                }
                
                
                }
            self.game = game
            
        }
    }
//    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
//        // get the controller that storyboard has instantiated and set it's delegate
//        choiceView = segue!.destinationViewController as? ChoiceViewController
//        choiceView!.delegate = self
//    }
    
//    func passPhase(passedPhase: Int) {
//        self.phase = passedPhase
//        println(self.phase)
    
    
    
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
    if game!["playNumber"] as! Int == 0 || PHASE == 2 {
        if game!["playNumber"] as! Int != 6 {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
            }
        else {
            self.game?.deleteInBackground()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    else {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("choiceViewController") as! ChoiceViewController
        
        viewController.game = self.game!
        presentViewController(viewController, animated: true, completion: nil)
        
        }
    }

        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.4)
            let imageFile = PFFile(data: imageData)
            imageFile.saveInBackground()
        
            let query = PFQuery(className: "Game")
            query.whereKey("objectId", equalTo: self.game!.objectId! )
            query.findObjectsInBackgroundWithBlock {
                (results: [AnyObject]?, error: NSError?) -> Void in
                let results = results as? [PFObject] ?? []
                let result = results[0]
                
                let newPlayNumber: Int = result["playNumber"] as! Int + 1

                
                result.setObject(self.opponent!, forKey: "whoseTurn")
                result.setObject(newPlayNumber, forKey: "playNumber")
                result.setObject(imageFile, forKey: "picture")
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                picker.view.addSubview(activityIndicator)
                activityIndicator.center = picker.view.center
                activityIndicator.startAnimating()
                result.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                })
                }
          
            
        }
        PHASE = 1
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
