//
//  ViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBAction func tappedStringPickerButton(_ sender: UIButton) {
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
        StringPickerPopover.appearFrom(originView: sender, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: displayStringFor, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
    }
    
    @IBAction func tappendDatePickerButton(_ sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(originView: sender, baseViewController: self, title: "DatePicker", dateMode: .date, initialDate: Date(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")})
    }
    
    @IBAction func tappendDatePickerCanClearButton(_ sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(originView: sender, baseViewController: self, title: "Clearable DatePicker", dateMode: .date, initialDate: Date(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")},clearAction: { print("clear")})
    }
    
    @IBAction func countdownButton(_ sender: UIButton) {
        // DatePickerPopover appears
        print("countdown")
        CountdownPickerPopover.appearFrom(sender, baseViewController: self, title: "CountdownPicker", dateMode: .countDownTimer, initialInterval: TimeInterval(), doneAction: { timeInterval in print("timeInterval \(timeInterval)")}, cancelAction: {print("cancel")})
        
    }
    
    @IBAction func columnsString(_ sender: UIButton) {
        ColumnStringPickerPopover.appearFrom(originView: sender, baseViewController: self, title: "Columns Strings",
            choices: [["Breakfast", "Lunch", "Dinner"], ["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
            initialRow: [0,0],
            columnPercent: [0.5, 0.5],
            fontSize: 12.0,
            doneAction: { selectionArray in print("selectionArray \(selectionArray)")}, cancelAction: {print("cancel")})
    }

    
    
}

