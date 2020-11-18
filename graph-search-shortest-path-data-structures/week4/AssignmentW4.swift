import Foundation

// Hash Table Data Structure

let filepath = "./algo1-programming_prob-2sum.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
//        var lineCount = 0
            
        var hashTable =  [Int:Int?]()
        
        for line in lines {
            guard !line.isEmpty else { continue }
//            if lineCount == 5 {
//                break
//            }
//                LineInt: 68037543430
//                LineInt: -21123414637
//                LineInt: 56619844751
//                LineInt: 59688006695
//                LineInt: 82329471587
                
            let lineInt = Int(line.trimmingCharacters(in: .whitespacesAndNewlines))!
//            lineCount += 1
            
            hashTable[lineInt] = 0
        }
        
        print("Finished inserting in hash table")
        var targetValues = 0
//        let tryToFindT = [46914128793]
        
        for t in -10000 ... 10000  {
            print("t: ", t)
            for val in hashTable.keys {
                let y = t - val
                // Must be different
                if y == val {
                    break
                }
                if hashTable.keys.contains(y) {
                    targetValues += 1
                    hashTable[y] = nil
                    hashTable[val] = nil
                    break
                }
            }
        }
        
//        for t in tryToFindT {
//            print("t: ", t)
//            for val in hashTable.keys {
//                print("val: ", val)
//                let y = t - val
//                print("y: ", y)
//                if y == val {
//                    continue
//                }
//                // Must be different
//                if hashTable.keys.contains(y) {
//                    targetValues += 1
//                    hashTable[y] = nil
//                    hashTable[val] = nil
//                    continue
//                }
//            }
//        }
        
        print("targetValues: ", targetValues)
    }
    else {
        fatalError("Could not open file")
    }
}
