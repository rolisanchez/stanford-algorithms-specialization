import UIKit

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

extension Array where Element: Equatable {
    init(_ heap: Heap<Element>) {
        var heap = heap
        for index in heap.elements.indices.reversed() {
            heap.elements.swapAt(0, index)
            heap.siftDown(from: 0, upTo: index)
        }
        self = heap.elements
    }
    
    func isHeap(sortedBy areSorted: @escaping (Element, Element) -> Bool) -> Bool {
        if isEmpty {
            return true
        }
        
        for parentIndex in stride(from: count / 2 - 1, through: 0, by: -1) {
            let parent = self[parentIndex]
            let leftChildIndex = 2 * parentIndex + 1
            if areSorted(self[leftChildIndex], parent) {
                return false
            }
            let rightChildIndex = leftChildIndex + 1
            if rightChildIndex < count && areSorted(self[rightChildIndex], parent) {
                return false
            }
        }
        return true
    }
}

// Queue Data Structure
protocol Queue: Sequence, IteratorProtocol {
    associatedtype Element
    var isEmpty: Bool { get }
    var peek: Element? { get }
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
}

extension Queue {
    mutating func next() -> Element? {
        return dequeue()
    }
}

// Priority Queue Abstract Data Type
struct PriorityQueue<Element: Equatable>: Queue {
    private var heap: Heap<Element>
    
    init(_ elements: [Element] = [], areSorted: @escaping (Element, Element) -> Bool) {
        heap = Heap(elements, areSorted: areSorted)
    }
    
    var isEmpty: Bool {
        return heap.isEmpty
    }
    
    var peek: Element? {
        return heap.peek()
    }
    
    mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }
    
    mutating func dequeue() -> Element? {
        return heap.removeRoot()
    }
}

// Define Dijsktra Methods
enum Dijsktra<GraphD: Graph> where GraphD.Element: Hashable {
    typealias Edge = GraphD.Edge
    typealias Vertex = GraphD.Vertex
    
    static func getEdges(alongPathsFrom source: Vertex, graph: GraphD) -> [Vertex: Edge] {
        var edges: [Vertex: Edge] = [:]
        
        func getWeight(to destination: Vertex) -> Double {
            return getShortestPath(to: destination, edgesAlongPaths: edges)
                .map { $0.weight }
                .reduce(0, +)
        }
        
        var priorityQueue = PriorityQueue { getWeight(to: $0) < getWeight(to: $1)}
        priorityQueue.enqueue(source)
        
        while let vertex = priorityQueue.dequeue(){
            graph.getEdges(from: vertex)
                .filter {
                    $0.destination == source
                        ? false
                        : edges[$0.destination] == nil
                        || getWeight(to: vertex) + $0.weight < getWeight(to: $0.destination)
            }
            .forEach { newEdgeFromVertex in
                edges[newEdgeFromVertex.destination] = newEdgeFromVertex
                priorityQueue.enqueue(newEdgeFromVertex.destination)
            }
        }
        return edges
    }
    
    static func getShortestPath(to destination: Vertex, edgesAlongPaths: [Vertex: Edge]) -> [Edge] {
        var shortestPath: [Edge] = []
        var destination = destination
        while let edge = edgesAlongPaths[destination] {
            shortestPath = [edge] + shortestPath
            destination = edge.source
        }
        return shortestPath
    }
    
    static func getShortestPath(from source: Vertex, to destination: Vertex, graph: GraphD) -> [Edge] {
        return getShortestPath(to: destination, edgesAlongPaths: getEdges(alongPathsFrom: source, graph: graph))
    }
    
    static func getShortestPaths(from source: Vertex, graph: GraphD) -> [Vertex: [Edge]]{
        let edges = getEdges(alongPathsFrom: source, graph: graph)
        let paths = graph.vertices.map { getShortestPath(to: $0, edgesAlongPaths: edges) }
        return Dictionary(uniqueKeysWithValues: zip(graph.vertices, paths))
    }
}

// Test case
private typealias GraphA = AdjacencyList<Int>
private typealias Vertex = GraphA.Vertex

