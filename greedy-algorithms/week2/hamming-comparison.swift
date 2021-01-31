import Foundation

func getHammingDistance(w1: String, w2: String) -> Int {
    if w1.count != w2.count {
        return -1
    }

    let arr1 = Array(w1)
    let arr2 = Array(w2)

    var counter = 0
    counterLoop: for i in 0 ..< arr1.count {
        if arr1[i] != arr2[i] { 
            counter += 1
            // Exit early. We conly care about LESS THAN 3
            if counter == 3 {
                break counterLoop
            }
        }
    }

    return counter
}

func getHammingDistanceXor(w1: Int, w2: Int) -> Int {
    return Array(String(w1 ^ w2, radix: 2)).reduce(0) { $0 + ($1 == "1" ? 1 : 0)}
    // Early stopping below is slower because of the variable storing
    // let strArr = Array(String(w1 ^ w2, radix: 2))
    // let half1Dist = strArr[0..<strArr.count/2].reduce(0) { $0 + ($1 == "1" ? 1 : 0)}

    // if half1Dist > 2 {
    //     return half1Dist
    // }
    // return half1Dist + strArr[strArr.count/2..<strArr.count].reduce(0) { $0 + ($1 == "1" ? 1 : 0)}
}
let filepath = "./clustering_big.txt"

do {
    // let str1 = "111000001101001111001111"
    // let str2 = "011001100101111110101101"

    // var start = DispatchTime.now().uptimeNanoseconds
    // print("Hamming distance: ", getHammingDistance(w1: str1, w2: str2))
    // var end = DispatchTime.now().uptimeNanoseconds
    // print("Time elapsed: \((end-start)/1_000)μs")

    // // let intStr1 = Int("0001", radix: 2)!
    // // let intStr2 = Int("0111", radix: 2)!

    // let intStr1 = Int(str1, radix: 2)!
    // let intStr2 = Int(str2, radix: 2)!

    // start = DispatchTime.now().uptimeNanoseconds
    // let xorResult = String(intStr1 ^ intStr2, radix: 2)
    // let arr = Array(xorResult)
    // // let distance = arr.reduce(0) { $0 + ($1 == "1" ? 1 : 0)}
    // print("Hamming distance: ", arr.reduce(0) { $0 + ($1 == "1" ? 1 : 0)})
    // end = DispatchTime.now().uptimeNanoseconds
    // print("Time elapsed: \((end-start)/1_000)μs")

    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        // lines = Array(lines[1..<lines.count])
        lines = Array(lines[1..<1000])

        var start = DispatchTime.now().uptimeNanoseconds
        outerLoop: for (vertexNum1, code1) in lines.enumerated() {
            innerLoop: for (_, code2) in Array(lines[vertexNum1+1..<lines.count]).enumerated() {
                _ = getHammingDistance(w1: code1, w2: code2)
            }
        }
        var end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")

        let intLines = lines.map{ Int($0, radix: 2)! }

        start = DispatchTime.now().uptimeNanoseconds
        outerLoop: for (vertexNum1, code1) in intLines.enumerated() {
            innerLoop: for (_, code2) in Array(intLines[vertexNum1+1..<intLines.count]).enumerated() {
                _ = getHammingDistanceXor(w1: code1, w2: code2)
            }
        }
        end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")

        // Using Async
        start = DispatchTime.now().uptimeNanoseconds
        outerLoop: for (vertexNum1, code1) in lines.enumerated() {
            DispatchQueue.main.async {
                innerLoop: for (_, code2) in Array(lines[vertexNum1+1..<lines.count]).enumerated() {
                    _ = getHammingDistance(w1: code1, w2: code2)
                }
            }
        }
        end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")

        start = DispatchTime.now().uptimeNanoseconds
        outerLoop: for (vertexNum1, code1) in intLines.enumerated() {
            DispatchQueue.main.async {
                innerLoop: for (_, code2) in Array(intLines[vertexNum1+1..<intLines.count]).enumerated() {
                    _ = getHammingDistanceXor(w1: code1, w2: code2)
                }
            }
        }
        end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
        
    } else {
        fatalError("Could not open file")
    }
}