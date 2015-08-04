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
    
    func animateTable() {
        self.mainTableView.reloadData()
        
        let cells = mainTableView.visibleCells()
        let tableHeight: CGFloat = mainTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as! mainGameTableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! mainGameTableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    override func viewWillAppear(animated: Bool) {
        refresh(1)
    }
    func refresh(sender: AnyObject) -> Void  {
        GameQuery() { result in
            self.games = result
            if let sender = sender as? Int {
            } else {
                self.animateTable()
            }
            //self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
        
        
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
                cell.textLabel?.enabled = true
                cell.textLabel?.alpha = 1.0
            }
            else {
                cell.userInteractionEnabled = false
//                cell.alpha = 0.1
//                cell.backgroundColor = UIColor.grayColor()
                cell.textLabel?.enabled = false
                cell.textLabel?.alpha = 0.4
//                cell.hidden = true
//                let grayView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
//                grayView.backgroundColor = UIColor.blackColor()
//                grayView.alpha = 0.5
//                cell.addSubview(grayView)
//                cell.bringSubviewToFront(grayView)
                
                
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
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
                destination.game = game
            }
        }
    }

    func presentGameController(notification: NSNotification) {
        if let game = notification.object as? PFObject {
            self.performSegueWithIdentifier("segueToGame", sender: game)
        }
    }
}

    
