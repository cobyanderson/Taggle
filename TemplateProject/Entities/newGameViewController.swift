//
//  ViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class newGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    

    @IBOutlet weak var tableSpace: NSLayoutConstraint!
    
    @IBOutlet weak var newGameTableView: UITableView!
    
    @IBOutlet var newGameSearchBar: UISearchBar!
    
    @IBOutlet var startButton: UIButton!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var foundFriends: [PFUser]!
    
    var selectedFriends: [PFUser] = []
    
    var selectedFriendsCount: Int = 0 {
        didSet {
            if selectedFriendsCount > 0 {
                startButton.userInteractionEnabled = true
                startButton.alpha = 1.0
            }
            else {
                startButton.userInteractionEnabled = false
                startButton.alpha = 0.4
            }
            
        }
    }
    
    
    var query: PFQuery? {
        didSet {
            oldValue?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameTableView.dataSource = self
        query = ParseHelper.getFriends(searchUpdateList)
        selectedFriendsCount = 0
        
    }
    @IBAction func StartButtonPressed(sender: AnyObject) {
        CreateNewGame(selectedFriends[0]) { (game) -> Void in
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("ShowGameController", object: game)
        })
        
        }
    }
    
    func searchUpdateList(results: [AnyObject]?, error: NSError?) {
        var friends = results as? [PFObject] ?? []
        self.foundFriends = friends.map({ (friend) -> PFUser in
            return friend["toUser"] as! PFUser
        })
        
        let searchText = self.newGameSearchBar?.text ?? ""
        if searchText != "" {
            self.foundFriends = self.foundFriends.filter { (friend) -> Bool in
                return friend.username!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            }
        }
        self.newGameTableView.reloadData()
    
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: NewGameTableViewCell = self.newGameTableView.dequeueReusableCellWithIdentifier("friendCell") as! NewGameTableViewCell!
        let foundFriend = foundFriends![indexPath.row]
        
        if let totalFacesMade = foundFriend["totalFacesMade"] as? Float {
            
            let successfullyActed = foundFriend["successfullyActed"] as? Float ?? 0.0
            let correctlyGuessed = foundFriend["correctlyGuessed"] as? Float ?? 0.0
            var averageScore = ((successfullyActed + correctlyGuessed) / (totalFacesMade * 2)) * 100.0
            if averageScore > 100 {
                averageScore = 100
            }
            let stringAverageScore = String(format: "%0.0f", averageScore)
            let stringTotalFacesMade = String(format: "%0.0f", totalFacesMade)
            
            let friendScore = "\(stringAverageScore)% of \(stringTotalFacesMade)"
            
            cell.score.text = friendScore
            if averageScore > 50 {
                cell.score.textColor = UIColor(red: 34/255, green: 254/255, blue: 115/255, alpha: 1)
            }
            else {
                cell.score.textColor =  UIColor(red: 250/255, green: 43/255, blue: 86/255, alpha: 1)
            }
        }
        else {
            cell.score.text = "New"
            cell.score.textColor = UIColor.blackColor()
        }
//
//        friendScoreQuery.findObjectsInBackgroundWithBlock {
//            ( results: [AnyObject]?, error:NSError?) -> Void in
//            let results = results as? [PFUser] ?? []
//            }
    
        
        cell.textLabel?.text = (foundFriend.username)?.truncate(20, trailing: "...")
        cell.textLabel?.font = UIFont(name: "STHeitiSC-Light", size: 18)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foundFriends?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if contains(selectedFriends, foundFriends[indexPath.row]) == false {
            selectedFriendsCount = 1
            if selectedFriends.isEmpty == false {
                selectedFriends.removeLast()
            }
            println(selectedFriends)
            selectedFriends.append(foundFriends[indexPath.row])

        }
//        else {
//            if let index = find(selectedFriends, foundFriends[indexPath.row]) {
//                selectedFriends.removeAtIndex(index)
//                selectedFriendsCount = selectedFriendsCount - 1
//
//            }
//        }

    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if contains(selectedFriends, foundFriends[indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension newGameViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tableSpace.constant = 216
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        query = ParseHelper.getFriends(searchUpdateList)
        
        tableSpace.constant = 0
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        query = ParseHelper.getFriends(searchUpdateList)
    }
    
}
extension PFObject: Equatable {
}
public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}


