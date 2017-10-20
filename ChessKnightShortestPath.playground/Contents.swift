//
//  ChessKnightShortestPath.playground
//
//  Created by Ivan Kalaica on 20/10/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

// all 8 possible movements for a knight
fileprivate let knightMoves = [
    [ 2, -1],
    [ 2,  1],
    [-2,  1],
    [-2, -1],
    [ 1,  2],
    [ 1, -2],
    [-1,  2],
    [-1, -2]
]

struct Node {
    let y: Int, x: Int // (x, y) represents chessboard coordinates
    let dist: Int // dist represent its minimum distance from the source
    
    init(x: Int, y: Int, dist: Int = 0) {
        self.x = x
        self.y = y
        self.dist = dist
    }
}

extension Node: Hashable {
    // Using Node struct as a key we need conform to Hashable
    var hashValue: Int {
        return "\(self.x)\(self.y)".hashValue
    }
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

enum BfsError: Error {
    case shortestPathNotFound
}

// Find minimum number of steps taken by the knight
// from source to destination using BFS
func bfs(src: Node, dest: Node) throws -> Int {
    // map to check if matrix cell is visited before or not
    var visited = [Node: Bool]()
    
    // Create a queue and enqueue first node
    // Queue node used in BFS
    var q = Queue(array: [Node]())
    q.enqueue(src)
    
    // Run until queue is empty
    while (!q.isEmpty) {
        
        // Pop front node and process it
        guard let node = q.dequeue() else { break }
        
        let x = node.x
        let y = node.y
        let dist = node.dist
        
        // If destination is reached, return distance
        if (x == dest.x && y == dest.y) { return dist }
        
        // Skip if location is visited
        if visited[node] == nil {
            visited[node] = true
            
            // Check for all 8 possible movements for a knight
            // and enqueue each valid movement
            for i in 0..<knightMoves.count {
                
                // Get the new valid position of Knight from current
                // position on chessboard and enqueue it in the
                // queue with +1 distance
                let position = knightMoves[i]
                let x1 = x + position[0]
                let y1 = y + position[1]
                
                if (isValid(x: x1, y: y1)) {
                    q.enqueue(Node(x: x1, y: y1, dist: dist + 1))
                }
            }
        }
    }
    throw BfsError.shortestPathNotFound
}

// Check if (x, y) is valid chessboard cordinate
// Note that a knight cannot go out of the chessboard
fileprivate func isValid(x: Int, y: Int) -> Bool {
    guard (x >= 0 && y >= 0 && x < knightMoves.count && y < knightMoves.count) else { return false }
    return true
}

fileprivate struct Queue<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    public var count: Int {
        return self.array.count
    }
    
    public mutating func enqueue(_ element: T) {
        self.array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if self.isEmpty {
            return nil
        } else {
            return self.array.removeFirst()
        }
    }
    
    public var front: T? {
        return self.array.first
    }
}

if let a = try? bfs(src: Node(x: 0, y: 0), dest: Node(x: 7, y: 0)) {
    print("Minimum number of steps required is \(a).")
}
