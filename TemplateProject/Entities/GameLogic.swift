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

typealias GameCreatedCallback = (PFObject?) -> ()


func CreateNewGame(secondPlayer: PFUser, callback: GameCreatedCallback ) {
    
    let game = PFObject(className: parseGame)
    game[parsePlayNumber] = 0
    game["phaseNumber"] = 0
    game[parseFirstPlayer] = PFUser.currentUser()
    game[parseWhoseTurn] = PFUser.currentUser()
    game[parseSecondPlayer] = secondPlayer
    game["score"] = 0
    game.saveInBackgroundWithBlock { (success, error) -> Void in
        if success {
            callback(game)
        } 
    }
}

func GameQuery(callback: [PFObject] -> Void) {
    var result: PFObject?

    var firstPlayerQuery = PFQuery(className: parseGame)
    firstPlayerQuery.whereKey(parseFirstPlayer, equalTo: PFUser.currentUser()!)
    var secondPlayerQuery = PFQuery(className: parseGame)
    secondPlayerQuery.whereKey(parseSecondPlayer, equalTo: PFUser.currentUser()!)
    
    var gameQuery = PFQuery.orQueryWithSubqueries([firstPlayerQuery, secondPlayerQuery])
    gameQuery.includeKey(parseFirstPlayer)
    gameQuery.includeKey(parseSecondPlayer)
    gameQuery.includeKey(parseWhoseTurn)
    gameQuery.orderByAscending("createdAt")

    gameQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
        if error == nil {
            
            if let objects = objects as? [PFObject] {
                callback(objects)
            }
        }
    }
}





