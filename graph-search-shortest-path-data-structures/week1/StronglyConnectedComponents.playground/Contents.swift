import UIKit

class Vertex: Equatable {
    var value: Int = 0
    var explored = false
    var exploredSecond = false
    
    var outgoing = [Int]()
    var incoming = [Int]()
    
    init(value: Int) {
        self.value = value
    }
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value
    }
}

class Graph {
    var vertices = [Int:Vertex]()
}

func reverse(graph: Graph) {
    graph.vertices.map {
        let incoming = $1.incoming
        $1.incoming = $1.outgoing
        $1.outgoing = incoming
    }
}

func topoSort(graph: Graph) -> [Int] {
    var currentLabel = graph.vertices.count
    
    var ordering = Array(repeating: 0, count: currentLabel)
        
    func DFSTopo(graph: Graph, vertex: Vertex){

        vertex.explored = true
        
        vertex.outgoing.map {
            guard let headVertex = graph.vertices[$0] else { fatalError()}
            if !headVertex.explored {
                DFSTopo(graph: graph, vertex: headVertex)
            }
        }
        
//        for head in vertex.outgoing {
//            guard let headVertex = graph.vertices[head] else { fatalError()}
//            if !headVertex.explored {
//                DFSTopo(graph: graph, vertex: headVertex)
//            }
//        }
        ordering[currentLabel-1] = vertex.value
        currentLabel -= 1
    }
    
    graph.vertices.map {
        if !$1.explored {
            DFSTopo(graph: graph, vertex: $1)
        }
    }
//    for (key, vertex) in graph.vertices {
//        if !vertex.explored {
//            DFSTopo(graph: graph, vertex: vertex)
//        }
//    }
    
//    print("ordering = \(ordering)")
    return ordering
}

struct SCC {
    var components = [Int]()
}

func computeSCC(graph: Graph) {
    reverse(graph: graph)
    let ordering = topoSort(graph: graph)
    reverse(graph: graph)
    
    var SCCs = [SCC]()
    var numSCC = -1
    
    func DFSSCC(graph: Graph, vertex: Vertex) {
        vertex.exploredSecond = true
        SCCs[numSCC].components.append(vertex.value)
        
        vertex.outgoing.map {
            guard let headVertex = graph.vertices[$0] else { fatalError()}
            if !headVertex.exploredSecond {
                DFSSCC(graph: graph, vertex: headVertex)
            }
        }
        
//        for head in vertex.outgoing {
//            guard let headVertex = graph.vertices[head] else { fatalError()}
//            if !headVertex.exploredSecond {
//                DFSSCC(graph: graph, vertex: headVertex)
//            }
//        }
    }
    
    ordering.map { vertexValue in
        guard let vertex = graph.vertices[vertexValue] else { fatalError()}
        if !vertex.exploredSecond {
            SCCs.append(SCC())
            numSCC += 1
            DFSSCC(graph: graph, vertex: vertex)
        }
    }
    
//    for vertexValue in ordering {
//        guard let vertex = graph.vertices[vertexValue] else { fatalError()}
//        if !vertex.exploredSecond {
//            SCCs.append(SCC())
//            numSCC += 1
//            DFSSCC(graph: graph, vertex: vertex)
//        }
//    }
    
    let sortedSCCs = SCCs.sorted(by: { $0.components.count > $1.components.count })
    for (index, SCC) in sortedSCCs[0..<4].enumerated() {
        print("SCC number \(index) components = \(SCC.components)")
    }

}

if let filepath = Bundle.main.path(forResource: "SCCSmall", ofType: "txt") {
    do {
        if let contents = try? String(contentsOfFile: filepath) {
            let stringArray = contents.components(separatedBy: "\n")
            let graph = Graph()
            
            stringArray.map { line in
                let lineComponents = line.components(separatedBy: " ")
                let tail = Int(lineComponents[0])!
                let head = Int(lineComponents[1])!
                
                if let existingTail = graph.vertices[tail] {
                    existingTail.outgoing.append(head)
                } else {
                    let vertexTail = Vertex(value: tail)
                    vertexTail.outgoing.append(head)
                    graph.vertices[tail] = vertexTail
                }
                
                if let existingHead = graph.vertices[head] {
                    existingHead.incoming.append(tail)
                } else {
                    let vertexHead = Vertex(value: head)
                    vertexHead.incoming.append(tail)
                    graph.vertices[head] = vertexHead
                }
            }
            
//            for line in stringArray {
//                let lineComponents = line.components(separatedBy: " ")
//                let tail = Int(lineComponents[0])!
//                let head = Int(lineComponents[1])!
//                
//                
//                
//                if let existingTail = graph.vertices[tail] {
//                    existingTail.outgoing.append(head)
//                } else {
//                    let vertexTail = Vertex(value: tail)
//                    vertexTail.outgoing.append(head)
//                    graph.vertices[tail] = vertexTail
//                }
//                
//                if let existingHead = graph.vertices[head] {
//                    existingHead.incoming.append(tail)
//                } else {
//                    let vertexHead = Vertex(value: head)
//                    vertexHead.incoming.append(tail)
//                    graph.vertices[head] = vertexHead
//                }
//
//            }
            computeSCC(graph: graph)
        }
    }
} else {
    print("Error loading File")
}
