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
    
    var phase: Int = 0

    
    @IBOutlet weak var taggleView: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var whoGuessed: UILabel!
    
    @IBOutlet weak var guessedAnswer: UILabel!
    
    override func viewDidLoad() {
        
        self.navigationItem.hidesBackButton =  true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if let game = game {
            
            phase = game["phaseNumber"] as! Int
            
            if let firstPlayer = game["firstPlayer"] as? PFUser, secondPlayer = game["secondPlayer"] as? PFUser {
                let playNumber = game["playNumber"] as! Int
                if firstPlayer != PFUser.currentUser() {
                    opponentName = firstPlayer.username!
                    opponent = firstPlayer
                }
                else {
                    opponentName = secondPlayer.username!
                    opponent = secondPlayer
                }
                self.navigationItem.title = "Round \(playNumber + 1) / 6"
                
                if game["phaseNumber"] as! Int > 11 {
                    
                    
                    self.navigationItem.title = "End"
                    
                    if (game["score"] as! Int) == 6 {
                        self.taggleView.image = UIImage(named: "TaggleHappy")
                        self.comment.text = "Perfect Game!"
                        self.guessedAnswer.textColor = UIColor(red: 34/255, green: 255/255, blue: 115/255, alpha: 1)
                    }
                    else if (game["score"] as! Int) > 3 {
                        self.taggleView.image = UIImage(named: "TaggleSurprised")
                        self.comment.text = "Pretty Good"
                        self.guessedAnswer.textColor = UIColor(red: 232/255, green: 219/255, blue: 77/255, alpha: 1)
                    }
                        
                    else if (game["score"] as! Int) > 1  {
                        self.taggleView.image = UIImage(named: "TaggleSad")
                        self.comment.text = "Meh, Not Really"
                        self.guessedAnswer.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                        //                        self.guessedAnswer.textColor = UIColor(red: 38/255, green: 173/255, blue: 197/255, alpha: 1)
                    }
                        
                    else {
                        self.taggleView.image = UIImage(named: "TaggleAngry")
                        self.comment.text = "Try Harder!"
                        self.guessedAnswer.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                    }
                    
                    let gotScore = game["score"] as! Int
                    
                    var calculatedScore = Float(Float(gotScore) / (game["playNumber"] as! Float)) * 100.0
                    if calculatedScore > 100 {
                        calculatedScore = 100
                    }
                    let stringScore = String(format: "%0.0f", calculatedScore)
                    
                    self.whoGuessed.text = "You and \(opponentName!) scored:"
                    self.guessedAnswer.text = "\(stringScore)%"
                    
                }
                    
                else if ((phase % 2) == 0) {
                    
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
                            self.guessedAnswer.textColor = UIColor(red: 34/255, green: 254/255, blue: 115/255, alpha: 1)
                        }
                        else {
                            self.comment.text = "More Emotion!"
                            taggleImage = UIImage(named: "TaggleSad")!
                            self.guessedAnswer.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                        }
                        self.taggleView.image = taggleImage
                        self.whoGuessed.text = "\(self.opponentName!) guessed:"
                        
                        let guessedAnswers = game["pickedAnswers"] as? [String]
                        
                        
                        self.guessedAnswer.text = guessedAnswers![(self.game!["playNumber"] as! Int) - 1]
                        
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
        
        println(game!["phaseNumber"] as! Int)
        
        if (game!["phaseNumber"] as! Int) == 12 {
           
            game!.setObject(13, forKey: "phaseNumber")
            game!.setObject(self.opponent!, forKey: "whoseTurn")
            game!.saveInBackgroundWithBlock({ (Bool, NSError) -> Void in
            })
            let endingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("endViewController") as! EndViewController
            endingViewController.game = self.game!
            presentViewController(endingViewController, animated: true, completion: { () -> Void in
            })
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
            
        else if (game!["phaseNumber"] as! Int) == 13 {
            let endingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("endViewController") as! EndViewController
            endingViewController.game = self.game!
            presentViewController(endingViewController, animated: true, completion: { () -> Void in
            })
            
            game!.deleteInBackgroundWithBlock({ (Bool, NSError) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }
            
        else if ((phase % 2) == 0) {
            
            imagePicker.delegate = self
            imagePicker.navigationController?.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //    imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            
            presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        else {
            
            let newPhaseNumber: Int = game!["phaseNumber"] as! Int + 1
            game?.setObject(newPhaseNumber, forKey: "phaseNumber")
            
            let newPlayNumber: Int = game!["playNumber"] as! Int + 1
            game!.setObject(newPlayNumber, forKey: "playNumber")
            
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("choiceViewController") as! ChoiceViewController
            viewController.game = self.game!
            viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            game!.saveInBackgroundWithBlock({ (Bool, NSError) -> Void in
                self.viewDidLoad()
                self.presentViewController(viewController, animated: true, completion: nil)
                if newPhaseNumber == 12 {
                    self.navigationController?.popToRootViewControllerAnimated(false)
                }
            })
            

            
            
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
            let imageFile = PFFile(data: imageData)
            imageFile.saveInBackground()
            //
            //            let query = PFQuery(className: "Game")
            //            query.whereKey("objectId", equalTo: self.game!.objectId! )
            //            query.findObjectsInBackgroundWithBlock {
            //                (results: [AnyObject]?, error: NSError?) -> Void in
            //                let results = results as? [PFObject] ?? []
            //                let result = results[0]
            
            
            
            var imageKey = ""
            switch ((game!["playNumber"] as! Int) + 1) {
                
            case 1:
                imageKey = "picture1"
            case 2:
                imageKey = "picture2"
            case 3:
                imageKey = "picture3"
            case 4:
                imageKey = "picture4"
            case 5:
                imageKey = "picture5"
            case 6:
                imageKey = "picture6"
            default:
                imageKey = "picture"
            }
            
            let newPhaseNumber: Int = game!["phaseNumber"] as! Int + 1
            game?.setObject(newPhaseNumber, forKey: "phaseNumber")
            
            game!.setObject(self.opponent!, forKey: "whoseTurn")
            
            game!.setObject(imageFile, forKey: imageKey)
            
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            picker.view.addSubview(activityIndicator)
            activityIndicator.center = picker.view.center
            activityIndicator.startAnimating()
            game!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                
                // Create our Installation query
                if let pushQuery = PFInstallation.query() {
                    pushQuery.whereKey("user", equalTo: self.opponent!)
                    
                    var pushMessage = "Your Turn! \(PFUser.currentUser()!.username!) sent you a new face!"
                    if (self.game!["playNumber"] as! Int) < 1 {
                        pushMessage = " \(PFUser.currentUser()!.username!) wants to start a game with you!"
                    }
                    
                    let data = [
                        "badge" : "Increment"
                    ]
                    
                    let push = PFPush()
                    push.setQuery(pushQuery) // Set our Installation query
                    push.setData(data)
                    push.setMessage(pushMessage)
                    push.sendPushInBackground()
                }
                
            })
            //                }
            
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
