//
//  CalculatorState.swift
//  BaseCalc
//
//  Created by Ricardo J. González on 17/03/20.
//  Copyright © 2020 The Senate. All rights reserved.
//

import Foundation
import SwiftUI

class CalculatorState: ObservableObject {
    @Published var currentBase: Base = .Base2
}
