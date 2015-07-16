//
//  ViewController.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import Parse
import UIKit
import ConvenienceKit

class mainTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mainTableView: UITableView!
    
    
    
    var playerNames: [String] = ["Joey","Felecia","Vikram"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.dataSource = self
        
        //testing Parse
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.playerNames.count
        } else {
            return 1
        }
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Mama"
//        } else {
//            return "Papa"
//        }
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("Header Cell") as! headerViewCell
        switch section {
        case 0:
            header.headerTitle.text = "Current Games"
        case 1:
            header.headerTitle.text = "Pending Games"
        default:
            header.headerTitle.text = "Ended Games"
        }
        return header
    }
   
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("gameCell") as! UITableViewCell
        cell.textLabel?.text = self.playerNames[indexPath.row]
        cell.textLabel!.font = UIFont(name: "STHeitiSC-Light", size: 20)

        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("you selected the cell at \(indexPath.row)! and index \(indexPath.section)!")
    }

//        
//        func mainTableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//            let cell = mainTableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath) as! mainGameTableViewCell
//            
//            let row = indexPath.row
//            cell.textLabel?.text = "Hello World"
//            
//            return cell
//        }
//        func mainTableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return 5
//        }
    
    
    

    //
    override func viewWillAppear(animated: Bool) {
        
    //changes the title to an image in the navigation bar
        let image = UIImage(named: "Taggle")!
        // or changes title: self.navigationItem.title = "random"
        self.navigationItem.titleView = UIImageView(image: image)
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

    
