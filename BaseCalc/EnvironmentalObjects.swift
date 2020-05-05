//
//  CalculatorState.swift
//  BaseCalc
//
//  Created by Ricardo J. González on 17/03/20.
//  Copyright © 2020 The Senate. All rights reserved.
//

import Foundation
import SwiftUI

enum Operation: String {
    case add = "+";
    case subtract = "-";
    case multiply = "x";
    case divide = "÷";
    case and = "AND";
    case or = "OR";
    case xor = "XOR";
    case nor = "NOR";
}

class LayoutState: ObservableObject {
    @Published var isLandscape: Bool

    init(isLandscape: Bool = false) {
        self.isLandscape = isLandscape
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func onRotation() {
        let orientation = UIDevice.current.orientation
        
        if orientation == .portrait || orientation.isLandscape {
            self.isLandscape = orientation.isLandscape
        }
    }
}

class CalculatorState: ObservableObject {
    @Published var currentBase: Base = .Base10
    @Published var prevNumber: Number? = nil
    @Published var prevOperation: Operation? = nil
    @Published var currentText: String = "0"
    @Published var hasDecimalDot: Bool = false
    @Published var willPerformOperation: Bool = false
    @Published var isNegative: Bool = false

    func addDigit(_ digitToAdd: String) {
        let digitToAddIsDot = digitToAdd == "."

        if willPerformOperation {
            prevNumber = Number(number: currentText, base: currentBase)

            if digitToAddIsDot {
                currentText = "0."
            } else {
                currentText = digitToAdd
            }

            willPerformOperation.toggle()
            hasDecimalDot = digitToAddIsDot
            return
        }

        if hasDecimalDot && digitToAddIsDot {
            return
        }

        if currentText == "0" && !digitToAddIsDot {
            currentText = digitToAdd
        } else {
            currentText += digitToAdd
            hasDecimalDot = hasDecimalDot || digitToAddIsDot
        }
    }

    func allClear() {
        currentText = "0"
        hasDecimalDot = false
        willPerformOperation = false
        isNegative = false
        prevOperation = nil
        prevNumber = nil
    }

    func isInvalidForBitOperations() -> Bool {
        isNegative || hasDecimalDot
    }

    func performOperation(op: Operation) {
        willPerformOperation = true
        prevOperation = op
    }
    
    func isOperationSelected(op: Operation) -> Bool {
        willPerformOperation && prevOperation == op
    }

    func changeSign() {
        if currentText != "0" {
            if isNegative {
                currentText.remove(at: currentText.startIndex)
            } else {
                currentText = "-" + currentText
            }
            isNegative.toggle()
        }
    }

    func changeBase(_ newBase: Base) {
        let currNumber = Number(number: currentText, base: currentBase)
        currentText = currNumber.toString(base: newBase)
        hasDecimalDot = currNumber.hasFract
        currentBase = newBase
    }

    func solve() {
        let currentNumber = Number(number: currentText, base: currentBase)

        switch prevOperation {
        case .add:
            changePrevNumber(answer: (prevNumber ?? currentNumber) + currentNumber)
        case .subtract:
            changePrevNumber(answer: (prevNumber ?? currentNumber) - currentNumber)
        case .and:
            changePrevNumber(answer: (prevNumber ?? currentNumber) & currentNumber)
        case .or:
            changePrevNumber(answer: (prevNumber ?? currentNumber) | currentNumber)
        case .xor:
            changePrevNumber(answer: (prevNumber ?? currentNumber) ^ currentNumber)
        case .nor:
            changePrevNumber(answer: (prevNumber ?? currentNumber) ~| currentNumber)
        default:
            print(prevOperation == nil)
        }
    }

    private func changePrevNumber(answer: Number) {
        prevNumber = answer
        currentText = answer.toString()
        isNegative = answer.value < 0
        prevOperation = nil
    }
}

class GeneralAlertManager: ObservableObject {
    @Published var isShowing: Bool = false

    init(isShowing: Bool = false) {
        self.isShowing = isShowing
    }
}

class PopUpPickerViewManager: GeneralAlertManager {
    @Published var currentIndex: Int = 8

    func showPickerView(_ currentBase: Base) {
        isShowing = true
        currentIndex = currentBase.rawValue - 2
    }
}

class ComplementAlertManager: GeneralAlertManager {}

class FloatingPointAlertManager: GeneralAlertManager {}

class ToastManager: GeneralAlertManager {
    @Published var content: String = ""

    init(isShowing: Bool = false, content: String = "") {
        super.init(isShowing: isShowing)
        self.content = content
    }

    func showToast(content: String) {
        isShowing = true
        self.content = content
    }
}
