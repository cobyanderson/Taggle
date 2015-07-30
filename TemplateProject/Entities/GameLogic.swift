//
//  GameLogic.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import UIKit
import Foundation
import Parse

let parseUsername = "username"
let parseFirstPlayer = "firstPlayer"
let parseSecondPlayer = "secondPlayer"
let parseThirdPlayer = "thirdPlayer"
let parseFourthPlayer = "fourthPlayer"
let parsePlayNumber = "playNumber"
let parseGame = "Game"
let parseWhoseTurn = "whoseTurn"
let parseObjectID = "objectId"


func CreateNewGame(playerCount: Int, secondPlayer: PFUser, thirdPlayer: PFUser, fourthPlayer: PFUser, callback: PFBooleanResultBlock ) {
    
//    var query = PFUser.query()
//    query!.whereKey("username", equalTo: secondPlayer)
//    var player2 = query!.findObjects()
//    query!.whereKey("username", equalTo: thirdPlayer)
//    var player3 = query!.findObjects()
//    query!.whereKey("username", equalTo: fourthPlayer)
//    var player4 = query!.findObjects()
    
    
    let game = PFObject(className: parseGame)
    game[parsePlayNumber] = 0
    game[parseFirstPlayer] = PFUser.currentUser()
    game[parseWhoseTurn] = PFUser.currentUser()
    game[parseSecondPlayer] = secondPlayer
    if playerCount > 2 {
        game[parseThirdPlayer] = thirdPlayer
    }
    if playerCount > 3 {
        game[parseFourthPlayer] = fourthPlayer
    }
    game.saveInBackgroundWithBlock(callback)
//    game.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//        if error != nil {
//            println("object is not saved")
//            callback(false, NSError(domain: "Object is not saved", code: 18, userInfo: nil))
//            return
//        }
//        println("Object has been saved.")
//        callback(true, nil)
//    }
    
}
func GameQuery(playerCount: Int, callback: String -> Void) {
    var gameQuery = PFQuery(className: parseGame)
    gameQuery.whereKey(parseWhoseTurn, equalTo: PFUser.currentUser()!)
    gameQuery.includeKey(parseFirstPlayer)
    gameQuery.includeKey(parseSecondPlayer)
    gameQuery.includeKey(parseThirdPlayer)
    gameQuery.includeKey(parseFourthPlayer)
    gameQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
        if error == nil {
            if let objects = objects as? [PFObject] {
                for object in objects {
                    
                    let user1 = object[parseFirstPlayer]! as! PFObject
                    let player1: String = (user1[parseUsername]) as! String
                    
                    let user2 = object[parseSecondPlayer]! as! PFObject
                    let player2: String = (user2[parseUsername]) as! String
                    var result: String = "\(player1), \(player2)"

                    if let user3 = object[parseThirdPlayer] as? PFObject {
                        let player3: String = (user3[parseUsername]) as! String
                        result = "\(player1), \(player2), \(player3)"
                    }
    
                    if let user4 = object[parseFourthPlayer] as? PFObject {
                        let player4: String = (user4[parseUsername]) as! String
                        let user3 = object[parseThirdPlayer]! as! PFObject
                        let player3: String = (user3[parseUsername]) as! String
                        result = "\(player1), \(player2), \(player3), \(player4)"
                    }
                    callback(result)
                    // self.gamePlayerNames.append(" \(object[self.parseFirstPlayer]?.objectId),  \(object[self.parseSecondPlayer]?.objectId),  \(object[self.parseThirdPlayer]?.objectId),  \(object[self.parseFourthPlayer]?.objectId)")
                }
            }
        }
        else {
            println("error finding games to match current user's turn")
            
        }
    }
    
}
