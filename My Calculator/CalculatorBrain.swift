//
//  CalculatorBrain.swift
//  My Calculator
//
//  Created by Wang Shilong on 5/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var accumulatorStr: String?
    private var firstAccumulatorStr: String?
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equal
    }
    
    private var operators: Dictionary <String, Operation> = [
    
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "±" : Operation.unaryOperation({ -$0 }),
        "x²" : Operation.unaryOperation({ $0 * $0 }),
        "x³" : Operation.unaryOperation({ $0 * $0 * $0 }),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0 }),
        "+" : Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }),
        "-" : Operation.binaryOperation({ $0 - $1 }, { "\($0) - \($1)" }),
        "×" : Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }),
        "÷" : Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "=" : Operation.equal
    ]
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        accumulatorStr = String(operand)
    }
    
    private struct PendingBinaryOperation {
        let function: ((Double, Double) -> Double)
        let firstOperand: Double
        let processFunction: (String, String) -> String
        let processOperand: String
    
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
        func getProcess(with secondOperand: String) -> String {
            return processFunction(processOperand, secondOperand)
        }
        
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operators[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function, let processFunction):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, processFunction: processFunction, processOperand:  accumulatorStr!)
                    accumulator = nil
                    firstAccumulatorStr = accumulatorStr
                    accumulatorStr = nil
                }
            case .equal:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            accumulatorStr = pendingBinaryOperation?.getProcess(with: accumulatorStr!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func clear() {
        accumulator = 0
        accumulatorStr = nil
        pendingBinaryOperation = nil
    }
    
    var getFirstProcess: String? {
        get {
            return firstAccumulatorStr
        }
    }
    
    var getProcess: String? {
        get {
            return accumulatorStr
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }

    
}
