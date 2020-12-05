import Foundation

// Define the Graph
protocol Graph {
    associatedtype Element
    
    typealias Edge = GraphEdge<Element>
    typealias Vertex = Edge.Vertex
    
    var vertices: [Vertex] { get }
    
    @discardableResult mutating func addVertex(_: Element) -> Vertex
    func getEdges(from: Vertex) -> [Edge]
}

struct GraphVertex<Element> {
    let index: Int
    let element: Element
}

extension GraphVertex: Equatable where Element: Equatable { }
extension GraphVertex: Hashable where Element: Hashable { }

struct GraphEdge<Element> {
    typealias Vertex = GraphVertex<Element>
    
    let source: Vertex
    let destination: Vertex
    let weight: Double
}

extension GraphEdge: Equatable where Element: Equatable { }

// Adjacency List Graph Representation
struct AdjacencyList<Element: Hashable>: Graph {
    typealias Edge = GraphEdge<Element>
    typealias Vertex = Edge.Vertex
    
    private var adjacencies: [ Vertex: [Edge] ] = [:]
    
    var vertices: [Vertex] {
        return Array(adjacencies.keys)
    }
    
    @discardableResult mutating func addVertex(_ element: Element) -> Vertex {
        let vertex = Vertex(index: adjacencies.count, element: element)
        adjacencies[vertex] = []
        return vertex
    }
    
    mutating func add(_ edge: Edge) {
        adjacencies[edge.source]?.append(edge)
        
        let reversedEdge = Edge(
            source: edge.destination,
            destination: edge.source,
            weight: edge.weight
        )
        adjacencies[edge.destination]!.append(reversedEdge)
    }
    
    func getEdges(from source: Vertex) -> [Edge] {
        return adjacencies[source] ?? []
    }
}

extension AdjacencyList: CustomStringConvertible {
    var description: String {
        return
            adjacencies.mapValues { edges in
                edges
                    .sorted { $0.destination.index < $1.destination.index }
                    .map { "\($0.destination.element) (\($0.weight))" }
            }
            .sorted { $0.key.index < $1.key.index }
            .map {
                let source = "\($0.key.index): \($0.key.element)"
                
                guard !$0.value.isEmpty else {
                    return source
                }
                
                let sourceWithArrow = "\(source) -> "
                return """
                \(sourceWithArrow)\($0.value.joined(separator: "\n"
                + String(repeating: " ", count: sourceWithArrow.count)
                ))
                """
            }
            .joined(separator: "\n\n")
    }
}


// Heap Data Structure
struct Heap<Element: Equatable> {
    fileprivate var elements: [Element] = []
    let areSorted: (Element, Element) -> Bool
    
    init(_ elements: [Element], areSorted: @escaping (Element, Element) -> Bool) {
        self.areSorted = areSorted
        self.elements = elements
        
        guard !elements.isEmpty else {
            return
        }
        
        for index in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
            siftDown(from: index)
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    func getChildIndices(ofParentAt parentIndex: Int) -> (left: Int, right: Int) {
        let leftIndex = (2 * parentIndex) + 1
        return (leftIndex, leftIndex + 1)
    }
    
    func getParentIndex(ofChildAt index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func getFirstIndex(of element: Element, startingAt startingIndex: Int = 0) -> Int? {
        guard elements.indices.contains(startingIndex) else {
            return nil
        }
        if areSorted(element, elements[startingIndex]) {
            return nil
        }
        if element == elements[startingIndex] {
            return startingIndex
        }
        
        let childIndices = getChildIndices(ofParentAt: startingIndex)
        return getFirstIndex(of: element, startingAt: childIndices.left)
            ?? getFirstIndex(of: element, startingAt: childIndices.right)
    }
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }
    
    mutating func removeRoot() -> Element? {
        guard !isEmpty else {
            return nil
        }
        
        elements.swapAt(0, count - 1)
        let originalRoot = elements.removeLast()
        siftDown(from: 0)
        return originalRoot
    }
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil
        }
        
