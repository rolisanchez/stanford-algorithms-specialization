import UIKit

// Assuming all numbers are different and input.count is even, multiple of 2
func mergeSortCountInv(left: [Int], right: [Int]) -> ([Int], Int) {
    var left = left
    var right = right
    var merged = [Int]()
    var splitInv = 0
    
    while left.count > 0 && right.count > 0 {
        if left.first! < right.first! {
            merged.append(left.removeFirst())
        } else {
            merged.append(right.removeFirst())
            splitInv += left.count
        }
    }
    
    merged = merged + left + right
    return (merged, splitInv)
}


func sortAndCountInv(input: [Int]) -> ([Int], Int) {
    let n = input.count
    if n <= 1  {
        return (input, 0)
    } else {
        let (C, leftInv) = sortAndCountInv(input: Array(input.prefix(n/2)))
        let (D, rightInv) = sortAndCountInv(input: Array(input.suffix(n/2)))

        let (B, splitInv) = mergeSortCountInv(left: C, right: D)
        
        return (B, leftInv+rightInv+splitInv)
    }
}

let input = [1,3,5,2,4,6,7,8]
//let input = [1,3,5,2,4,6] // Doesn't work - Needs 2^n

let (sorted, invertions) = sortAndCountInv(input: input)

print("sorted \(sorted)")
print("invertions \(invertions)")


if let filepath = Bundle.main.path(forResource: "integerArray", ofType: "txt") {
    do {
        if let contents = try? String(contentsOfFile: filepath) {
            let numbersString = contents.components(separatedBy: "\n")
            print("numbersString \(numbersString.count)")
//            print("numbersString.first \(Int((numbersString.first?.trimmingCharacters(in: .whitespacesAndNewlines))!))")


            let numbers: [Int] = numbersString.map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
//            print("numbers.first \(numbers.first)")
            
//            let (sortedChallenge, invertionsChallenge) = sortAndCountInv(input: numbers)
            
//            print("sortedChallenge \(sortedChallenge)")
            // 1035744464 (Swift)
            // 1176350207
            // 2407905288
//            print("invertionsChallenge \(invertionsChallenge)")
        } else {
            print("Could not get contents")
        }
//        print(contents)
    }
} else {
    // example.txt not found!
    print("Error loading String")
}
