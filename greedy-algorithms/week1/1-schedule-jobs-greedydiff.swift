import Foundation

let filepath = "./jobs.txt"

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

do {
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        
        lines = Array(lines[1..<lines.count])
        
        var minHeap = Heap<[String:Int]>([], areSorted: { (el1, el2) in
            //  If two jobs have equal difference (weight - length), 
            // you should schedule the job with higher weight first
            let el1Weight = el1["weight"]!
            let el1Length = el1["length"]!
            let el1Diff = el1Weight - el1Length

            let el2Weight = el2["weight"]!
            let el2Length = el2["length"]!
            let el2Diff = el2Weight - el2Length

            if el1Diff == el2Diff {
                return el1Weight > el2Weight
            } else {
                return el1Diff > el2Diff
            }
        })

        for line in lines {
            guard !line.isEmpty else { continue }
            // [job_1_weight] [job_1_length]
            let lineContents = line.components(separatedBy: " ")
            let jobWeight = Int(lineContents[0])!
            let jobLength = Int(lineContents[1])!

            var job = [String:Int]()
            job["weight"] = jobWeight
            job["length"] = jobLength

            minHeap.insert(job)
        }

        var sumWeightedCompletionTimes = 0
        var currentTime = 0
        while minHeap.peek() != nil {
            guard let root = minHeap.removeRoot() else {
                continue
            }
            guard let rootWeight = root["weight"] else {
                continue
            }
            guard let rootLength = root["length"] else {
                continue
            }

            currentTime += rootLength
            let weightedCompletion = rootWeight * currentTime
            sumWeightedCompletionTimes += weightedCompletion
        }
        // You should report the sum of weighted completion times of the resulting schedule
        print("sumWeightedCompletionTimes: ", sumWeightedCompletionTimes)

    } else {
        fatalError("Could not open file")
    }
}