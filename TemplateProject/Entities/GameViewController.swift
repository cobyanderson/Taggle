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
    
    let imagePicker = myPickerClass()
    
    var opponent: PFUser?
    
    var choiceView: ChoiceViewController?
    
    var phase: Int = 1
    
    @IBOutlet weak var taggleView: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var whoGuessed: UILabel!
    
    @IBOutlet weak var guessedAnswer: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton =  true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
                self.navigationItem.title = "\(opponentName!)"
                
                if game["playNumber"] as! Int == 0 || phase == 2 {
                    
                    self.taggleView.image = UIImage(named: "TaggleSurprised")
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
                    var taggleImage: UIImage
                    if game["isCorrect"] != nil {
     
                    let isCorrect = game["isCorrect"] as! Bool
                        if isCorrect {
                            self.comment.text = "Nice Acting!"
                            taggleImage = UIImage(named: "TaggleHappy")!
                            self.guessedAnswer.textColor = UIColor(red: 34/255, green: 250/255, blue: 109/255, alpha: 1)
                        }
                        else {
                            self.comment.text = "More Emotion!"
                            taggleImage = UIImage(named: "TaggleSad")!
                            self.guessedAnswer.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                    }
                    self.taggleView.image = taggleImage
                    self.whoGuessed.text = "\(self.opponentName!) guessed:"
                    self.guessedAnswer.text = game["pickedAnswer"] as? String
                        
                        let scoreQueryUser = PFUser.query()!.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
                        scoreQueryUser.findObjectsInBackgroundWithBlock {
                            ( results: [AnyObject]?, error: NSError?) -> Void in
                            let results = results as? [PFUser] ?? []
                            let result = results[0]
                            
                            var totalFacesMade: Int
                            if result["totalFacesMade"] != nil {
                                totalFacesMade = result["totalFacesMade"] as! Int
                            }
                            else { totalFacesMade = 0
                            }
                            totalFacesMade = totalFacesMade + 1
                            println(totalFacesMade)
                            result.setObject(totalFacesMade, forKey: "totalFacesMade")
                            
                            var successfullyActed: Int
                            if result["successfullyActed"] != nil {
                                successfullyActed = result["successfullyActed"] as! Int
                            }
                            else { successfullyActed = 0
                            }
                            if isCorrect {
                                successfullyActed = successfullyActed + 1
                            }
                            
                            result.setObject(successfullyActed, forKey: "successfullyActed")
                            println(successfullyActed)
                            result.saveInBackground()
                        }
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
    if game!["playNumber"] as! Int == 0 || phase == 2 {
        
        // -1 ensures the game will never end... to be changed later
        if game!["playNumber"] as! Int != -1 {
            imagePicker.delegate = self
            imagePicker.navigationController?.delegate = self
//            imagePicker.navigationItem.rightBarButtonItem = nil
//            imagePicker.navigationItem.hidesBackButton = true
//            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
          
            presentViewController(imagePicker, animated: true, completion: nil)
            }
        else {
            self.game?.deleteInBackground()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    else {
        phase = 2
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("choiceViewController") as! ChoiceViewController
        viewController.game = self.game!
        presentViewController(viewController, animated: true, completion: nil)
        
        }
    }

        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        phase = 1
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
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
