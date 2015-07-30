//
//  ParseHelper.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    //following relation
    static let ParseFriendClass       = "Friend"
    static let ParseFriendFromUser    = "fromUser"
    static let ParseFriendtoUser      = "toUser"
    
    // User Relation
    static let ParseUserUsername      = "username"
    
    
    // fetches all friends the user has added
    // parameters: user: the user whose friend requests you want to grab, completion block - ?
    static func getFollowedUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseFriendFromUser, equalTo: user)
        query.whereKey("accepted", equalTo: false)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    static func getFriendedUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseFriendFromUser, equalTo: user)
        query.whereKey("accepted", equalTo: true)
        query.findObjectsInBackgroundWithBlock(completionBlock)
 
    }
    // establishes a one way friend relationship from one user to another
    // parameters: user - the one friending, toUser- the one being friended
    static func addFriendRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let friendObject = PFObject(className: ParseFriendClass)
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseFriendtoUser, equalTo: user)
        query.whereKey(ParseFriendFromUser, equalTo: toUser)
        // SHOULD THIS EVER CHECK TO MAKE SURE "ACCEPTED" = FALSE?
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let results = results as? [PFObject] ?? []
            if results.isEmpty == true {
                friendObject.setObject(false, forKey: "accepted")
                
            }
            else {
                friendObject.setObject(true, forKey: "accepted")
                let result = results[0]
                
                result.setValue(true, forKey: "accepted")
                result.saveInBackground()
                
            }
            friendObject.setObject(user, forKey: self.ParseFriendFromUser)
            friendObject.setObject(toUser, forKey: self.ParseFriendtoUser)
            friendObject.saveInBackgroundWithBlock(nil)
        }
        
        
    }
    // deletes both relationships between friends
    // parameters: user - the user that started the friend relationship, toUser -that user's friend
    static func removeFriendRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseFriendFromUser, equalTo: user)
        query.whereKey(ParseFriendtoUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []

            for friendRelationship in results {
                friendRelationship.deleteInBackgroundWithBlock(nil)
            }
        }
        //deletes the inverse copy as well
        let query2 = PFQuery(className: ParseFriendClass)
        query2.whereKey(ParseFriendFromUser, equalTo: toUser)
        query2.whereKey(ParseFriendtoUser, equalTo: user)
        
        query2.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for friendRelationship in results {
                friendRelationship.deleteInBackgroundWithBlock(nil)
            }
            
        }
    }

    // fetches friend requests for the current user, limits this to 20
    // parameters: completion block
    // returns: a query
    // SHOULD REPLACE WITH FRIEND REQUEST FUNCTION LATER!
    static func friendRequests(completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFQuery(className: ParseFriendClass)
    
        query.whereKey(ParseHelper.ParseFriendtoUser, equalTo: PFUser.currentUser()!)
        query.whereKey("accepted", equalTo: false)
        query.includeKey("fromUser")
       
        query.findObjectsInBackgroundWithBlock(completionBlock)

        return query 
    }
    
    //fetches all friended users of the current user
    static func getFriends(completionBlock:PFArrayResultBlock) -> PFQuery {
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseHelper.ParseFriendFromUser, equalTo: PFUser.currentUser()!)
        query.whereKey("accepted", equalTo: true)
        query.includeKey("toUser")
        query.orderByAscending(ParseHelper.ParseFriendtoUser)
        query.findObjectsInBackgroundWithBlock(completionBlock)
       
        return query
    }
    // fetches users that match the search
    // parameters: searchText - text that is used to search, completion block - called when completed
    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
        -> PFQuery {
            /*
            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
            Regex can be slow on large datasets. For large amount of data it's better to store
            lowercased username in a separate column and perform a regular string compare.
            */
            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
                matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    
}
