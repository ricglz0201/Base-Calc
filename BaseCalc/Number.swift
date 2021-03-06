//
//  Number.swift
//  BaseCalc
//
//  Created by Juan Lizarraga on 19/03/20.
//  Copyright © 2020 The Senate. All rights reserved.
//

import Foundation

enum NumberError: Error {
    case couldNotInit
}

enum Base: Int {
    case Base2 = 2; case Base3; case Base4; case Base5;
    case Base6; case Base7; case Base8; case Base9;
    case Base10; case Base11; case Base12; case Base13;
    case Base14; case Base15; case Base16;
}

class FloatingPoint: NSObject {
    var sign: String
    var exp: String
    var mantissa: String
    
    init(sign: String, exp: String, mantissa: String){
        self.sign = sign
        self.exp = exp
        self.mantissa = mantissa
    }
    
    override var description: String {
        return "\(sign) \(exp) \(mantissa)"
    }
}

infix operator ~| : AdditionPrecedence

class Number: NSObject {
    var value: Double
    var base: Base
    var hasFract: Bool

    init(number: String, base: Base) throws {
        self.base = base
        var num = number

        if num.last == "." {
            num = String(num.dropLast())
        }

        let digits = Array(num)
        let sign = digits[0] == "-" ? -1.0 : 1.0

        // Check if hasFract
        if let dotPos = digits.lastIndex(of: ".") {
            let wholeStr = String(digits[0..<dotPos])
            let fractStr = String(digits[(dotPos+1)...])

            // Calculate Fract Denominator
            guard let fractNum = Int(fractStr, radix: base.rawValue) else { throw NumberError.couldNotInit }
            let fractDiv = "1" + String(repeating: "0", count: fractStr.count)
            guard let fractDen = Int(fractDiv, radix: base.rawValue) else { throw NumberError.couldNotInit }
            
            // Combine Whole and Fract
            guard let wholeVal = Int(wholeStr, radix: base.rawValue) else { throw NumberError.couldNotInit }
            let fractVal = Double(fractNum) / Double(fractDen)
            self.value = (abs(Double(wholeVal)) + fractVal) * sign
            self.hasFract = self.value != floor(self.value)

        } else {
            guard let wholeVal = Int(num, radix: base.rawValue) else { throw NumberError.couldNotInit }
            self.value = Double(wholeVal)
            self.hasFract = false
        }
    }
    
    //MARK:- Base Conversions

    private func fractToString(_ fract: Double, _ base: Base, _ precision: Int) -> String {
        var fractNum = fract
        let error = 1e-10
        var count = 1

        var result = ""

        while fractNum > error && result.count < precision {
            fractNum *= Double(base.rawValue)
            let wholeFractNum = Int(fractNum)

            result += String(wholeFractNum, radix: base.rawValue, uppercase: true)
            fractNum -= Double(wholeFractNum)
            count += 1
        }

        return result
    }

    func toString(base: Base? = nil, precision: Int = 15) -> String {
        let base = base ?? self.base

        let wholeNum = Int(value)
        let wholeStr = String(wholeNum, radix: base.rawValue, uppercase: true)

        let fractNum = abs(value) - abs(Double(wholeNum))
        let fractStr = hasFract ? "." + fractToString(fractNum, base, precision) : ""

        return wholeStr + fractStr
    }
    
    private func setBase(base: Base) {
        self.base = base
    }
    
    //MARK:- Arithmetic Operations
    
    static func + (leftNum: Number, rightNum: Number) throws -> Number {
        let sumValue = leftNum.value + rightNum.value
        let newNum = try Number(number: String(sumValue), base: .Base10)
        newNum.setBase(base: rightNum.base)
        
        return newNum
    }
    
    static func += (leftNum: inout Number, rightNum: Number) throws {
        leftNum = try leftNum + rightNum
    }
    
    static func - (leftNum: Number, rightNum: Number) throws -> Number {
        let negNum = try rightNum * -1
        return try leftNum + negNum
    }
    
    static func -= (leftNum: inout Number, rightNum: Number) throws {
        leftNum = try leftNum - rightNum
    }

    static func * (leftNum: Number, rightNum: Number) throws -> Number {
        let sumValue = leftNum.value * rightNum.value
        let newNum = try Number(number: String(sumValue), base: .Base10)
        newNum.setBase(base: rightNum.base)

        return newNum
    }
    
    static func * (leftNum: Number, rightNum: Double) throws -> Number {
        let multValue = leftNum.value * rightNum
        let newNum = try Number(number: String(multValue), base: .Base10)
        newNum.setBase(base: leftNum.base)
        
        return newNum
    }

