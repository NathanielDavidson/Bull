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
    private var memory: Double? = nil
    
    private enum Op
    {
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String,  () -> Double? )
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
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let symbol, _):
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
        learnOp(Op.Constant("π", M_PI));
        learnOp(Op.Variable("M", { self.memory }));
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
            case .Constant( _, let constantValue):
                return (constantValue, remainingOps)
            case .BinaryOperation( _ , let operation):
                let operandEvalutation1 = evaluate(remainingOps)
                if let operand1 = operandEvalutation1.result {
                    let operandEvalutation2 = evaluate(operandEvalutation1.remainingOps)
                    if let operand2 = operandEvalutation2.result {
                        return (operation(operand1, operand2), operandEvalutation2.remainingOps)
                    }
                }
            case .Variable(_, let variableVal):
                return (variableVal(), remainingOps)
            }
        }
        return (nil, ops)
    }
    private func describe(ops:[Op]) -> (remainingOps: [Op], display: String?, prevOp: Op?){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (remainingOps, "\(operand)", op)
            case .UnaryOperation( let symbol, _):
                let operandEvaluation = describe(remainingOps);
                if let operand = operandEvaluation.display {
                    print(operand)
                    return (operandEvaluation.remainingOps, "\(symbol)(\(operand))", op)
                }
            case .Constant( let symbol, _):
                return (remainingOps, "\(symbol)", op)
            case .Variable( let symbol, _):
                return (remainingOps, "\(symbol)", op)
            case .BinaryOperation(let symbol , _):
                let operandEvalutation1 = describe(remainingOps)
                if let operand1 = operandEvalutation1.display {
                    let operandEvalutation2 = describe(operandEvalutation1.remainingOps)
                    if let operand2 = operandEvalutation2.display {
                        var operand2V = operand2;
                        if operand2V=="" {
                            operand2V = "?"
                        }
                        var output = "";
                        if (op.description=="÷" || op.description=="×") && operandEvalutation2.prevOp != nil && ( operandEvalutation2.prevOp!.description=="−" || operandEvalutation2.prevOp!.description=="+" ) {
                            output = "\(output) ( \(operand2V) )"
                        }else{
                            output = "\(output) \(operand2V) "
                        }
                        output = "\(output)\(symbol)"
                        if (op.description=="÷" || op.description=="×") && operandEvalutation1.prevOp != nil && ( operandEvalutation1.prevOp!.description=="−" || operandEvalutation1.prevOp!.description=="+") {
                            output = "\(output) ( \(operand1) )"
                        }else{
                            output = "\(output) \(operand1)"
                        }
                        return (operandEvalutation2.remainingOps, output, op)
                    }
                }
            }
        }
        return (ops, "", nil)
    }
    func clear(){
        opStack.removeAll();
        memory = 0
    }
    func setMemory (k: Double?) {
        if let m = k {
            memory = m
        }
    }
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        //print(opStack)
        return result
    }
    var describe: String? {
        set{
            //nope
        }
        get {
            var result = describe(opStack)
            var output = result.display!
            while !result.remainingOps.isEmpty {
                result = describe(result.remainingOps)
                output = "\(result.display!), \(output)"
            }
            return output
        }
    }
}
