import UIKit

func kargersMinCut(graphIn: [String:[String]]) -> Int {
    var graph = graphIn
    
    while graph.count > 2 {
        // Pick a random Edge
        let randomVertex = graph.randomElement()!
        let vertexValue = randomVertex.key
        let vertexEdges = randomVertex.value
        let randomEdge = vertexEdges.randomElement()!
        let reverseEdges = graph[randomEdge]!
        
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

//var graph = [String:[String]]()
//graph["1"] = ["2", "3"]
//graph["2"] = ["1", "3", "4"]
//graph["3"] = ["1", "2", "4"]
//graph["4"] = ["2", "3"]
//
//print(graph)
//
//let minCut = kargersMinCut(graphIn: graph)
//
//print("Min cut = \(minCut)")


//if let filepath = Bundle.main.path(forResource: "smallGraph", ofType: "txt") {
if let filepath = Bundle.main.path(forResource: "kargerMinCut", ofType: "txt") {
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
            let minCut = kargersMinCut(graphIn: graph)
            print("Min cut = \(minCut)")
            
        } else {
            print("Could not get contents")
        }
    }
    
} else {
    print("Error loading String")
}
