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



var playerCount: Int = 0


func CreateNewGame(playerCount: Int) {
    var query = PFUser.query()
    query!.whereKey("username", equalTo: "Felecia")
    var player2 = query!.findObjects()
    query!.whereKey("username", equalTo: "Meilun")
    var player3 = query!.findObjects()
    query!.whereKey("username", equalTo: "Navin")
    var player4 = query!.findObjects()
    
    
    let game = PFObject(className: parseGame)
    game[parsePlayNumber] = 0
    game[parseFirstPlayer] = PFUser.currentUser()
    game[parseWhoseTurn] = PFUser.currentUser()
    game[parseSecondPlayer] = player2![0]
    game[parseThirdPlayer] = player3![0]
    game[parseFourthPlayer] = player4![0]
    
    
    game.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
        if error != nil {
            println("object is not saved")
            return
        }
        println("Object has been saved.")
        
    }
    
}
func FourPlayerGameQuery() {
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
                    let user2 = object[parseSecondPlayer]! as! PFObject
                    let user3 = object[parseThirdPlayer]! as! PFObject
                    let user4 = object[parseFourthPlayer]! as! PFObject
                    let player1: String = (user1[parseUsername]) as! String
                    let player2: String = (user2[parseUsername]) as! String
                    let player3: String = (user3[parseUsername]) as! String
                    let player4: String = (user4[parseUsername]) as! String
                    mainTableViewController.gamePlayerNames.append(" \(player1), \(player2), \(player3), \(player4)")
                    // self.gamePlayerNames.append(" \(object[self.parseFirstPlayer]?.objectId),  \(object[self.parseSecondPlayer]?.objectId),  \(object[self.parseThirdPlayer]?.objectId),  \(object[self.parseFourthPlayer]?.objectId)")
                    println(self.gamePlayerNames)
                }
            }
        }
        else {
            println("error finding games to match current user's turn")
            
        }
    }
    
}
