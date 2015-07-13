//
//  ViewController.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
    }
    

    //
    override func viewWillAppear(animated: Bool) {
        
    //changes the title to an image in the navigation bar
        let image = UIImage(named: "Image")!
        // or changes title: self.navigationItem.title = "random"
        self.navigationItem.titleView = UIImageView(image: image)
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
