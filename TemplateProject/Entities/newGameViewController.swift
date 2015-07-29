//
//  ViewController.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class newGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate  {
    

    
    @IBOutlet weak var newGameTableView: UITableView!
    
    @IBOutlet var newGameSearchBar: UISearchBar!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var foundFriends: [PFUser]!
    
    var selectedFriends: [PFUser] = []
    
    var query: PFQuery? {
        didSet {
            oldValue?.cancel()
        }
    }
    
//    enum State {
//        case DefaultMode
//        case SearchMode
//    }
//    var state: State = .DefaultMode {
//        didSet{
//            switch(state) {
//            case .DefaultMode:
//                query = ParseHelper.getFriends(defaultUpdateList)
//            
//            case .SearchMode:
//                query = ParseHelper.getFriends(searchUpdateList)
//              
//            }
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        state = .DefaultMode
        newGameTableView.dataSource = self
        ParseHelper.getFriends(searchUpdateList)
        
        // Do any additional setup after loading the view.
    }
    
    func defaultUpdateList(results: [AnyObject]?, error: NSError?) {
        var friends = results as? [PFObject] ?? []
        self.foundFriends = friends.map({ (friend) -> PFUser in
            return friend["toUser"] as! PFUser
        })
        self.newGameTableView.reloadData()
        
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    func searchUpdateList(results: [AnyObject]?, error: NSError?) {
        var friends = results as? [PFObject] ?? []
        self.foundFriends = friends.map({ (friend) -> PFUser in
            return friend["toUser"] as! PFUser
        })
        
        let searchText = self.newGameSearchBar?.text ?? ""
        if searchText == "" {
            self.foundFriends = self.foundFriends.filter { (friend) -> Bool in
                return friend.username!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            }
        }
        self.newGameTableView.reloadData()
    }
//        if let error = error {
//            ErrorHandling.defaultErrorHandler(error)
//        }
   
    
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//         var cell: NewGameTableViewCell = self.newGameTableView.dequeueReusableCellWithIdentifier("friendCell") as! NewGameTableViewCell!
//        if contains(selectedFriends, foundFriends[indexPath.row]) == false {
//            selectedFriends.append(foundFriends[indexPath.row])
//            cell.checkmark = true
//        }
//    }
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//         var cell: NewGameTableViewCell = self.newGameTableView.dequeueReusableCellWithIdentifier("friendCell") as! NewGameTableViewCell!
//        if contains(selectedFriends, foundFriends[indexPath.row]) == true {
//            selectedFriends.removeAtIndex(indexPath.row)
//            cell.checkmark = false
//        }
//         println(selectedFriends)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension newGameViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        //state = .SearchMode
        ParseHelper.getFriends(searchUpdateList)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        //state = .DefaultMode
        ParseHelper.getFriends(searchUpdateList)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.getFriends(searchUpdateList)
    }
    
}


