//: Playground - noun: a place where people can play

import UIKit


// windy,

let promptGlobal: [String] = ["blind clown", "jinkies! you lost your glasses", "yawning lion", "roadkill","stubbing your toe, on a cactus", "just sat on a cactus", "getting a papercut", "broke your nose", "you spilled milk", "stepping in a puddle, of lava", "ouch a papercut","sneaky ninja", "using your telekinesis", "confused chicken", "trying to concentrate", "waking up at 3 AM","blowdrying your hair", "braiding your hair", "Surprise! you're bald","getting the water out your ear", "begging dog", "crick in your neck", "wilted flower", "ice bucket challenge", "cracking your phone", "getting an F", "finding $20", "winning the lottery", "changing a diaper", "smelling smelly socks", "sneezy elephant", "scuba diving"]

let promptClosedEyes : [String] = ["blind clown", "jinkies! you lost your glasses", "yawning lion", "roadkill"]

let promptPain : [String] = ["stubbing your toe, on a cactus", "just sat on a cactus", "getting a papercut", "broke your nose", "you spilled milk", "stepping in a puddle, of lava", "ouch a papercut" ]

let promptConcentrate : [String] = ["sneaky ninja", "using your telekinesis", "confused chicken", "trying to concentrate", "waking up at 3 AM"]

let promptHair : [String] = ["blowdrying your hair", "braiding your hair", "Surprise! you're bald"]

let promptHeadTilt : [String] =  ["getting the water out your ear", "begging dog", "crick in your neck", "wilted flower"]

let promptSurprise : [String] = ["ice bucket challenge", "cracking your phone", "getting an F"]

let promptHappy : [String] =  ["finding $20", "winning the lottery", ]

let promptNose : [String] = ["changing a diaper", "smelling smelly socks", "sneezy elephant", "scuba diving" ]

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
        promptCategory = promptPain
    case 3:
        promptCategory = promptConcentrate
    case 4:
        promptCategory = promptHair
    case 5:
        promptCategory = promptHeadTilt
    case 6:
        promptCategory = promptHappy
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


var unshuffledAnswers = getRandomPromptList()
var answer = unshuffledAnswers.first
var answerChoices = shuffle(unshuffledAnswers)









