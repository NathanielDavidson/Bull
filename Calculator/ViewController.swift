//
//  ViewController.swift
//  Calculator
//
//  Created by Nathaniel Davidson on 9/15/16.
//  Copyright © 2016 Nathaniel Davidson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var userisInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userisInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }else {
            display.text = digit
            userisInTheMiddleOfTypingANumber = true
        }
    }
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userisInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operand Stack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userisInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×":
            performOperation{$0*$1}
        case "÷":
            performOperation{$0/$1}
        case "+":
            performOperation{$0+$1}
        case "−":
            performOperation{$0-$1}
        case "√":
            performOperation{ sqrt($0) }
        default: break
        }
    }
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    @nonobjc func performOperation(operation: Double -> Double){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userisInTheMiddleOfTypingANumber = false
        }
    }
}