    static func / (leftNum: Number, rightNum: Number) throws -> Number {
        let divValue = leftNum.value / rightNum.value
        let newNum = try Number(number: String(divValue), base: .Base10)
        newNum.setBase(base: leftNum.base)

        return newNum
    }
    
    static func / (leftNum: Number, rightNum: Double) throws -> Number {
        return try leftNum * (1.0 / rightNum)
    }
    
    //MARK:- Radix Complement
    
    func radixComplement(digits: Int? = nil) throws -> Number {
        let digits = digits ?? self.toString().count
        let complementNumber = "1" + String(repeating: "0", count: digits)
        
        return try Number(number: complementNumber, base: base) - self
    }
    
    func radixComplementDiminished(digits: Int? = nil) throws -> Number {
        return try radixComplement(digits: digits) - Number(number: "1", base: base)
    }
    
    //MARK:- Floating Point Arithmetic
    
    private func getSign() -> String {
        value >= 0 ? "0" : "1"
    }
    
    private func getExponent(_ exponentDigits: Int, _ expVal: Double) -> String {
        let expBias = pow(2, Double(exponentDigits - 1)) - 1
        let expPolarized = Int(expBias + expVal)
        let expBinary = String(expPolarized, radix: 2)
        
        return String(repeating: "0", count: exponentDigits - expBinary.count) + expBinary
    }
    
    private func getMantissa(_ mantissaDigits: Int, _ expVal: Double) -> String {
        let mantissaVal = (try! self / pow(2.0, expVal)).toString(base: .Base2, precision: mantissaDigits)
        
        // Check if mantissa is empty
        if let dotIndex = mantissaVal.range(of: ".") {
            let fract = mantissaVal[dotIndex.upperBound...].prefix(mantissaDigits)
            return String(fract + String(repeating: "0", count: mantissaDigits - fract.count))
        } else {
            return String(repeating: "0", count: mantissaDigits)
        }
    }
    
    func getFloatingPoint(exponentDigits: Int = 8, mantissaDigits: Int = 23) -> FloatingPoint {
        if value == 0.0 {
            return FloatingPoint(
                sign: "0",
                exp: String(repeating: "0", count: exponentDigits),
                mantissa: String(repeating: "0", count: mantissaDigits)
            )
        }
        
        // Determine exponent decimal value
        let expVal = floor(log2(abs(value)))
        
        // Obtain floating point components
        let sign = getSign()
        let exponent = getExponent(exponentDigits, expVal)
        let mantissa = getMantissa(mantissaDigits, expVal)
        
        return FloatingPoint(sign: sign, exp: exponent, mantissa: mantissa)
    }

    //MARK:- Bitwise Operations

    static func & (leftNum: Number, rightNum: Number) throws -> Number {
        let leftVal = Int(leftNum.value)
        let rightVal = Int(rightNum.value)
        let strResult = String(leftVal & rightVal)
        let result = try Number(number: strResult, base: .Base10)

        result.setBase(base: rightNum.base)
        return result
    }

    static func | (leftNum: Number, rightNum: Number) throws -> Number {
        let leftVal = Int(leftNum.value)
        let rightVal = Int(rightNum.value)
        let strResult = String(leftVal | rightVal)
        let result = try Number(number: strResult, base: .Base10)

        result.setBase(base: rightNum.base)
        return result
    }

    static func ^ (leftNum: Number, rightNum: Number) throws -> Number {
        let leftVal = Int(leftNum.value)
        let rightVal = Int(rightNum.value)
        let strResult = String(leftVal ^ rightVal)
        let result = try Number(number: strResult, base: .Base10)

        result.setBase(base: rightNum.base)
        return result
    }

    static func ~| (leftNum: Number, rightNum: Number) throws -> Number {
        let orResult = try leftNum | rightNum

        let ogBase = orResult.base
        orResult.setBase(base: .Base2)

        let norResult = try orResult.radixComplementDiminished()
        norResult.setBase(base: ogBase)

        return norResult
    }

    static func << (leftNum: Number, rightNum: Number) throws -> Number {
        let leftVal = Int(leftNum.value)
        let rightVal = Int(rightNum.value)
        
        let decVal = String(leftVal << rightVal)
        let result = try Number(number: decVal, base: .Base10)
        
        result.setBase(base: rightNum.base)
        return result
    }

    static func >> (leftNum: Number, rightNum: Number) throws -> Number {
        let leftVal = Int(leftNum.value)
        let rightVal = Int(rightNum.value)
        
        let decVal = String(leftVal >> rightVal)
        let result = try Number(number: decVal, base: .Base10)
        
        result.setBase(base: rightNum.base)
        return result
    }
}
