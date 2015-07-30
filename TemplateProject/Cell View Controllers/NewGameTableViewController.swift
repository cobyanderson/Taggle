//
//  TableViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit

public var selectedFriends: [PFUser] = []

class NewGameTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttontapped(sender: AnyObject) {
        
        let image = UIImage(named: "Checkmark")
        button.setImage(image, forState: .Normal)
        
    }
    


}