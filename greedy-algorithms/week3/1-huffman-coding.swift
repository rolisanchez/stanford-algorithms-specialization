import Foundation

let filepath = "./huffman.txt"
// let filepath = "./test_huffman.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n").map{Int($0)!}
        lines = Array(lines[1..<lines.count])
        
        // Get our alphabet with weights for lines
        var alphabet = [Symbol]()

        var forest = [BinaryNode]()
        (lines.enumerated()).forEach { (id, weight) in
            let symbol = Symbol(value: id, weight: weight)
            alphabet.append(symbol)
            let binaryNode = BinaryNode(totalWeight: weight)
            binaryNode.symbol = symbol
            forest.append(binaryNode)
        }
        // Sort alphabet for performance. O(n*log(n))
        // alphabet.sort{$0.weight < $1.weight }
        forest.sort{$0.totalWeight < $1.totalWeight }
        
        // Build a tree. 
        while forest.count > 1 {
            // print(forest)
            let left = forest.removeFirst()
            let right = forest.removeFirst()
            let binaryNode = BinaryNode(totalWeight: left.totalWeight + right.totalWeight)
            binaryNode.leftChild = left
            binaryNode.rightChild = right
            forest.append(binaryNode)
            forest.sort{$0.totalWeight < $1.totalWeight }
        }

        let rootNode = forest[0]
        rootNode.traverse(carryRepresentation: "")

        // Print tree
        // print(rootNode)

        // Print code table
        // alphabet.forEach { (symbol) in
        //     print("ID: ", symbol.value, "| Code: ", symbol.representation)
        // }
        
        alphabet.sort { $0.representation.count <  $1.representation.count }
        
        print("Min: ", alphabet.first!.representation.count)
        print("Max: ", alphabet.last!.representation.count)

        
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else {
        fatalError("Could not open file")
    }
}

class Symbol {
    let value: Int
    let weight: Int
    var representation: String = ""

    init (value: Int, weight: Int) {
        self.value = value
        self.weight = weight
    }
}

class BinaryNode {
    var totalWeight: Int
    var symbol: Symbol?
    var leftChild: BinaryNode?
    var rightChild: BinaryNode?
    
    init(totalWeight: Int){
        self.totalWeight = totalWeight
    }
}

extension BinaryNode: CustomStringConvertible {
  //Note: This algorithm is based on an implementation by Károly Lőrentey in his book Optimizing Collections, available from https://www.objc.io/books/optimizing-collections/.

    public var description: String {
        return diagram(for: self)
    }

    private func diagram(for node: BinaryNode?,
        _ top: String = "",
        _ root: String = "",
        _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.totalWeight) (\(node.symbol!.representation))\n"
        }
        return diagram(for: node.rightChild,
                        top + " ", top + "┌──", top + "│ ")
            + root + "\(node.totalWeight)\n"
            + diagram(for: node.leftChild,
                    bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

extension BinaryNode {
    func traverse(carryRepresentation: String) {
        leftChild?.traverse(carryRepresentation: carryRepresentation+"0")
        rightChild?.traverse(carryRepresentation: carryRepresentation+"1")
        if let symbol = self.symbol {
            symbol.representation = carryRepresentation
        }
    }

    // func traverseInOrder(visit: (Element) -> Void) {
    //     leftChild?.traverseInOrder(visit: visit)
    //     visit(value)
    //     rightChild?.traverseInOrder(visit: visit)
    // }
    
    // func traversePreOrder(visit: (Element) -> Void) {
    //     visit(value)
    //     leftChild?.traversePreOrder(visit: visit)
    //     rightChild?.traversePreOrder(visit: visit)
    // }
    
    // func traversePostOrder(visit: (Element) -> Void) {
    //     leftChild?.traversePostOrder(visit: visit)
    //     rightChild?.traversePostOrder(visit: visit)
    //     visit(value)
    // }
    
    // func traversePreOrderOptional(visit: (Element?) -> Void) {
    //     visit(value)
    //     leftChild != nil ? leftChild?.traversePreOrderOptional(visit: visit) : visit(nil)
    //     rightChild != nil ? rightChild?.traversePreOrderOptional(visit: visit) : visit(nil)
    // }
}