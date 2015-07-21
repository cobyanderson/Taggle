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
    
    var user: PFUser? = nil {
        didSet {
            if let user = user {
                usernameLabel.text = user.username
            }
        }
    }
    var canFollow: Bool? = true {
        didSet {
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canFollow = canFollow {
                addButton.selected = !canFollow
                
            }
        }
    }

    
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        if let canFollow = canFollow where canFollow == true {
            delegate?.cell(self, didSelectFriendUser: user!)
            self.canFollow = false
        }
        else {
            delegate?.cell(self, didSelectUnFriendUser: user!)
            self.canFollow = true
        }
    }
}
