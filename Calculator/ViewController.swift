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
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
            history.text = "\(brain.describe!) = "
        } else {
            displayValue = 0
        }
    }
    @IBOutlet weak var history: UILabel!
    
    @IBAction func brainClear() {
        brain.clear();
        displayValue = 0
        history.text = brain.describe!
    }
    
    @IBAction func MemorySet(sender: UIButton) {
        brain.setMemory(displayValue)
        userisInTheMiddleOfTypingANumber=false
        displayValue = brain.evaluate();
        history.text = "\(brain.describe!) = "
        
    }
    @IBAction func MemoryTry(sender: UIButton) {
        brain.performOperation("M")
        history.text = brain.describe!
    }
    @IBAction func pi() {
        brain.performOperation("π")
        history.text = brain.describe!
        display.text = "π"
    }
    
    @IBAction func backSpace() {
        if userisInTheMiddleOfTypingANumber {
            var data = display.text!
            data.removeAtIndex(data.endIndex.predecessor())
            display.text = data
            if display.text!=="" {
                displayValue = 0;
            }
        }
    }
    
    @IBAction func period() {
        if userisInTheMiddleOfTypingANumber {
            if display.text!.containsString(".")==false {
                display.text = "\(display.text!)."
                history.text = brain.describe!
            } 
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userisInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                history.text = "\(brain.describe!) = "
            } else {
                displayValue = nil
                history.text = brain.describe!
            }
        }
    }
    var displayValue: Double? {
        get {
            if(display.text!=="π"){
                return M_PI
            }
            if let val = NSNumberFormatter().numberFromString(display.text!) {
                return val.doubleValue
            }else{
                return nil
            }
        }
        set{
            if let y = newValue {
                display.text = "\(y)"
            }else {
                display.text="nil"
            }
            userisInTheMiddleOfTypingANumber = false
        }
    }
}

