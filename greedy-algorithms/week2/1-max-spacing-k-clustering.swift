import Foundation

struct Edge: Equatable {
    let identifier: Int
    let source: Int
    let destination: Int
    let weight: Int

    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.identifier == rhs.identifier
    }
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

var edges = [Edge]()

let DESIRED_CLUSTERS = 4

let filepath = "./clustering1.txt"

let MAX_ELEMENTS = 500
var clustersCount = MAX_ELEMENTS

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        lines = Array(lines[1..<lines.count])

        let unionFind = UnionFind()
        // 0 should never be accessed
        unionFind.parents.append(Int.min)
        unionFind.sizes.append(Int.min)

        for i in 1...MAX_ELEMENTS {
            // Each one is their own parent
            unionFind.parents.append(i)
            unionFind.sizes.append(1)
        }

        var id_counter = 0
        // var edgesSet = Set<Int>()
        lines.forEach { line in 
            let edgesWeights = line.components(separatedBy: " ")
            let edge = Edge(identifier: id_counter, source: Int(edgesWeights[0])!, destination: Int(edgesWeights[1])!, weight: Int(edgesWeights[2])!)
            edges.append(edge)
            id_counter += 1
        }

        print("Edges count: ", edges.count)

        // Sort from smallest to largest
        edges.sort { $0.weight < $1.weight }

        print("clustersCount: ", clustersCount)
        // While K > 4
        while clustersCount > DESIRED_CLUSTERS {
            // Kruskal's Greedy to find Edge with min weight (Only explored unused edges)
            for edge in edges {
                // If source and destination vertex/node are in different clusters (use Union-Find Data Structure to see if parents are the same), 
                // then merge their clusters
                if unionFind.find(element: edge.source) != unionFind.find(element: edge.destination) {
                    // Merge the clusters: elementToCluster should point to the same Cluster
                    // Instead of clusters = [Cluster]() we can just keep a count starting at 500 and do -1 each time it's merged
                    if clustersCount == DESIRED_CLUSTERS {
                        print("Maximum spacing: ", edge.weight)
                        break
                    }
                    clustersCount -= 1
                    // Merge: Union on Union Find Data Structure
                    unionFind.union(element1: edge.source, element2: edge.destination)
                    if let index = edges.firstIndex(of: edge) {
                        edges.remove(at: index)
                        // usedEdges.append(edge)
                    }
                }
            }
        }

        // After having only 4 clusters, check the unused Edges
        print("clustersCount: ", clustersCount)
        print("edges count: ", edges.count)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else {
        fatalError("Could not open file")
    }
}