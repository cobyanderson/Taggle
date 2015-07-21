//
//  AddFriendsViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit


class AddFriendsViewController: UIViewController {
    
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    
    @IBOutlet weak var addFriendsTableView: UITableView!
    
    
    // stores all the users that match the current search query
    var users: [PFUser]?
    
    /*
    This is a local cache. It stores all the users this user is following.
    It is used to update the UI immediately upon user interaction, instead of waiting
    for a server response.
    */
    var friendedUsers: [PFUser]? {
        didSet {
            /**
            the list of following users may be fetched after the tableView has displayed
            cells. In this case, we reload the data to reflect "following" status
            */
            addFriendsTableView.reloadData()
        }
    }
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    // the view has two different states
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                query = ParseHelper.allUsers(updateList)
                
            case .SearchMode:
                let searchText = friendSearchBar?.text ?? ""
                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
            }
        }
    }
    
    /*
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    func updateList(results: [AnyObject]?, error: NSError?) {
        self.users = results as? [PFUser] ?? []
        self.addFriendsTableView.reloadData()
        
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    // VIEW LIFECYCLE?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode
        
        // fill the cache of a user's followees
        ParseHelper.getFriendedUsersForUser(PFUser.currentUser()!) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let relations = results as? [PFObject] ?? []
            // use map to extract the User from a Follow object
            self.friendedUsers = relations.map {
                $0.objectForKey(ParseHelper.ParseFriendtoUser) as! PFUser
            }
            
            if let error = error {
                // Call the default error handler in case of an Error
                ErrorHandling.defaultErrorHandler(error)
            }
        }
    }
    

    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        friendSearchBar.placeholder="Search for Friends by Username"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell") as! AddFriendsTableViewCell
        
        let user = users![indexPath.row]
        cell.user = user
        
        if let friendedUsers = friendedUsers {
            // check if current user is already following displayed user
            // change button appereance based on result
            cell.canFollow = !contains(friendedUsers, user)
        }
        cell.delegate = self
        
        return cell
    }
    
}
// SEARCHBAR VIEW DELEGATE
extension AddFriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
   
    
}
extension AddFriendsViewController: AddFriendsTableViewCellDelegate {
    
    
    
    func cell(cell: AddFriendsTableViewCell, didSelectFriendUser user: PFUser) {
        ParseHelper.addFriendRelationshipFromUser(PFUser.currentUser()!, toUser: user)
        // update local cache
        friendedUsers?.append(user)
    }
    
    func cell(cell: AddFriendsTableViewCell, didSelectUnFriendUser user: PFUser) {
        if var friendedUsers = friendedUsers {
            ParseHelper.removeFriendRelationshipFromUser(PFUser.currentUser()!, toUser: user)
            // update local cache
            removeObject(user, fromArray: &friendedUsers)
            self.friendedUsers = friendedUsers
        }
    }
    
}
extension PFObject: Equatable {
}
public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}
