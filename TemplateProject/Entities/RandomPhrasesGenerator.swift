//
//  RandomPhrasesGenerator.swift
//  Taggle
//
//  Created by Samuel Coby Anderson on 8/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation


let prompts : [String] = ["blind clown", "lost your glasses", "crying baby", "roadkill", "pepperspray to the face", "sun in your eyes", "it's been a long night", "the raised eyebrow", "the unibrow", "the smolder", "innocence", "awkward smirk", "begging", "pursed lips", "winky face", "drooling", "brainwahed", "freezing cold", "vampire", "zombie", "stargazer", "cowboy", "Captain Jack Sparrow", "Mary Poppins", "Buzz Lightyear", "Voldemort", "Iron Man", "Santa Claus", "The Queen", "robot","stubbing your toe", "beesting to the face", "getting a papercut", "Knocked-Out", "biting your tounge", "having a nightmare","sneaky ninja", "using your telekinesis", "confused chicken", "trying to concentrate", "waking up at 3 AM", "running a marathon", "blowdrying your hair", "braiding your hair", "surprise! you're bald", "hair flip", "bad hair day", "drop-dead georgeous", "getting the water out your ear", "begging dog", "crick in your neck", "passing out", "listening carefully", "ice bucket challenge", "failing a test", "about to vomit", "winning the lottery", "smile for the camera", "drinking poison", "kissing your love", "biting a juicy apple", "drinking water", "biting a huge sandwich", "eating corn on the cob", "sucking on a lollypop", "chewing gum", "changing a diaper", "smelly socks", "sneezing", "scuba diving", "nosebleed", "breaking your nose", "picking your nose", "runny nose", "wise owl", "whinnying horse", "crazy monkey", "roaring lion", "trumpeting elephant", "hoppy bunny", "chubby chipmunk", "hissing snake", "snarling wolf", "begging dog", "hungry alligator", "quiet mouse" ]



func getRandomPromptList() -> [String]  {
    
    //ititializes the list that that the four answers choices will be drawn from and the list that will hold them
    
    var num1 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    var num2 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    while num1 == num2 {
        var num2 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    }
    var num3 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    while num2 == num3 {
        var num3 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    }
    var num4 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    while num3 == num4 {
        var num4 = Int(arc4random_uniform(UInt32(prompts.count - 1)))
    }

    let randomPromptList = [prompts[num1], prompts[num2], prompts[num3], prompts[num4]]
    
    return randomPromptList
    
}


func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let c = count(list)
    if c < 2 { return list }
    for i in 0..<(c - 1) {
        let j = Int(arc4random_uniform(UInt32(c - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}