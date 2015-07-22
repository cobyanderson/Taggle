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

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    weak var delegate: AddFriendsTableViewCellDelegate?
    
    func checkmarkButton() {
        let image = UIImage(named: "facetag_checkmark")
       // addButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        addButton.setImage(image, forState: .Normal)
    }
    
    var user: PFUser? = nil {
        didSet {
            if let user = user {
                usernameLabel.text = user.username
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
                    //addButton.selected = true
                    let image = UIImage(named: "Settings")
                    addButton.setImage(image, forState: .Normal)
                }
                if canFollow == 0 {
                   // addButton.selected = false
                    let image = UIImage(named: "Add")
                    addButton.setImage(image, forState: .Normal)
                }
                if canFollow == 2 {
                    //addButton.selected = true
                    let image = UIImage(named: "facetag_checkmark")
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
            delegate?.cell(self, didSelectUnFriendUser: user!)
            self.canFollow = 0
        }
    }
}