//private extension String {
//    init?(shortestPath: [GraphA.Edge]){
//        guard !shortestPath.isEmpty else {
//            return nil
//        }
//
//        self = shortestPath.reduce(into: shortestPath[0].source.element) { string, edge in
//            string += edge.destination.element
//        }
//    }
//}

//private let (graph, a, b, c, d, e, f, g, h): (GraphA, Vertex, Vertex, Vertex, Vertex, Vertex, Vertex, Vertex, Vertex) = {
//    var graph = AdjacencyList<String>()
//
//    let a = graph.addVertex("A")
//    let b = graph.addVertex("B")
//    let c = graph.addVertex("C")
//    let d = graph.addVertex("D")
//    let e = graph.addVertex("E")
//    let f = graph.addVertex("F")
//    let g = graph.addVertex("G")
//    let h = graph.addVertex("H")
//
//    for edge in [
//        GraphEdge(source: a, destination: b, weight: 8),
//        GraphEdge(source: a, destination: f, weight: 9),
//        GraphEdge(source: a, destination: g, weight: 1),
//        GraphEdge(source: b, destination: f, weight: 3),
//        GraphEdge(source: b, destination: e, weight: 1),
//        GraphEdge(source: c, destination: b, weight: 3),
//        GraphEdge(source: c, destination: e, weight: 1),
//        GraphEdge(source: c, destination: g, weight: 3),
//        GraphEdge(source: d, destination: e, weight: 2),
//        GraphEdge(source: f, destination: h, weight: 2),
//        GraphEdge(source: g, destination: h, weight: 5)
//        ] {
//            graph.add(edge)
//    }
//
//    return (graph, a, b, c, d, e, f, g, h)
//} ()
//
//let shortestPath = Dijsktra.getShortestPath(from: a, to: d, graph: graph)
//
//fileprivate let shortestPaths = [
//    a: nil,
//    b: "AGCEB",
//    c: "AGC",
//    d: "AGCED",
//    e: "AGCE",
//    f: "AGHF",
//    g: "AG",
//    h: "AGH"
//]
//
//let shortest = Dijsktra.getShortestPaths(from: a, graph: graph).mapValues( String.init(shortestPath:))
//
//print("shortest = ", shortest)
//
//var str = "Hello, playground"

var graph = AdjacencyList<Int>()

if let filepath = Bundle.main.path(forResource: "dijkstraData", ofType: "txt") {
    do {
        if let contents = try? String(contentsOfFile: filepath) {
            let lines = contents.components(separatedBy: "\n")
            var vertices: [Int:Vertex] = [:]
            for i in 1..<lines.count {
                vertices[i] = graph.addVertex(i)
            }
            for line in lines {
                guard !line.isEmpty else { continue }
                let lineComponents = line.components(separatedBy: " ")
                
                let edges = lineComponents[1..<lineComponents.count]
                let sourceNum = Int(lineComponents[0])!

                let sourceVert = vertices[sourceNum]
                for edge in edges {
                    let edgeComps = edge.components(separatedBy: ",")
                    let destNum = Int(edgeComps[0])!
                    let destVert = vertices[destNum]
                    let weight = Double(edgeComps[1])!
                    let edgeVert = GraphEdge(source: sourceVert!, destination: destVert!, weight: weight)
                    graph.add(edgeVert)
                }
            }
            // Now run Dijkstra shortest Path to:
            print("Now running Dijkstra")
            // 7,37,59,82,99,115,133,165,188,197
            let origin = vertices[1]
            // let destinations = [7,37,59,82,99,115,133,165,188,197]
            let destinations = [7]
            var shortestPaths = ""
            for dest in destinations {
                // print("Shortest path to = ", dest)
                let destVertex = vertices[dest]
                let shortestPath = Dijsktra.getShortestPath(from: origin!, to: destVertex!, graph: graph)
                // print("shortestPath count =", shortestPath.count)
                var totalWeight: Double = 0
                for edge in shortestPath {
                    // print("edge length = ", edge.weight)
                    totalWeight += edge.weight
                }
                shortestPaths += "\(Int(totalWeight)),"
            }
            print("shortestPaths = ", shortestPaths)
        }
    }
} else {
    fatalError("Can't read file")
}
