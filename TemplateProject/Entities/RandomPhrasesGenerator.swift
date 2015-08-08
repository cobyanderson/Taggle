//
//  RandomPhrasesGenerator.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 8/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation

let promptGlobal: [String] = ["blind clown", "lost your glasses", "crying baby", "roadkill", "pepperspray to the face", "sun in your eyes", "it's been a long night", "the raised eyebrow", "the unibrow", "the smolder", "innocence", "awkward smirk", "begging", "pursed lips", "winky face", "drooling", "brainwashed", "freezing cold", "vampire", "zombie", "stargazer", "cowboy", "Captain Jack Sparrow", "Mary Poppins", "Buzz Lightyear", "Voldemort", "Iron Man", "Santa Claus", "The Queen", "robot","stubbing your toe", "beesting to the face", "getting a papercut", "Knocked-Out", "biting your tounge", "having a nightmare","sneaky ninja", "using your telekinesis", "confused chicken", "trying to concentrate", "waking up at 3 AM", "running a marathon", "blowdrying your hair", "braiding your hair", "surprise! you're bald", "hair flip", "bad hair day", "drop-dead georgeous", "getting the water out your ear", "begging dog", "crick in your neck", "passing out", "listening carefully", "ice bucket challenge", "failing a test", "about to vomit", "winning the lottery", "smile for the camera", "drinking poison", "kissing your love", "biting a juicy apple", "drinking water", "biting a huge sandwich", "eating corn on the cob", "sucking on a lollypop", "chewing gum", "changing a diaper", "smelly socks", "sneezing", "scuba diving", "nosebleed", "breaking your nose", "picking your nose", "runny nose", "wise owl", "whinnying horse", "crazy monkey", "roaring lion", "trumpeting elephant", "hoppy bunny", "chubby chipmunk", "hissing snake", "snarling wolf", "begging dog", "hungry alligator", "quiet mouse" ]

let promptClosedEyes : [String] = ["blind clown", "lost your glasses", "crying baby", "roadkill", "pepperspray to the face", "sun in your eyes", "it's been a long night"]

let promptMouth : [String] = ["kissing your love", "biting a juicy apple", "drinking water", "biting a huge sandwich", "eating corn on the cob", "sucking on a lollypop", "chewing gum"]

let promptAnimal : [String] = ["wise owl", "whinnying horse", "crazy monkey", "roaring lion", "trumpeting elephant", "hoppy bunny", "chubby chipmunk", "hissing snake", "snarling wolf", "begging dog", "hungry alligator", "quiet mouse"]

let promptHead : [String] = ["sneaky ninja", "using your telekinesis", "confused chicken", "trying to concentrate", "waking up at 3 AM", "running a marathon", "blowdrying your hair", "braiding your hair", "surprise! you're bald", "hair flip", "bad hair day"]

let promptHeadTilt : [String] =  ["drop-dead georgeous", "getting the water out your ear", "begging dog", "crick in your neck", "passing out", "listening carefully"]

let promptSurprise : [String] = ["stubbing your toe", "beesting to the face", "getting a papercut", "Knocked-Out", "biting your tounge", "having a nightmare","ice bucket challenge", "failing a test", "about to vomit", "winning the lottery", "smile for the camera", "drinking poison"]

let promptCharacter : [String] =  ["vampire", "zombie", "stargazer", "cowboy", "Captain Jack Sparrow", "Mary Poppins", "Buzz Lightyear", "Voldemort", "Iron Man", "Santa Claus", "The Queen", "robot"]

let promptNose : [String] = ["changing a diaper", "smelly socks", "sneezing", "scuba diving", "nosebleed", "breaking your nose", "picking your nose", "runny nose"]

func getRandomPromptList() -> [String]  {
    
    //ititializes the list that that the four answers choices will be drawn from and the list that will hold them
    var promptCategory: [String]
    var randomPrompt: String
    var randomPromptTrick: String
    var randomPromptGlobal1: String
    var randomPromptGlobal2: String
    var randomPromptList: [String]
    
    // randomly chooses a list of related prompts to pull from, must be updated if new prompt list added
    switch arc4random_uniform(7){
    case 1:
        promptCategory = promptClosedEyes
    case 2:
        promptCategory = promptMouth
    case 3:
        promptCategory = promptAnimal
    case 4:
        promptCategory = promptHead
    case 5:
        promptCategory = promptHeadTilt
    case 6:
        promptCategory = promptCharacter
    case 7:
        promptCategory = promptNose
    default:
        promptCategory = promptSurprise
    }
    
    //gets the random prompt answer and a trick answer from the same list
    var promptCategoryLength : Int = promptCategory.count
    randomPrompt = promptCategory[Int(arc4random_uniform(UInt32(promptCategoryLength)))]
    randomPromptTrick = promptCategory[Int(arc4random_uniform(UInt32(promptCategoryLength)))]
    while randomPromptTrick == randomPrompt {
        randomPromptTrick = promptCategory[Int(arc4random_uniform(UInt32(promptCategoryLength)))]
        
        
    }
    //uses the global list to get two more random prompts making sure they are not the same
    var promptGlobalCategoryLength : Int = promptGlobal.count
    randomPromptGlobal1 = promptGlobal[Int(arc4random_uniform(UInt32(promptGlobalCategoryLength)))]
    while randomPromptGlobal1 == randomPromptTrick || randomPromptGlobal1 == randomPrompt {
        randomPromptGlobal1 = promptGlobal[Int(arc4random_uniform(UInt32(promptGlobalCategoryLength)))]
    }
    randomPromptGlobal2 = promptGlobal[Int(arc4random_uniform(UInt32(promptGlobalCategoryLength)))]
    while randomPromptGlobal2 == randomPromptGlobal1 || randomPromptGlobal2 == randomPromptTrick || randomPromptGlobal2 == randomPrompt {
        randomPromptGlobal2 = promptGlobal[Int(arc4random_uniform(UInt32(promptGlobalCategoryLength)))]
    }
    
    
    randomPromptList = [randomPrompt, randomPromptTrick, randomPromptGlobal1, randomPromptGlobal2]
    
    return randomPromptList
    
}

//func verifyRandomPrompt( ) makes sure it has not been done recently????



func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let c = count(list)
    if c < 2 { return list }
    for i in 0..<(c - 1) {
        let j = Int(arc4random_uniform(UInt32(c - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}