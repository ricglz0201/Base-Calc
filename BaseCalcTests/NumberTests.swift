//
//  NumberTests.swift
//  BaseCalcTests
//
//  Created by Juan Lizarraga on 20/03/20.
//  Copyright © 2020 The Senate. All rights reserved.
//

import XCTest

@testable import BaseCalc

class NumberTests: XCTestCase {

    private var num1: Number!
    private var num2: Number!
    private var num3: Number!
    private var floating: FloatingPoint!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        num1 = nil
        num2 = nil
        num3 = nil
        floating = nil
    }

    //MARK:- Testing value of numbers

    func testWholePositiveValue() {
        num1 = try! Number(number: "FA", base: .Base16)
        XCTAssertEqual(num1.value, 250)
    }

    func testWholeNegativeValue() {
        num1 = try! Number(number: "-121", base: .Base3)
        XCTAssertEqual(num1.value, -16)
    }

    func testFloatingPositiveValue() {
        num1 = try! Number(number: "10.3", base: .Base8)
        XCTAssertEqual(num1.value, 8.375)
    }

    func testFloatingNegativeValue() {
        num1 = try! Number(number: "-2.4C", base: .Base15)
        XCTAssertEqual(num1.value, -2.32)
    }

    func testWholeWithDecimalValue() {
        num1 = try! Number(number: "10.0000", base: .Base10)
        XCTAssertEqual(num1.value, 10)
    }

    func testWholeWithPointValue() {
        num1 = try! Number(number: "10.", base: .Base10)
        XCTAssertEqual(num1.value, 10)
    }

    //MARK:- Testing hasFract of numbers

    func testWholePositiveFract() {
        num1 = try! Number(number: "F", base: .Base16)
        XCTAssertEqual(num1.hasFract, false)
    }

    func testWholeNegativeFract() {
        num1 = try! Number(number: "-42", base: .Base5)
        XCTAssertEqual(num1.hasFract, false)
    }

    func testFloatingPositiveFract() {
        num1 = try! Number(number: "3.14", base: .Base8)
        XCTAssertEqual(num1.hasFract, true)
    }

    func testFloatingNegativeFract() {
        num1 = try! Number(number: "-0.15", base: .Base10)
        XCTAssertEqual(num1.hasFract, true)
    }

    func testWholeWithDecimalFract() {
        num1 = try! Number(number: "3.00000", base: .Base10)
        XCTAssertEqual(num1.hasFract, false)
    }

    func testWholeWithPointFract() {
        num1 = try! Number(number: "3.", base: .Base13)
        XCTAssertEqual(num1.hasFract, false)
    }

    //MARK:- Testing string display of numbers

    func testWholePostiveToString() {
        num1 = try! Number(number: "29", base: .Base11)
        XCTAssertEqual(num1.toString(), "29")
    }

    func testWholeNegativeToString() {
        num1 = try! Number(number: "-74", base: .Base11)
        XCTAssertEqual(num1.toString(), "-74")
    }

    func testFloatingPostiveToString() {
        num1 = try! Number(number: "25.11", base: .Base11)
        XCTAssertEqual(num1.toString(), "25.11")
    }

    func testFloatingNegativeToString() {
        num1 = try! Number(number: "-33.69", base: .Base11)
        XCTAssertEqual(num1.toString(), "-33.69")
    }

    func testWholeDecimalToString() {
        num1 = try! Number(number: "5.000000", base: .Base14)
        XCTAssertEqual(num1.toString(), "5")
    }

    func testWholeWithPointToString() {
        num1 = try! Number(number: "2.", base: .Base4)
        XCTAssertEqual(num1.toString(), "2")
    }

    //MARK:- Testing conversion of numbers

    func testConversionToBiggerBase() {
        num1 = try! Number(number: "1010.1011", base: .Base2)
        XCTAssertEqual(num1.toString(base: .Base16), "A.B")
    }

    func testConversionToSmallerBase() {
        num1 = try! Number(number: "1A.8", base: .Base12)
        XCTAssertEqual(num1.toString(base: .Base9), "24.6")
    }

    //MARK:- Testing number addition

    func testSameBaseWholeAddition() {
        num1 = try! Number(number: "F", base: .Base16)
        num2 = try! Number(number: "A", base: .Base16)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 25)
        XCTAssertFalse(num3.hasFract)
    }

    func testDifferentBaseWholeAddition() {
        num1 = try! Number(number: "50", base: .Base9)
        num2 = try! Number(number: "100", base: .Base7)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 94)
        XCTAssertFalse(num3.hasFract)
    }

    func testSameBaseFloatingAddition() {
        num1 = try! Number(number: "101.01", base: .Base2)
        num2 = try! Number(number: "1.1", base: .Base2)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 6.75)
        XCTAssertTrue(num3.hasFract)
    }

    func testDifferentBaseFloatingAddition() {
        num1 = try! Number(number: "1200.2", base: .Base5)
        num2 = try! Number(number: "35.6", base: .Base15)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 225.8)
        XCTAssertTrue(num3.hasFract)
    }

    func testFloatingAdditionThatAddsToWhole() {
        num1 = try! Number(number: "0.3", base: .Base10)
        num2 = try! Number(number: "0.7", base: .Base10)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 1)
        XCTAssertFalse(num3.hasFract)
    }

    func testNegativeAddition() {
        num1 = try! Number(number: "10.5", base: .Base10)
        num2 = try! Number(number: "-11", base: .Base7)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.value, 2.5)
        XCTAssertTrue(num3.hasFract)
    }

    func testBaseAfterAddition() {
        num1 = try! Number(number: "1", base: .Base3)
        num2 = try! Number(number: "F", base: .Base16)
        num3 = try! num1 + num2
        XCTAssertEqual(num3.base, Base.Base16)
    }

    func testAdditionWithPlusEquals() {
        num1 = try! Number(number: "1.5", base: .Base10)
        num2 = try! Number(number: "0.5", base: .Base10)
        try! num2 += num1
        XCTAssertEqual(num2.value, 2)
        XCTAssertFalse(num2.hasFract)
    }

    func testAdditionWithPlusEqualsThatAddsToWhole() {
        num1 = try! Number(number: "1.3", base: .Base10)
        num2 = try! Number(number: "1.7", base: .Base10)
        try! num1 += num2
        XCTAssertEqual(num1.value, 3)
        XCTAssertFalse(num1.hasFract)
    }

    //MARK:- Testing number multiplication

    func testSameBaseWholeMultiplication() {
        num1 = try! Number(number: "F", base: .Base16)
        num2 = try! Number(number: "A", base: .Base16)
        num3 = try! num1 * num2
        XCTAssertEqual(num3.value, 150)
        XCTAssertFalse(num3.hasFract)
    }

    func testDifferentBaseWholeMultiplication() {
        num1 = try! Number(number: "50", base: .Base9)
        num2 = try! Number(number: "100", base: .Base7)
        num3 = try! num1 * num2
        XCTAssertEqual(num3.value, 2205)
        XCTAssertFalse(num3.hasFract)
    }

    func testSameBaseFloatingMultiplication() {
        num1 = try! Number(number: "101.01", base: .Base2)
        num2 = try! Number(number: "1.1", base: .Base2)
        num3 = try! num1 * num2
        XCTAssertEqual(num3.value, 7.875)
        XCTAssertTrue(num3.hasFract)
    }

    func testDifferentBaseFloatingMultiplication() {
        num1 = try! Number(number: "1200.2", base: .Base5)
        num2 = try! Number(number: "35.6", base: .Base15)
        num3 = try! num1 * num2
        XCTAssertEqual(num3.value, 8840.16)
        XCTAssertTrue(num3.hasFract)
    }

    func testFloatingMultiplicationThatResultsInWhole() {
        num1 = try! Number(number: "1.5", base: .Base10)
        num2 = try! Number(number: "2", base: .Base10)
        num3 = try! num1 * num2
        XCTAssertEqual(num3.value, 3)
        XCTAssertFalse(num3.hasFract)
    }

    //MARK:- Testing number subtraction

    func testSameBaseWholeSubtraction() {
        num1 = try! Number(number: "F", base: .Base16)
        num2 = try! Number(number: "A", base: .Base16)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, 5)
        XCTAssertFalse(num3.hasFract)
    }

    func testDifferentBaseWholeSubtraction() {
        num1 = try! Number(number: "50", base: .Base9)
        num2 = try! Number(number: "100", base: .Base7)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, -4)
        XCTAssertFalse(num3.hasFract)
    }

    func testSameBaseFloatingSubtraction() {
        num1 = try! Number(number: "101.01", base: .Base2)
        num2 = try! Number(number: "1.1", base: .Base2)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, 3.75)
        XCTAssertTrue(num3.hasFract)
    }

    func testDifferentBaseFloatingSubtraction() {
        num1 = try! Number(number: "1200.2", base: .Base5)
        num2 = try! Number(number: "35.6", base: .Base15)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, 125)
        XCTAssertFalse(num3.hasFract)
    }

    func testSubtractionThatEndsWithWhole() {
        num1 = try! Number(number: "1.7", base: .Base10)
        num2 = try! Number(number: "0.7", base: .Base10)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, 1)
        XCTAssertFalse(num3.hasFract)
    }

    func testNegativeSubtraction() {
        num1 = try! Number(number: "10.5", base: .Base10)
        num2 = try! Number(number: "-11", base: .Base7)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.value, 18.5)
        XCTAssertTrue(num3.hasFract)
    }

    func testBaseAfterSubtraction() {
        num1 = try! Number(number: "1", base: .Base3)
        num2 = try! Number(number: "F", base: .Base16)
        num3 = try! num1 - num2
        XCTAssertEqual(num3.base, Base.Base16)
    }

    func testSubtractionWithMinusEquals() {
        num1 = try! Number(number: "0.5", base: .Base10)
        num2 = try! Number(number: "1.5", base: .Base10)
        try! num2 -= num1
        XCTAssertEqual(num2.value, 1)
        XCTAssertFalse(num2.hasFract)
    }

    func testSubtractionWithMinusEqualThatEndsWithWhole() {
        num1 = try! Number(number: "1.3", base: .Base10)
        num2 = try! Number(number: "0.3", base: .Base10)
        try! num1 -= num2
        XCTAssertEqual(num1.value, 1)
        XCTAssertFalse(num1.hasFract)
    }

    //MARK:- Testing number division

    func testSameBaseWholeDivision() {
        num1 = try! Number(number: "10", base: .Base16)
        num2 = try! Number(number: "2", base: .Base16)
        num3 = try! num1 / num2
        XCTAssertEqual(num3.value, 8)
        XCTAssertFalse(num3.hasFract)
    }

    func testDifferentBaseWholeDivision() {
        num1 = try! Number(number: "176", base: .Base9)
        num2 = try! Number(number: "101", base: .Base7)
        num3 = try! num1 / num2
        XCTAssertEqual(num3.value, 3)
        XCTAssertFalse(num3.hasFract)
    }

    func testSameBaseFloatingDivision() {
        num1 = try! Number(number: "101.01", base: .Base2)
        num2 = try! Number(number: "1.1", base: .Base2)
        num3 = try! num1 / num2
        XCTAssertEqual(num3.value, 3.5)
        XCTAssertTrue(num3.hasFract)
    }

    func testDifferentBaseFloatingDivision() {
        num1 = try! Number(number: "14.6", base: .Base8)
        num2 = try! Number(number: "4.4", base: .Base5)
        num3 = try! num1 / num2
        XCTAssertEqual(num3.value, 2.65625)
        XCTAssertTrue(num3.hasFract)
    }

    func testFloatingDivisionThatResultsInWhole() {
        num1 = try! Number(number: "6.5", base: .Base10)
        num2 = try! Number(number: "0.5", base: .Base10)
        num3 = try! num1 / num2
        XCTAssertEqual(num3.value, 13)
        XCTAssertFalse(num3.hasFract)
    }

    //MARK:- Testing number multiplication (Double)

    func testMultiplicationWithDouble() {
        num1 = try! Number(number: "0.5", base: .Base10)
        num2 = try! num1 * 2
        XCTAssertEqual(num2.value, 1)
        XCTAssertFalse(num2.hasFract)
    }

    //MARK:- Testing number division (Double)

    func testDivisionWithDouble() {
        num1 = try! Number(number: "1.5", base: .Base10)
        num2 = try! num1 / 3
        XCTAssertEqual(num2.value, 0.5)
        XCTAssertTrue(num2.hasFract)
    }

    //MARK:- Testing radix complement

    func testRadixComplementNoDigits() {
        num1 = try! Number(number: "124", base: .Base16)
        XCTAssertEqual(try! num1.radixComplement().toString(), "EDC")
    }

    func testRadixComplementWithDigits() {
        num1 = try! Number(number: "7312", base: .Base10)
        XCTAssertEqual(try! num1.radixComplement(digits: 6).toString(), "992688")
    }

    func testRadixComplementDiminishedNoDigits() {
        num1 = try! Number(number: "1", base: .Base8)
        XCTAssertEqual(try! num1.radixComplementDiminished().toString(), "6")
    }

    func testRadixComplementDiminishedWithDigits() {
        num1 = try! Number(number: "1010", base: .Base2)
        XCTAssertEqual(try! num1.radixComplementDiminished(digits: 8).toString(), "11110101")
    }

    //MARK:- Testing floating point

    func testZeroValueFloatingPoint() {
        num1 = try! Number(number: "0", base: .Base10)
        floating = num1.getFloatingPoint()
        XCTAssertEqual(floating.sign, "0")
        XCTAssertEqual(floating.exp, "00000000")
        XCTAssertEqual(floating.mantissa, "00000000000000000000000")
        XCTAssertEqual(
            floating.description,
            "0 00000000 00000000000000000000000"
        )
    }

    func testPowerOf2FloatingPoint() {
        num1 = try! Number(number: "8", base: .Base10)
        floating = num1.getFloatingPoint()
        XCTAssertEqual(floating.sign, "0")
        XCTAssertEqual(floating.exp, "10000010")
        XCTAssertEqual(floating.mantissa, "00000000000000000000000")
    }

    func testPositive16BitFloatingPoint() {
        num1 = try! Number(number: "39887.5625", base: .Base10)
        floating = num1.getFloatingPoint()
        XCTAssertEqual(floating.sign, "0")
        XCTAssertEqual(floating.exp, "10001110")
        XCTAssertEqual(floating.mantissa, "00110111100111110010000")
    }

    func testNegative16BitFloatingPoint() {
        num1 = try! Number(number: "-521.5", base: .Base16)
        floating = num1.getFloatingPoint()
        XCTAssertEqual(floating.sign, "1")
        XCTAssertEqual(floating.exp, "10001001")
        XCTAssertEqual(floating.mantissa, "01001000010101000000000")
    }

    func testPositive32BitFloatingPoint() {
        num1 = try! Number(number: "10.1", base: .Base10)
        floating = num1.getFloatingPoint(exponentDigits: 11, mantissaDigits: 52)
        XCTAssertEqual(floating.sign, "0")
        XCTAssertEqual(floating.exp, "10000000010")
        XCTAssertEqual(floating.mantissa, "0100001100110011001100110011001100110011001100110011")
    }

    func testNegative32BitFloatingPoint() {
        num1 = try! Number(number: "-1.FFFFFFFF", base: .Base16)
        floating = num1.getFloatingPoint(exponentDigits: 11, mantissaDigits: 52)
        XCTAssertEqual(floating.sign, "1")
        XCTAssertEqual(floating.exp, "01111111111")
        XCTAssertEqual(floating.mantissa, "1111111111111111111111111111111100000000000000000000")
    }

    //MARK:- Testing Bitwise Operations

    func testAndOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "3", base: .Base10)
        num3 = try! num1 & num2
        XCTAssertEqual(num3.value, 2.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testAndOperationDiffBase(){
        num1 = try! Number(number: "11011", base: .Base2)
        num2 = try! Number(number: "1110", base: .Base2)
        num3 = try! num1 & num2
        XCTAssertEqual(num3.value, 10)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base2)
    }

    func testOrOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "3", base: .Base10)
        num3 = try! num1 | num2
        XCTAssertEqual(num3.value, 11.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testOrOperationDiffBase(){
        num1 = try! Number(number: "11011", base: .Base2)
        num2 = try! Number(number: "100", base: .Base2)
        num3 = try! num1 | num2
        XCTAssertEqual(num3.value, 31)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base2)
    }

    func testXorOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "3", base: .Base10)
        num3 = try! num1 ^ num2
        XCTAssertEqual(num3.value, 9.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testXorOperationDiffBase(){
        num1 = try! Number(number: "ABC", base: .Base16)
        num2 = try! Number(number: "DEF", base: .Base16)
        num3 = try! num1 ^ num2
        XCTAssertEqual(num3.value, 1875.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base16)
    }

    func testNorOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "3", base: .Base10)
        num3 = try! num1 ~| num2
        XCTAssertEqual(num3.value, 4.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testNorOperationDiffBase(){
        num1 = try! Number(number: "ABC", base: .Base16)
        num2 = try! Number(number: "DE", base: .Base16)
        num3 = try! num1 ~| num2
        XCTAssertEqual(num3.value, 1281.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base16)
    }

    func testLeftShiftOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "2", base: .Base10)
        num3 = try! num1 << num2
        XCTAssertEqual(num3.value, 40.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testLeftShiftOperationDiffBase(){
        num1 = try! Number(number: "11011", base: .Base2)
        num2 = try! Number(number: "1", base: .Base2)
        num3 = try! num1 << num2
        XCTAssertEqual(num3.value, 54)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base2)
    }

    func testRightShiftOperation(){
        num1 = try! Number(number: "10", base: .Base10)
        num2 = try! Number(number: "2", base: .Base10)
        num3 = try! num1 >> num2
        XCTAssertEqual(num3.value, 2.0)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base10)
    }
    
    func testRightShiftOperationDiffBase(){
        num1 = try! Number(number: "11011", base: .Base2)
        num2 = try! Number(number: "1", base: .Base2)
        num3 = try! num1 >> num2
        XCTAssertEqual(num3.value, 13)
        XCTAssertFalse(num3.hasFract)
        XCTAssertEqual(num3.base, Base.Base2)
    }

    //MARK:- Testing error throwing
    func testCouldNotInitWholeNumber() {
        XCTAssertThrowsError(try Number(number: "12345678901234567890", base: .Base10)) { error in
            XCTAssertEqual(error as! NumberError, NumberError.couldNotInit)
        }
    }

    func testCouldNotInitWholeNumberWithPoint() {
        XCTAssertThrowsError(try Number(number: "12345678901234567890.", base: .Base10)) { error in
            XCTAssertEqual(error as! NumberError, NumberError.couldNotInit)
        }
    }

    func testCouldNotInitDifferentBase() {
        XCTAssertThrowsError(try Number(number: "FFFFFFFFFFFFFFFF", base: .Base16)) { error in
            XCTAssertEqual(error as! NumberError, NumberError.couldNotInit)
        }
    }

    func testCouldNotInitLongFract() {
        XCTAssertThrowsError(try Number(number: "0.12345678901234567890", base: .Base10)) { error in
            XCTAssertEqual(error as! NumberError, NumberError.couldNotInit)
        }
    }

    func testCouldNotInitLongFloat() {
        XCTAssertThrowsError(try Number(number: "12345678901234567890.FFFF", base: .Base16)) { error in
            XCTAssertEqual(error as! NumberError, NumberError.couldNotInit)
        }
    }
}
