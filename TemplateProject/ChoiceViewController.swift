//
//  ChoiceViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 8/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

//protocol ChoiceViewControllerDelegate {
//    func passPhase(passedPhase: Int)
//}


class ChoiceViewController: UIViewController {
    
//    var delegate: ChoiceViewControllerDelegate?

    var game: PFObject?
    
    var chosenAnswer: String = ""
    
    var answerChoices: [String] = []
    
    var shuffledAnswerChoices: [String] = []
    
    var color : UIColor = UIColor.whiteColor()
    

    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    @IBOutlet weak var choice4: UIButton!
    
    override func viewDidLoad() {
        answerChoices = game!["answerChoices"] as! [String]
        shuffledAnswerChoices = shuffle(answerChoices)
        choice1.setTitle(shuffledAnswerChoices[0], forState: .Normal)
        //choice1.setAttributedTitle(NSMutableAttributedString(string: shuffledAnswerChoices[0]), forState: UIControlState.Normal)
        choice2.setTitle(shuffledAnswerChoices[1], forState: .Normal)
        choice3.setTitle(shuffledAnswerChoices[2], forState: .Normal)
        choice4.setTitle(shuffledAnswerChoices[3], forState: .Normal)
        
        let imageFile: PFFile = game!["picture"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            self.pictureView.image = UIImage(data: data!, scale: 1.0)
            
        }
    }
    @IBAction func pressed1(sender: AnyObject) {
        AnswerChosen(0)
    }
    
    @IBAction func pressed2(sender: AnyObject) {
        AnswerChosen(1)
    }
 
    @IBAction func pressed3(sender: AnyObject) {
        AnswerChosen(2)
    }
    
    @IBAction func pressed4(sender: AnyObject) {
        AnswerChosen(3)
        
    }
   
    func AnswerChosen(shuffledIndex: Int) {
        
        var index = 0
        let choices: [UIButton] = [choice1, choice2, choice3, choice4]
        for x in shuffledAnswerChoices {
            if x == answerChoices[0] {
                let image = UIImage(named: "AnswerBoxCorrect")
                choices[index].setBackgroundImage(image, forState: .Normal)
            }
            index = index + 1
            
        }
        
        chosenAnswer = shuffledAnswerChoices[shuffledIndex]
//        var labelText = ""
        var isCorrect = true
        var taggleImage = UIImage(named: "TaggleAngry")
        if answerChoices[0] == shuffledAnswerChoices[shuffledIndex] {
            color = UIColor(red: 34/255, green: 250/255, blue: 109/255, alpha: 1)
//            labelText = "Nice!"
            isCorrect = true
            taggleImage = UIImage(named: "TaggleHappy")
            
        }
        else {
            color = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
//            labelText = "Nope"
            isCorrect = false
        }
        if let wnd = self.view{
            
            var temporaryView = UIView(frame: wnd.bounds)
            
            temporaryView.backgroundColor = color
            temporaryView.alpha = 1
            
//            let label = UILabel(frame: wnd.bounds)
//            label.textAlignment = NSTextAlignment.Center
//            label.text = labelText
//            label.textColor = UIColor.whiteColor()
//            label.font = UIFont(name: "STHeitiSC-Medium", size: 50)
            
            let imageView = UIImageView(frame: wnd.bounds)
            imageView.image = taggleImage
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            temporaryView.addSubview(imageView)
            temporaryView.bringSubviewToFront(imageView)
          //  temporaryView.addSubview(label)
          //  temporaryView.bringSubviewToFront(label)
          //  label.center = temporaryView.center
            imageView.center = temporaryView.center
            
            wnd.addSubview(temporaryView)
            UIView.animateWithDuration(3.0, animations: {
                temporaryView.alpha = 0.0
                }, completion: {(finished:Bool) in
                    temporaryView.removeFromSuperview()
                    //dismiss here
            })
        }
        let query = PFQuery(className: "Game")
        query.whereKey("objectId", equalTo: self.game!.objectId! )
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let results = results as? [PFObject] ?? []
            let result = results[0]
            result.setObject(self.chosenAnswer, forKey: "pickedAnswer")
            result.setObject(isCorrect, forKey: "isCorrect")
            
         
            if isCorrect {
                let score = self.game!["score"] as! Int + 1
                result.setObject(score, forKey: "score")
            }

            result.saveInBackground()
        }
        

        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("dismiss"), userInfo: nil, repeats: false)
        
    }
    func dismiss() {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

    
}
