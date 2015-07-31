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
    var games: [PFObject] = [] {
        didSet {
            mainTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()

        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presentGameController:"), name: "ShowGameController", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh(1)
    }
    func refresh(sender: AnyObject) -> Void  {
        GameQuery() { result in
            self.games = result
        }
        mainTableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.games.count
        }
        else {
            return 0
        }
    }
   
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("gameCell") as! UITableViewCell
        var playerName: String = ""
        let game = games[indexPath.row]
        //RememberThis
        if let firstPlayer = game["firstPlayer"] as? PFUser, secondPlayer = game["secondPlayer"] as? PFUser {
            if firstPlayer != PFUser.currentUser() {
                playerName = firstPlayer.username!
            }
            else {
                playerName = secondPlayer.username!
            }
            if PFUser.currentUser() == game["whoseTurn"] as? PFUser {
                cell.userInteractionEnabled = true
                cell.alpha = 0.4
            }
            else {
                cell.userInteractionEnabled = false
                cell.alpha = 1.0
            }
            
            cell.textLabel?.text = playerName
            cell.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.textLabel!.font = UIFont(name: "STHeitiSC-Medium", size: 17)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("gameViewController") as! GameViewController
        viewController.game = games[indexPath.row]
        self.presentViewController(viewController, animated: true, completion: nil)
//        self.performSegueWithIdentifier("segueToGame", sender: self)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    

    override func viewDidAppear(animated: Bool) {
    
        let image = UIImage(named: "Taggle")!
        self.navigationItem.titleView = UIImageView(image: image)
        self.navigationItem.backBarButtonItem?.title = "    "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let game = sender as? PFObject {
            if let destination = segue.destinationViewController as? GameViewController {
//                destination.game = game
            }
        }
    }

    func presentGameController(notification: NSNotification) {
        if let game = notification.object as? PFObject {
            self.performSegueWithIdentifier("segueToGame", sender: game)
        }
    }
}

    
