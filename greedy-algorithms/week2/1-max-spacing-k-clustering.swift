import Foundation

struct Cluster {
    var elements: Set<Int> // Contains elements from 1 to 500
}

struct Edge {
    let source: Int
    let destination: Int
    let weight: Int
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
// var unionFind = [Int: Int]() // Ex: 1: 2 means that 1's parent is 2

var edges = [Edge]()

let DESIRED_CLUSTERS = 4

let filepath = "./clustering1.txt"

var clusters = [Cluster]()

// func findParent(element: Int) -> Int{
//     let parent = unionFind[element]!

//     if parent == element {
//         return element
//     } else {
//         return findParent(element: parent)
//     }
// }

do {
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        lines = Array(lines[1..<lines.count])

        let unionFind = UnionFind()
        for i in 0...500 {
            // Each one is their own parent
            unionFind.parents.append(i)
            unionFind.sizes.append(1)

        }

        lines.forEach { line in 
            let edgesWeights = line.components(separatedBy: " ")
            let edge = Edge(source: Int(edgesWeights[0])!, destination: Int(edgesWeights[1])!, weight: Int(edgesWeights[2])!)
            edges.append(edge)
        }

        print("Edges count: ", edges.count)

        // Test Union Find
        // unionFind.parents[1] = 4
        // unionFind.parents[2] = 1
        // unionFind.parents[3] = 1

        // unionFind.sizes[4] = 4

        // unionFind.parents[5] = 6

        // unionFind.sizes[6] = 2

        // print(unionFind.parents)
        // print(unionFind.sizes)
        
        // unionFind.union(element1: 5, element2: 1)
        
        // print(unionFind.parents)
        // print(unionFind.sizes)

        // Sort from smallest to largest
        edges.sort { $0.weight < $1.weight }

        // While K > 4
        // var count = 0
        // for edge in edges {
        //     print(edge.weight)
        //     if count == 17 {
        //         break
        //     }
        //     count += 1
        // }
    } else {
        fatalError("Could not open file")
    }
}