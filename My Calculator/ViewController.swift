//
//  ViewController.swift
//  My Calculator
//
//  Created by Wang Shilong on 5/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var process: UILabel!
    
    private var brain = CalculatorBrain()
    
    var userTouched = false
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
   
    @IBAction func digits(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userTouched {
            let currentNumebrInDisplay = display.text!
            
            if digit != "." || currentNumebrInDisplay.range(of: ".") == nil {
                display.text = currentNumebrInDisplay + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userTouched = true
        }
    }
    
    @IBAction func performOperator(_ sender: UIButton) {
        
        //user already touched, so at this point userTouched = true
        if userTouched {
            brain.setOperand(displayValue)
            userTouched = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        displayValue = 0
        userTouched = false
    }
    
    
}

