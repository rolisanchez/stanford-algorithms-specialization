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
