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

        cell.textLabel?.text = foundFriend.username
        cell.textLabel?.font = UIFont(name: "STHeitiSC-Light", size: 18)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foundFriends?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if contains(selectedFriends, foundFriends[indexPath.row]) == false && selectedFriendsCount < 1 {
            selectedFriendsCount = selectedFriendsCount + 1
            selectedFriends.append(foundFriends[indexPath.row])
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            if let index = find(selectedFriends, foundFriends[indexPath.row]) {
                selectedFriends.removeAtIndex(index)
                selectedFriendsCount = selectedFriendsCount - 1
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            }
        }

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


