import UIKit

var str = "Hello, playground"

func karatsubaMult(num1: Int, num2: Int) -> Int {
    let str1 = String(num1)
    let n = str1.count
    let a: Int = Int(String(str1.prefix(n/2)))!
    let b: Int = Int(String(str1.suffix(n/2)))!
    let str2 = String(num2)
    let c: Int = Int(String(str2.prefix(n/2)))!
    let d: Int = Int(String(str2.suffix(n/2)))!
    
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
    print("ac \(ac)")
    print("adbc \(adbc)")
    print("bd \(bd)")
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

//let result = karatsubaMult(num1: 1234, num2: 5678)
//print("result is \(result)")

// print("max int \(Int64.max)") // = 9223372036854775807
//let input1challenge = 3141592653589793238462643383279502884197169399375105820974944592
//let input2challenge = 2718281828459045235360287471352662497757247093699959574966967627

// Tried to implement with Strings for longer numbers > 9223372036854775807
// Problem will still be with recursive multiplication and with the sum at the end
// Maybe do some string sum with carry




func karatsubaMultStr(str1: String, str2: String) -> String {
    let n = str1.count
    let a = String(str1.prefix(n/2))
    let b = String(str1.suffix(n/2))
    let c = String(str2.prefix(n/2))
    let d = String(str2.suffix(n/2))
        
    //1
    let ac = recursiveMultiplyStr(str1: a, str2: c)
    //2
    let bd = recursiveMultiplyStr(str1: b, str2: d)
    // 3
    let abcd = recursiveMultiplyStr(str1: sumString(str1: a, str2: b), str2: sumString(str1: c, str2: d))

    let adbc = substractString(str1in: substractString(str1in: abcd, str2in: ac), str2in: bd)
    
    let ac10 = ac+repeatElement("0", count: n)
    let adbc10 = adbc+repeatElement("0", count: n/2)
    return sumString(str1: sumString(str1: ac10, str2: adbc10), str2: bd)
}

func recursiveMultiplyStr(str1: String, str2: String) -> String {
    // No need to do two comparisons here. num1 is always same size as num2
    if str1.count == 2 {
        return String(Int(str1)!*Int(str2)!)
    } else {
        return karatsubaMultStr(str1: str1, str2: str2)
    }
}

func sumString(str1: String, str2: String) -> String {
    var str1 = str1
    var str2 = str2
    
    // Setup strings so both have same number of characters
    if str1.count > str2.count {
        str2 = repeatElement("0", count: str1.count - str2.count) + str2
    } else if str2.count > str1.count {
        str1 = repeatElement("0", count: str2.count - str1.count) + str1
    }
    
    var result = ""
    var carry: Int = 0
    // Sum from right to left
    for i in (0..<str1.count).reversed() {
        let index = str1.index(str1.startIndex, offsetBy: i)
        let char1 = str1[index]
        let char2 = str2[index]
        
        
        let sum = Int(String(char1))!+Int(String(char2))! + carry
        
        if String(sum).count > 1 {
            carry = Int(String(String(sum).prefix(String(sum).count-1)))!
            result = String(String(sum).suffix(1)) + result
        } else {
            carry = 0
            result = String(sum) + result
        }
    }

    if carry != 0 {
        result = String(carry) + result
    }
    
    return result
}

func substractString(str1in: String, str2in: String) -> String {
    var str1 = str1in
    var str2 = str2in
    
    var sign = ""
    
    if Int(str2)! > Int(str1)! {
        str1 = str2in
        str2 = str1in
        sign = "-"
    }

    // Setup strings so both have same number of characters
    if str1.count > str2.count {
        str2 = repeatElement("0", count: str1.count - str2.count) + str2
    } else if str2.count > str1.count {
        str1 = repeatElement("0", count: str2.count - str1.count) + str1
    }
    
    var result = ""
    var borrow: Int = 0
    
    // Sum from right to left
    for i in (0..<str1.count).reversed() {
        let index = str1.index(str1.startIndex, offsetBy: i)
        let char1 = str1[index]
        let char2 = str2[index]
        
        var intChar1 = Int(String(char1))!
        let intChar2 = Int(String(char2))!
        var newBorrow = 0
        
        if intChar2 > intChar1 {
            intChar1 += 10
            newBorrow = -1
        }
        
        let subst = intChar1 - intChar2 + borrow
        
        result = String(subst) + result
        
        borrow = newBorrow
       
    }

    if borrow != 0 {
        result = String(borrow) + result
    }
    
    result = sign + result
    return result
}

//let sum = sumString(str1: "823", str2: "818")
//print("sum = \(sum)")

//let subst = substractString(str1in: "1189", str2in: "1234")
//print("subst = \(subst)")

//let sum2 = sumString(str1: "3141592653589793238462643383279502884197169399375105820974944592", str2: "2718281828459045235360287471352662497757247093699959574966967627")
//print("sum2 = \(sum2)")

//let input1challenge = "3141592653589793238462643383279502884197169399375105820974944592"
//let input2challenge = "2718281828459045235360287471352662497757247093699959574966967627"
// result = "8539734222673567065463550869546574495034888535765114961879601127067743044893204848617875072216249073013374895871952806582723184"
//let result2 = karatsubaMultStr(str1: "1234", str2: "5678")
//print("result2 is \(result2)")


//let input1challenge = "3141"
//let input2challenge = "2718"
//
//let resultChallenge = karatsubaMultStr(str1: input1challenge, str2: input2challenge)
//print("resultChallenge is \(resultChallenge)")


func stringMultiplication(str1: String, str2: String) -> String {
    
    var colums = [String]()
    
    
    for i in (0..<str2.count).reversed() {
        var carry = 0
        var resultCol = ""
        let indexStr2 = str2.index(str2.startIndex, offsetBy: i)
        let char2 = str2[indexStr2]
        for j in (0..<str1.count).reversed() {
            let indexStr1 = str1.index(str1.startIndex, offsetBy: j)
            let char1 = str1[indexStr1]
            
            let mult = Int(String(char1))!*Int(String(char2))! + carry
            
            if String(mult).count > 1 {
                carry = Int(String(String(mult).prefix(String(mult).count-1)))!
                resultCol = String(String(mult).suffix(1)) + resultCol
            } else {
                carry = 0
                resultCol = String(mult) + resultCol
            }
        }
        if carry > 0 {
            resultCol = String(carry) + resultCol
        }
        resultCol += repeatElement("0", count: colums.count)
        colums.append(resultCol)
    }

    let sum = colums.reduce("", sumString)
    return sum
}

//print("stringMultiplication \(stringMultiplication(str1: "722", str2: "722"))")

let input1challenge = "3141592653589793238462643383279502884197169399375105820974944592"
let input2challenge = "2718281828459045235360287471352662497757247093699959574966967627"
let resultChallenge = stringMultiplication(str1: input1challenge, str2: input2challenge)
print("resultChallenge is \(resultChallenge)")
