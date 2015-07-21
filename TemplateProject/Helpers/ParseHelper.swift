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
    static func getFriendedUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseFriendClass)
        
        query.whereKey(ParseFriendFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // establishes a one way friend relationship from one user to another
    // parameters: user - the one friending, toUser- the one being friended
    static func addFriendRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let followObject = PFObject(className: ParseFriendClass)
        followObject.setObject(user, forKey: ParseFriendFromUser)
        followObject.setObject(toUser, forKey: ParseFriendtoUser)
        
        followObject.saveInBackgroundWithBlock(nil)
    }
    // deletes the one-way relationship of friends
    // parameters: user - the user that started the friend relationship, toUser -that user's friend
    static func removeFriendRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParseFriendClass)
        query.whereKey(ParseFriendFromUser, equalTo:user)
        query.whereKey(ParseFriendtoUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for follow in results {
                follow.deleteInBackgroundWithBlock(nil)
            }
        }
    }
    // fetches all users less the current one, limits this to 20
    // parameters: completion block
    // returns: a query
    // SHOULD REPLACE WITH FRIEND REQUEST FUNCTION LATER!
    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
            notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
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
