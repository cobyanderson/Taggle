

import Foundation
import Parse



var allPrompts: PFObject?

func initializePromptList() {

    
    let object = PFObject(withoutDataWithClassName: "Prompts", objectId: "btpcrA2gXo")
    object.fetchInBackgroundWithBlock() {
        (res: PFObject?, err: NSError?) -> Void in
        if let result = res {
            allPrompts = result as PFObject

        }
    }
    
}

func getRandomPromptList() -> [String]  {
    
    var answer = ""
    var trick = ""
    var randomChoice1 = ""
    var randomChoice2 = ""
    
    var promptCount = allPrompts!["pCount"] as! Int
    var random1 = Int(arc4random_uniform(UInt32(promptCount)) + 1)
    var random2 = Int(arc4random_uniform(UInt32(promptCount)) + 1)
    var random3 = Int(arc4random_uniform(UInt32(promptCount)) + 1)
    
    var answerCategory = allPrompts!["p" + (String(random1))] as! [String]
    
    var randomCategory1 = allPrompts!["p" + (String(random2))] as! [String]
    var randomCategory2 = allPrompts!["p" + (String(random3))] as! [String]
    
    while answer == trick || answer == randomChoice1 || answer == randomChoice2 || trick == randomChoice1 || trick == randomChoice2 || randomChoice1 == randomChoice2 {
        
        var subRandomAnswer = Int(arc4random_uniform(UInt32(answerCategory.count)))
        var subRandomTrick = Int(arc4random_uniform(UInt32(answerCategory.count)))
        var subRandom1 = Int(arc4random_uniform(UInt32(randomCategory1.count)))
        var subRandom2 = Int(arc4random_uniform(UInt32(randomCategory2.count)))
        
        
        answer = answerCategory[subRandomAnswer]
        trick = answerCategory[subRandomTrick]
        randomChoice1 = randomCategory1[subRandom1]
        randomChoice2 = randomCategory2[subRandom2]
        
    }
    
    let randomPromptList = [answer, trick, randomChoice1, randomChoice2]
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