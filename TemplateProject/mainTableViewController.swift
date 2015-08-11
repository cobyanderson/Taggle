
import Parse
import UIKit
import ConvenienceKit

class mainTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
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
       // super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
       refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
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
        addButton.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! mainGameTableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
        UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
            self.addButton.transform = CGAffineTransformMakeTranslation(0, 0);
        }, completion: nil)
        
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
            self.refreshControl?.endRefreshing()
        }
        
        
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 0.9)
        
        return [deleteButton]
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.games[indexPath.row].deleteInBackgroundWithBlock({ (bool: Bool, error: NSError?) -> Void in
                self.refresh("")
            })
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
                
                cell.textLabel?.alpha = 1.0
            }
            else {
                cell.textLabel?.alpha = 0.5
            }
            
            cell.textLabel!.text = "\(playerName)"
            cell.textLabel!.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.textLabel!.font = UIFont(name: "STHeitiSC-Medium", size: 17)
            if game["playNumber"] as! Int != 0 {
                
                if (game["whoseTurn"] as! PFUser) != PFUser.currentUser()! {
                    cell.score.textColor = UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
                    cell.score.text = "Their Turn"
                }
                else {
                    cell.score.textColor = UIColor(red: 34/255, green: 250/255, blue: 109/255, alpha: 1)
                    cell.score.text = "Your Turn!"
                }
              
            }
            else {
                if game["firstPlayer"] as? PFUser != PFUser.currentUser() {
                    cell.score.text = "New!"
                    
                    cell.score.textColor = UIColor(red: 232/255, green: 219/255, blue: 77/255, alpha: 1)
                }
                else {
                    cell.score.text = "Waiting"
                   
                    cell.score.textColor = UIColor(red: 38/255, green: 173/255, blue: 197/255, alpha: 1)
                }

            }
             cell.score.font = UIFont(name: "STHeitiSC-Medium", size: 18)
        }
        
        return cell
    }
    
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mainTableView.cellForRowAtIndexPath(indexPath)?.textLabel?.alpha == 1 {
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("gameViewController") as! GameViewController
  
            viewController.game = games[indexPath.row]
        
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        mainTableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
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

    
