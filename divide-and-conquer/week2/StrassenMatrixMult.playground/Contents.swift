import UIKit

var str = "Hello, playground"


func getSubmatrix(_ matrix: [[Int]], i0: Int, i1: Int, j0: Int, j1: Int) -> [[Int]] {
    var result = [[Int]]()
    
    for row in Array(matrix[i0...i1]) {
        result.append(Array(row[j0...j1]))
    }
    
    return result
}

func strassenMult(matrix1 X: [[Int]], matrix2 Y: [[Int]]) -> [[Int]] {
    let n = X.count
    
    if n == 1 {
        return [[X[0][0] * Y[0][0]]]
    } else {
        let A = getSubmatrix(X, i0: 0, i1: n/2-1, j0: 0, j1: n/2-1)
        let B = getSubmatrix(X, i0: 0, i1: n/2-1, j0: n/2, j1: n-1)
        let C = getSubmatrix(X, i0: n/2, i1: n-1, j0: 0, j1: n/2-1)
        let D = getSubmatrix(X, i0: n/2, i1: n-1, j0: n/2, j1: n-1)
        
        let E = getSubmatrix(Y, i0: 0, i1: n/2-1, j0: 0, j1: n/2-1)
        let F = getSubmatrix(Y, i0: 0, i1: n/2-1, j0: n/2, j1: n-1)
        let G = getSubmatrix(Y, i0: n/2, i1: n-1, j0: 0, j1: n/2-1)
        let H = getSubmatrix(Y, i0: n/2, i1: n-1, j0: n/2, j1: n-1)

        let P1 = strassenMult(matrix1: A, matrix2: matrixSubst(matrix1: F, matrix2: H))
        let P2 = strassenMult(matrix1: matrixSum(matrix1: A, matrix2: B), matrix2: H)
        let P3 = strassenMult(matrix1: matrixSum(matrix1: C, matrix2: D), matrix2: E)
        let P4 = strassenMult(matrix1: D, matrix2: matrixSubst(matrix1: G, matrix2: E))
        let P5 = strassenMult(matrix1: matrixSum(matrix1: A, matrix2: D), matrix2: matrixSum(matrix1: E, matrix2: H))
        let P6 = strassenMult(matrix1: matrixSubst(matrix1: B, matrix2: D), matrix2: matrixSum(matrix1: G, matrix2: H))
        let P7 = strassenMult(matrix1: matrixSubst(matrix1: A, matrix2: C), matrix2: matrixSum(matrix1: E, matrix2: F))
        
        let newA = matrixSum(matrix1: matrixSubst(matrix1: matrixSum(matrix1: P5, matrix2: P4), matrix2: P2), matrix2: P6)
        let newB = matrixSum(matrix1: P1, matrix2: P2)
        let newC = matrixSum(matrix1: P3, matrix2: P4)
        let newD = matrixSubst(matrix1: matrixSubst(matrix1:  matrixSum(matrix1: P1, matrix2: P5), matrix2: P3), matrix2: P7)
        
        let newN = newA.count
        var concatMat = Array(repeatElement(Array(repeatElement(0, count: newN*2)), count: newN*2))
        for i in 0..<newN {
            concatMat[i] = newA[i] + newB[i]
            concatMat[i+newN] = newC[i] + newD[i]
        }
        
        return concatMat

    }
    
}

func matrixSum(matrix1 X: [[Int]], matrix2 Y: [[Int]]) -> [[Int]] {
    let n = X.count
    var result = Array(repeatElement(Array(repeatElement(0, count: n)), count: n))
    for row in 0..<n {
        for column in 0..<n {
            result[row][column] = X[row][column] + Y[row][column]
        }
    }
    return result
}

func matrixSubst(matrix1 X: [[Int]], matrix2 Y: [[Int]]) -> [[Int]] {
    let n = X.count
    var result = Array(repeatElement(Array(repeatElement(0, count: n)), count: n))
    for row in 0..<n {
        for column in 0..<n {
            result[row][column] = X[row][column] - Y[row][column]
        }
    }
    return result
}
let matrix1: [[Int]] = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
let matrix2: [[Int]] = [[90, 100, 110, 120], [202, 228, 254, 280], [314, 356, 398, 440], [426, 484, 542, 600]]

let multStrass = strassenMult(matrix1: matrix1, matrix2: matrix2)

print("multStrass \(multStrass)")
