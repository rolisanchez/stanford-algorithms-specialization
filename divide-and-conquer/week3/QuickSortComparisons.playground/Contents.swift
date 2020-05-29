import UIKit

func choosePivot(array: [Int], left: Int, right: Int) -> Int {
    return left
//    return right
//    return Int.random(in: left..<right)
//    return left + (right-left)/2
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

var comparisons = 0

func quickSort(array: inout [Int], left: Int, right: Int) {
    if left >= right {
        return
    }

    let i = choosePivot(array: array, left: left, right: right)
    array.swapAt(left, i)

    comparisons += (right - left - 1)
    let j = partition(array: &array, left: left, right: right)
    quickSort(array: &array, left: left, right: j)
    quickSort(array: &array, left: j+1, right: right)
}

//var input = [1,3,5,2,6,4,7,8]//.shuffled()
//
//quickSort(array: &input, left: 0, right: input.count)
//
//print("input = ", input)
//print("comparisons = ", comparisons)


if let filepath = Bundle.main.path(forResource: "QuickSort", ofType: "txt") {
    do {
        if let contents = try? String(contentsOfFile: filepath) {
            let numbersStringArray = contents.components(separatedBy: "\n")
//            print("numbersStringArray \(numbersStringArray.count)")
            var numbersArray: [Int] = numbersStringArray.map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }
            quickSort(array: &numbersArray, left: 0, right: 10000)
            print("numbersArray = ", numbersArray[1..<20])
            print("comparisons = ", comparisons)

        }else {
            print("Could not get contents")
        }
    }

}  else {
    print("Error loading String")
}

// Random
