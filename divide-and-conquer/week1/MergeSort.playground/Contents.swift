import UIKit

let input = [5,4,1,8,7,2,6,3]

// Assuming all numbers are different and input.count is even
func mergeSort(input: [Int]) -> [Int] {
    if input.count <= 1 {
        return input
    } else {
        let a1: [Int] = Array(input.prefix(input.count/2))
        let a2: [Int] = input.suffix(input.count/2)
        let left = mergeSort(input: a1)
        let right = mergeSort(input: a2)
        return merge(left: left, right: right)
    }
}

func merge(left: [Int], right: [Int]) -> [Int] {
    var left = left
    var right = right
    
    var merged = [Int]()
    
    while left.count > 0 && right.count > 0 {
        if left.first! < right.first! {
            merged.append(left.removeFirst())
        } else {
            merged.append(right.removeFirst())
        }
    }
    return merged + left + right
}

let sorted = mergeSort(input: input)

print("sorted \(sorted)")
