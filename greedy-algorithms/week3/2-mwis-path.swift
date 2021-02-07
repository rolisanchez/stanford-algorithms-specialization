import Foundation

let filepath = "./mwis.txt"
// let filepath = "./test_mwis.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        var weights = contents.components(separatedBy: "\n").map{Int($0)!}
        weights = Array(weights[1..<weights.count])

        var computationsArr = [Int]()
        // A[0] = 0
        computationsArr.append(0)
        // A[1] = w1
        computationsArr.append(weights[0])

        // WIS
        for i in 1..<weights.count {
            let weight = weights[i]
            // instead of A[i-1] and A[i-2] we do the following because our weights array starts on index 0, not on index 1
            let computation = max(computationsArr[i],(computationsArr[i-1]+weight))
            computationsArr.append(computation)
        }

        // Reconstruction
        var i = weights.count
        var maximumIndependentSet = [Int]()
        while i >= 2 {
            // Again, our array starts on index 0, so can't access weights[weights.count]
            let weight = weights[i-1]
            if computationsArr[i-1] >= (computationsArr[i-2] + weight) {
                i -= 1
            } else {
                maximumIndependentSet.append(i)
                i -= 2
            }
        }
        if i == 1 {
            maximumIndependentSet.append(1)
        }

        print("Total weight of MWIS: ", computationsArr.last!)
        print("maximumIndependentSet: ", maximumIndependentSet)

        let checkVertices = [1, 2, 3, 4, 17, 117, 517,997]
        var bitAnswer = ""
        for checkVertex in checkVertices {
            if maximumIndependentSet.contains(checkVertex) {
                bitAnswer += "1"
            } else {
                bitAnswer += "0"
            }
        }

        print(bitAnswer)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else {
        fatalError("Could not open file")
    }
}