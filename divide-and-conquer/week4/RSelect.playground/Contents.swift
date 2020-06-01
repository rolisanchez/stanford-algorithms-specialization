import UIKit

func choosePivot(array: [Int], left: Int, right: Int) -> Int {
//    return left
    //    return right
        return Int.random(in: left..<right)
//        return left + (right-left)/2
}

func partition(array: inout [Int], left: Int, right: Int) -> Int {
    let p = array[left]
    var i = left + 1
    
    for j in left+1..<right {
        if array[j] < p {
            array.swapAt(j, i)
            i += 1
        }
    }
    array.swapAt(left, i-1)
    
    return (i-1)
}

func rSelect(array: inout [Int], i: Int, left: Int, right: Int) -> Int {
    if array.count == 1 {
        return array[0]
    }
    
    let p = choosePivot(array: array, left: left, right: right)
    array.swapAt(left, p)
    
    let j = partition(array: &array, left: left, right: right)
    
    if j == i {
        return p
    } else if j > i {
        return rSelect(array: &array, i: i, left: left, right: j)
    } else {
        return rSelect(array: &array, i: i, left: j+1, right: right)
    }
}


var input = [1,3,5,2,6,4,7,8]

// ith Starts from 0
let position = rSelect(array: &input, i: 2, left: 0, right: input.count)

print("Position is = \(position)")
