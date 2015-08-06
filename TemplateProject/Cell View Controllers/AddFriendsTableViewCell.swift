//
//  AddFriendsTableViewCell.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

protocol AddFriendsTableViewCellDelegate: class {
    func cell(cell: AddFriendsTableViewCell, didSelectFriendUser user: PFUser)
    func cell(cell: AddFriendsTableViewCell, didSelectUnFriendUser user: PFUser)

}


class AddFriendsTableViewCell: UITableViewCell {
    
    //creates an instance of AddFriendsViewController
    weak var addFriendsViewController: AddFriendsViewController?
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    weak var delegate: AddFriendsTableViewCellDelegate?
    
    var user: PFUser? = nil {
        didSet {
            if let user = user {
                usernameLabel.text = (user.username)?.truncate(20, trailing: "...")
            }
        }
    }
    // 0 = yes/true, 1 = false, 2 = confirmed
    var canFollow: Int? = 0 {
        didSet {
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canFollow = canFollow {
                if canFollow == 1 {
                    
                    let image = UIImage(named: "Request")
                    addButton.setImage(image, forState: .Normal)
                }
                if canFollow == 0 {
                  
                    let image = UIImage(named: "Plus")
                    addButton.setImage(image, forState: .Normal)
                }
                if canFollow == 2 {
                   
                    let image = UIImage(named: "Checkmark")
                    addButton.setImage(image, forState: .Normal)
                }
                    
            }
        }
    }

    
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        if let canFollow = canFollow where canFollow == 0 {
            delegate?.cell(self, didSelectFriendUser: user!)
            self.canFollow = 1
           
        }
        else {
            var messageTitle = "Remove Friend?"
            var messageMessage = "You will no longer be able to start games with your friend or see their stats."
            if canFollow == 1 {
                messageTitle = "Delete Friend Request?"
                messageMessage = "Stop your request from being accepted by your Friend."
            }
            let alert = UIAlertController(title: messageTitle, message: messageMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let noAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            let yesAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.delegate?.cell(self, didSelectUnFriendUser: self.user!)
                self.canFollow = 0
                
            }
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            //uses an instance of AddFriendsViewController
            self.addFriendsViewController?.presentViewController(alert, animated: true) { () -> Void in }

           
        }
    }
}
