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
    var brain = CalculatorBrain()
    
    @IBAction func enter() {
        userisInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func brainClear() {
        brain = CalculatorBrain()
        if let result = brain.evaluate(){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    @IBAction func operate(sender: UIButton) {
        if userisInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
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

