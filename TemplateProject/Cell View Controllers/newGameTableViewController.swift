//
//  TableViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class NewGameTableViewCell: UITableViewCell {
    
  
    @IBOutlet var friendQueued: UIImageView!
    
    var checkmark: Bool = false {
        didSet {
                if checkmark == true {
                    friendQueued.highlighted = true
                }
                else {
                    friendQueued.highlighted = false
                }
                
            }
        }
    
    
}

