import Foundation

func kargersMinCut(graphIn: [String:[String]]) -> Int? {
    var graph = graphIn
    
    while graph.count > 2 {
        // Pick a random Edge
        guard let randomVertex = graph.randomElement() else {
            return nil
        }

        let vertexValue = randomVertex.key
        let vertexEdges = randomVertex.value

        guard let randomEdge = vertexEdges.randomElement() else {
            return nil
        }
        guard let reverseEdges = graph[randomEdge] else {
            return nil
        }
        
        // Contract on chosen edge
        let newElement = vertexValue + randomEdge
        var newElementEdges = [String]()
        
        //    print("newElement = \(newElement)")
        
        for edge in vertexEdges {
            if edge != randomEdge {
                newElementEdges.append(edge)
                graph[edge]?.removeAll(where: { $0 == vertexValue})
                graph[edge]?.append(newElement)
            }
        }
        
        for edge in reverseEdges {
            if edge != vertexValue {
                newElementEdges.append(edge)
                graph[edge]?.removeAll(where: { $0 == randomEdge})
                graph[edge]?.append(newElement)
            }
        }
        
        //    print("newElementEdges = \(newElementEdges)")
        
        graph[newElement] = newElementEdges
        // Remove original edges
        graph.removeValue(forKey: vertexValue)
        graph.removeValue(forKey: randomEdge)
        
        //    print(graph)
    }
    
//    print(graph)
    
    return (graph.randomElement()?.value.count)!
}



let filepath = "./kargerMinCut.txt"
do {
    if let contents = try? String(contentsOfFile: filepath) {
        let stringArray = contents.components(separatedBy: " ;")
            
            var graph = [String:[String]]()
            for line in stringArray {
                let lineComponents = line.components(separatedBy: ": ")
                let vertex = lineComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
                if vertex != "" {
                    graph[vertex] = lineComponents[1].components(separatedBy: " ")
                }
            }
//            print("graph = \(graph)")
            // let minCut = kargersMinCut(graphIn: graph)
            // print("Min cut = \(minCut)")

            var cutsArray = [Int]()
            for _ in 0..<100 {
                if let minCut = kargersMinCut(graphIn: graph) {
                    cutsArray.append(minCut)
                }
            }
            print("cutsArray  = \(cutsArray)")
            print("cutsArray  min = \(cutsArray.min()!)")
    } else {
        print("Could not get contents")
    }
}

// Min 17