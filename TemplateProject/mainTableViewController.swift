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
    
    var gamePlayerNames: [String] = [] {
        didSet {
            mainTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.dataSource = self
        
//        PFUser.logInWithUsername("Coby", password: "test")
//        PFUser.logInWithUsernameInBackground("Coby", password: "test") { (<#PFUser?#>, <#NSError?#>) -> Void in
//            <#code#>
//        }
        
        
//        CreateNewGame(4, "Felecia", "Navin", "Meilun", { (success, error) -> Void in
//            if error != nil {
//                println("not saved")
//                return
//            }
//            self.mainTableView.reloadData()
//        })
        GameQuery(3) { result in
            self.gamePlayerNames.append(result)
            
        }
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.gamePlayerNames.count == 0 {
                return 1
            }
            else {
                return self.gamePlayerNames.count
            }
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("Header Cell") as! headerViewCell
        switch section {
        case 0:
            header.headerTitle.text = "Current Games"
            header.backgroundColor = UIColor(red: 34/255, green: 240/255, blue: 109/255, alpha: 1)
        case 1:
            header.headerTitle.text = "Pending Games"
            header.backgroundColor = UIColor(red: 200/255, green: 255/255, blue: 90/255, alpha: 0.8)
        default:
            header.headerTitle.text = "Ended Games"
            header.backgroundColor = UIColor(red: 220/255, green: 80/255, blue: 89/255, alpha: 1)
        }
        return header
    }
   
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("gameCell") as! UITableViewCell
        if self.gamePlayerNames.count == 0 {
            cell.textLabel?.text = "No Games found!😭 Press + below!"
            cell.textLabel?.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        else {
            cell.textLabel?.text = self.gamePlayerNames[indexPath.row]
            cell.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        }
        cell.textLabel!.font = UIFont(name: "STHeitiSC-Medium", size: 16)

        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("you selected the cell at \(indexPath.row)! and index \(indexPath.section)!")
        self.performSegueWithIdentifier("segueToGame", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
    override func viewDidAppear(animated: Bool) {
        
    //changes the title to an image in the navigation bar but image moves jankily when view pushes
        let image = UIImage(named: "Taggle")!
//         or changes title: self.navigationItem.title = "random"
        self.navigationItem.titleView = UIImageView(image: image)
        self.navigationItem.backBarButtonItem?.title = "    "
        
        
        
        
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

    
