import UIKit
import Foundation

let n: Double = 50

//let a = pow(2, log(n))
//let b = pow(2, pow(2, log(n)))
//let c = pow(n, 5/2)
//let d = pow(2, pow(n, 2))
//let e = pow(n, 2) * log(n)

let a = pow(n, 2) * log(n)
let b = pow(2, n)
let c = pow(2, pow(2, n))
let d = pow(n, log(n))
let e = pow(n, 2)

[a,b,c,d,e].sorted()
// abecd
