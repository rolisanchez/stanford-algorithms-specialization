import UIKit

var str = "Hello, playground"

func karatsubaMult(num1: Int, num2: Int) -> Int {
    let str1 = String(num1)
    let n = str1.count
    let a: Int = Int(String(str1.prefix((n/2))))!
    let b: Int = Int(String(str1.suffix((n/2))))!
    let str2 = String(num2)
    let c: Int = Int(String(str2.prefix((n/2))))!
    let d: Int = Int(String(str2.suffix((n/2))))!
    
    print("a = \(a)")
    print("b = \(b)")
    print("c = \(c)")
    print("d = \(d)")
    
    //1
    let ac = recursiveMultiply(num1: a, num2: c)
    //2
    let bd = recursiveMultiply(num1: b, num2: d)
    // 3
    let abcd = recursiveMultiply(num1: (a+b), num2: (c+d))
    
    let adbc = abcd - ac - bd
    
    return Int(pow(10, Double(n)))*ac + Int(pow(10, Double(n/2)))*adbc + bd
}

func recursiveMultiply(num1: Int, num2: Int) -> Int{
    // No need to do two comparisons here. num1 is always same size as num2
    if String(num1).count == 2 {
        return num1*num2
    } else {
        return karatsubaMult(num1: num1, num2: num2)
    }
}

let result = karatsubaMult(num1: 1234, num2: 1234)
print("result is \(result)")

//let input1challenge = 3141592653589793238462643383279502884197169399375105820974944592
//let input2challenge = 2718281828459045235360287471352662497757247093699959574966967627
