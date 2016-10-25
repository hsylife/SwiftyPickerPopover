//
//  ViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class SampleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        StringPickerPopover.appearFrom(originView: sender, baseViewController: self, title: "StringPicker", choices: ["value 1","value 2","value 3"], displayStringFor: displayStringFor, initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})
    }
    
    @IBAction func tappendDatePickerButton(sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(originView: sender, baseViewController: self, title: "DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")})
    }
    
    @IBAction func tappendDatePickerCanClearButton(sender: UIButton) {
        // DatePickerPopover appears
        DatePickerPopover.appearFrom(originView: sender, baseViewController: self, title: "Clearable DatePicker", dateMode: .Date, initialDate: NSDate(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")},clearAction: { print("clear")})
    }
    
    @IBAction func countdownButton(sender: UIButton) {
        // DatePickerPopover appears
        print("countdown")
        CountdownPickerPopover.appearFrom(originView: sender, baseViewController: self, title: "CountdownPicker", dateMode: .CountDownTimer, initialInterval: NSTimeInterval(), doneAction: { timeInterval in print("timeInterval \(timeInterval)")}, cancelAction: {print("cancel")})
        
    }
    
    @IBAction func columnsString(sender: UIButton) {
        ColumnStringPickerPopover.appearFrom(originView: sender, baseViewController: self, title: "Columns Strings",
            choices: [["Breakfast", "Lunch", "Dinner"], ["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
            initialRow: [0,0],
            columnPercent: [0.5, 0.5],
            fontSize: 12.0,
            doneAction: { selectedRows, selectedStrings in print("selected rows \(selectedRows) strings \(selectedStrings)")}, cancelAction: {print("cancel")})
    }

    //CollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let label = theCell.contentView.viewWithTag(1) as! UILabel
        label.text = (indexPath as NSIndexPath).row.description
        
        return theCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        StringPickerPopover.appearFrom(originView: theCell, baseView: collectionView, baseViewController: self, title: "CollectionView", choices: ["value 1","value 2","value 3"], initialRow:0, doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")} , cancelAction: { print("cancel")})

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
}

