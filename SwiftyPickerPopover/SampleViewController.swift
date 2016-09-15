//
//  ViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBAction func tappedStringPickerButton(sender: UIButton) {
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "value 1":
                    return "😊"
                case "value 2":
                    return "😏"
                case "value 3":
                    return "😓"
                default:
                    return s
                }
            }
            return nil
        }
        
        // StringPickerPopover appears
        StringPickerPopover.appearFrom(sender, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: displayStringFor, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
    }
    
    @IBAction func tappendDatePickerButton(sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(sender, baseViewController: self, title: "DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")})
    }
    
    @IBAction func tappendDatePickerCanClearButton(sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(sender, baseViewController: self, title: "Clearable DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")},clearAction: { print("clear")})
    }
    
    
}

