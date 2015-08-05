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
        var cell: mainGameTableViewCell = self.mainTableView.dequeueReusableCellWithIdentifier("gameCell") as! mainGameTableViewCell
        
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
            playerName = playerName.truncate(20, trailing: "...")
            if PFUser.currentUser() == game["whoseTurn"] as? PFUser {
                cell.userInteractionEnabled = true
                cell.textLabel?.enabled = true
                cell.textLabel?.alpha = 1.0
                cell.textLabel?.text = "Play \(playerName)!"
                
            }
            else {
                cell.userInteractionEnabled = false
                cell.textLabel?.enabled = false
                cell.textLabel?.alpha = 0.4
                cell.textLabel?.text = "\(playerName)'s Turn"
            
            }
            cell.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.textLabel!.font = UIFont(name: "STHeitiSC-Medium", size: 17)
            if game["playNumber"] as! Int != 0 && game["playNumber"] as! Int != 1 {
                let gotScore = game["score"] as! Int
                
                let calculatedScore = Float(Float(gotScore) / (game["playNumber"] as! Float)) * 100.0
                let stringScore = String(format: "%0.0f", calculatedScore)
                cell.score.text = "\(stringScore)%"
                if calculatedScore < 50 {
                    cell.score.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                }
                else {
                    cell.score.textColor = UIColor(red: 34/255, green: 250/255, blue: 109/255, alpha: 1)
                }
                cell.score.font = UIFont(name: "STHeitiSC-Medium", size: 25)
            }
            else {
                if game["firstPlayer"] as? PFUser != PFUser.currentUser() {
                    cell.score.text = "New!"
                    cell.score.font = UIFont(name: "STHeitiSC-Medium", size: 18)
                    cell.score.textColor = UIColor(red: 232/255, green: 219/255, blue: 77/255, alpha: 1)
                }
                else {
                    cell.score.text = "Waiting"
                    cell.score.font = UIFont(name: "STHeitiSC-Medium", size: 18)
                    cell.score.textColor = UIColor(red: 38/255, green: 173/255, blue: 197/255, alpha: 1)
                }

            }
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
extension String {
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if count(self) > length {
            return self.substringToIndex(advance(self.startIndex, length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}

    