        if index == elements.count - 1 {
            return elements.removeLast()
        }
        else {
            elements.swapAt(index, elements.count - 1)
            defer {
                siftDown(from: index)
                siftUp(from: index)
            }
            return elements.removeLast()
        }
    }
    
    mutating func siftDown(from index: Int, upTo count: Int? = nil) {
        let count = count ?? self.count
        var parentIndex = index
        while true {
            let (leftIndex, rightIndex) = getChildIndices(ofParentAt: parentIndex)
            var optionalParentSwapIndex: Int?
            if leftIndex < count
                && areSorted(elements[leftIndex], elements[parentIndex])
            {
                optionalParentSwapIndex = leftIndex
            }
            if rightIndex < count
                && areSorted(elements[rightIndex], elements[optionalParentSwapIndex ?? parentIndex])
            {
                optionalParentSwapIndex = rightIndex
            }
            guard let parentSwapIndex = optionalParentSwapIndex else {
                return
            }
            elements.swapAt(parentIndex, parentSwapIndex)
            parentIndex = parentSwapIndex
        }
    }
    
    mutating func siftUp(from index: Int) {
        var childIndex = index
        var parentIndex = getParentIndex(ofChildAt: childIndex)
        while childIndex > 0 && areSorted(elements[childIndex], elements[parentIndex]) {
            elements.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = getParentIndex(ofChildAt: childIndex)
        }
    }
}

let filepath = "./edges.txt"
// let filepath = "./testedges.txt"
// 6807-8874-1055+4414+1728-2237-7507+7990 = 1265

private typealias GraphA = AdjacencyList<Int>
private typealias Vertex = GraphA.Vertex

var graph = AdjacencyList<Int>()

struct VertexKeyWinner<Element>: Equatable where Element: Equatable {
    typealias Edge = GraphEdge<Element>

    let vertex: Edge.Vertex
    let key: Double
    let edge: Edge?

}

do {
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        let verticesEdges = lines[0].components(separatedBy: " ")
        
        let verticesCount = Int(verticesEdges[0])!
        var vertices: [Int:Vertex] = [:]
        for i in 0..<verticesCount {
            vertices[i+1] = graph.addVertex(i+1)
        }
        lines = Array(lines[1..<lines.count])

        print("Starting Prim...")
        for line in lines {
            guard !line.isEmpty else { continue }
            let lineComponents = line.components(separatedBy: " ")
            let sourceInt = Int(lineComponents[0])!
            let sourceVert = vertices[sourceInt]!
            let destInt = Int(lineComponents[1])!
            let destVert = vertices[destInt]!
            let weight = Double(lineComponents[2])!

            let graphEdge = GraphEdge(source: sourceVert, destination: destVert, weight: weight)
            graph.add(graphEdge)
            // break
        }
        // print(graph)
        
        var minHeap = Heap<VertexKeyWinner<Int>>([], areSorted: { (el1, el2) in
            return el1.key < el2.key
        })

        let startVertex = vertices[1]!
        
        for vertex in graph.vertices {
            if vertex == startVertex {
                continue
            }
            let thisVertEdges = graph.getEdges(from: vertex)

            var keyWeight = Double(Int.max)
            var winnerEdge: GraphEdge<Int>? = nil
            for vertEdge in thisVertEdges {
                if vertEdge.destination == startVertex {
                    keyWeight = vertEdge.weight
                    winnerEdge = vertEdge
                } 
            }
            // Add to heap
            minHeap.insert(VertexKeyWinner(vertex: vertex, key: keyWeight, edge: winnerEdge))
        }
        
        print("minHeap.count: ", minHeap.count)
        // print(minHeap)
        var X: [Vertex] = [startVertex]
        var T = [GraphEdge<Int>]()
        var Tcost: Double = 0

        while minHeap.peek() != nil {
            // Extract min
            guard let root = minHeap.removeRoot() else {
                continue
            }
            // Add w* into X
            let wStar = root.vertex
            X.append(wStar)
            // Add winner(w*) to T
            T.append(root.edge!)
            // Update the cost now so we don't do it later
            Tcost += root.key

            // Update Keys to maintain Invariant
            let rootVertEdges = graph.getEdges(from: wStar)
            
            for vertEdge in rootVertEdges {
                if !X.contains(vertEdge.destination) {
                    
                    let keyWeight = vertEdge.weight
                    let winnerEdge = vertEdge

                    for elHeap in minHeap.elements {
                        if elHeap.vertex == vertEdge.destination && keyWeight < elHeap.key {
                            let removeIndex = minHeap.getFirstIndex(of: elHeap)!
                            _ = minHeap.remove(at: removeIndex)
                            minHeap.insert(VertexKeyWinner(vertex: elHeap.vertex, key: keyWeight, edge: winnerEdge))
                        }
                    }
                }
            }
        }
        print("minHeap.count: ", minHeap.count)
        
        print("Result of Prim...")

        print("X Count: ", X.count)
        print("T Count: ", T.count)
        print("Tcost: ", Tcost)
    } else {
        fatalError("Could not open file")
    }
}