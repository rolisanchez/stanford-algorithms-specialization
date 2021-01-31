import Foundation

func getHammingDistanceXor(w1: Int, w2: Int) -> Int {
    return Array(String(w1 ^ w2, radix: 2)).reduce(0) { $0 + ($1 == "1" ? 1 : 0)}
}

class UnionFind {
    var parents = [Int]() // Ex: parents[1] = 2 means that 1's parent is 2
    var sizes = [Int]() // Ex: size[2] = 1 means that 2's size is 1

    func find(element: Int) -> Int {
        let parent = parents[element]

        if parent == element {
            return element
        } else {
            return find(element: parent)
        }
    }

    func union(element1: Int, element2: Int) {
        let el1Parent = find(element: element1)
        let el2Parent = find(element: element2)

        if el1Parent == el2Parent {
            return
        }

        if sizes[el1Parent] >= sizes[el2Parent] {
            parents[el2Parent] = el1Parent
            sizes[el1Parent] = sizes[el1Parent] + sizes[el2Parent]
        } else {
            parents[el1Parent] = el2Parent
            sizes[el2Parent] = sizes[el1Parent] + sizes[el2Parent]
        }
    }
}

struct Edge: Equatable {
    let identifier: Int
    let source: Int
    let destination: Int
    let weight: Int

    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

let filepath = "./clustering_big.txt"
// let filepath = "./shorter_hamming.txt"

// let MAX_ELEMENTS = 5
let MAX_ELEMENTS = 200000
var clustersCount = MAX_ELEMENTS

var codeToVertex = [String:Int]() // 11100 can correspond to vertex 1 and 2

var edges = [Edge]()

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        lines = Array(lines[1..<lines.count])
        let intLines = lines.map{ Int($0, radix: 2)! }

        let unionFind = UnionFind()

        for i in 0..<MAX_ELEMENTS {
            // Each one is their own parent
            unionFind.parents.append(i)
            unionFind.sizes.append(1)
        }

        print("intLines.count: ", intLines.count)
        var id_counter = 0
        var loopCounter = 1
        outerLoop: for (vertexNum1, code1) in intLines.enumerated() {
            let vertexNum2Start = vertexNum1 + 1
            let intLinesCopy = Array(intLines[vertexNum2Start..<intLines.count])
            DispatchQueue.concurrentPerform(iterations: intLinesCopy.count) { index in
                // print("index: ", index)
                let vertexNum2 = vertexNum2Start + index
                let code2 = intLinesCopy[index]
                let distance = getHammingDistanceXor(w1: code1, w2: code2)
                if distance < 3 {
                    let edge = Edge(identifier: id_counter, source: vertexNum1, destination: vertexNum2, weight: distance)
                    edges.append(edge)
                    id_counter += 1
                }
            
            }
            
            print("Finished outerloop \(loopCounter)/\(MAX_ELEMENTS)")
            loopCounter += 1
        }

        print("Edges count 1: ", edges.count)
        print("clustersCount 1: ", clustersCount)
        // Sort from smallest to largest
        edges.sort { $0.weight < $1.weight }

        // Kruskal's Greedy to find Edge with min weight (Only explored unused edges)
        for edge in edges {
            if unionFind.find(element: edge.source) != unionFind.find(element: edge.destination) {
                clustersCount -= 1
                // Merge: Union on Union Find Data Structure
                unionFind.union(element1: edge.source, element2: edge.destination)
                if let index = edges.firstIndex(of: edge) {
                    edges.remove(at: index)
                }
            }
        }

        print("Edges count: ", edges.count)
        print("clustersCount: ", clustersCount)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else {
        fatalError("Could not open file")
    }
}