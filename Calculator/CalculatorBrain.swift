//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nathaniel Davidson on 9/15/16.
//  Copyright © 2016 Nathaniel Davidson. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var opStack = [Op]()
    
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self{
                case .Operand( let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷"){$1/$0})
        learnOp(Op.BinaryOperation("−"){$1-$0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    private func evaluate(ops:[Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation( _, let operation):
                let operandEvaluation = evaluate(remainingOps);
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation( _ , let operation):
                let operandEvalutation1 = evaluate(remainingOps)
                if let operand1 = operandEvalutation1.result {
                    let operandEvalutation2 = evaluate(operandEvalutation1.remainingOps)
                    if let operand2 = operandEvalutation2.result {
                        return (operation(operand1, operand2), operandEvalutation2.remainingOps)
                    }
                }
            }
            
        }
        return (nil, ops)
    }
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        print(opStack)
        return result
    }
}