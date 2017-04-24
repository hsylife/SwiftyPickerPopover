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
    
    @IBAction func tappedStringPickerButton(_ sender: UIButton) {
        /// Replace a string with the string to be display.
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
        
        /// Create StringPickerPopover:
        let p = StringPickerPopover(title: "StringPicker", choices: ["value 1","value 2","value 3"])
            .setDisplayStringFor(displayStringFor)
            .setDoneButton(completion: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(completion: {v in
                print("cancel") })
        
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )

    }
    
    @IBAction func tappendDatePickerButton(_ sender: UIButton) {
        /// DatePickerPopover appears:
        DatePickerPopover(title: "DatePicker")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneButton(completion: { popover, selectedDate in print("selectedDate \(selectedDate)")})
            .setCancelButton(completion: { v in print("cancel")})
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func tappendDatePickerCanClearButton(_ sender: UIButton) {
        /// DatePickerPopover appears:
        let p = DatePickerPopover(title: "Clearable DatePicker")
            .setDoneButton(completion: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(completion: { v in print("cancel")})
            .setClearButton(completion: { popover, selectedDate in
                print("clear")
                //Rewind
                popover.setSelectedDate(Date()).reload()
                //Instead, hide it.
//                popover.disappear()
            })
            
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0)

    }
    
    @IBAction func tappendDatePickerTime5MinIntButton(_ sender: UIButton) {
        // DatePickerPopover appears:
        DatePickerPopover(title: "DatePicker .time 5minInt.")
            .setDateMode(.time)
            .setMinuteInterval(5)
            .setPermittedArrowDirections(.down)
            .setDoneButton(completion: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(completion: { v in print("cancel")})
            .appear(originView: sender, baseViewController: self)
    }

    @IBAction func countdownButton(_ sender: UIButton) {
        
        // CountdownPickerPopover appears:
        CountdownPickerPopover(title: "CountdownPicker")
            .setSelectedTimeInterval(TimeInterval())
            .setDoneButton(completion: { popover, timeInterval in print("timeInterval \(timeInterval)")} )
            .setCancelButton(completion: { v in print("cancel")})
            .setClearButton(completion: { popover, timeInterval in print("Clear")
                popover.setSelectedTimeInterval(TimeInterval()).reload()
            })
            .appear(originView: sender, baseViewController: self)
        
    }
    
    @IBAction func columnsString(_ sender: UIButton) {
        //ColumnStringPickerPopover appears.
        ColumnStringPickerPopover(title: "Columns Strings",
                                  choices: [["Breakfast", "Lunch", "Dinner"], ["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
                                  selectedRows: [0,0], columnPercents: [0.5, 0.5])
        .setDoneButton(completion: { popover, selectedRows, selectedStrings in print("selected rows \(selectedRows) strings \(selectedStrings)")})
        .setCancelButton(completion: { v in print("cancel")})
        .setFontSize(14)
        .appear(originView: sender, baseViewController: self)
    }

    //CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = theCell.contentView.viewWithTag(1) as! UILabel
        label.text = (indexPath as NSIndexPath).row.description
        
        return theCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //StringPickerPopover appears from the cell of collectionView.
        let p = StringPickerPopover(title: "CollectionView", choices: ["value 1","value 2","value 3"])
        .setSelectedRow(1)
        .setDoneButton(title:"👌", completion: { (popover, selectedRow, selectedString) in
            print("done row \(selectedRow) \(selectedString)")
        })
        .setCancelButton(title:"🗑", completion: { v in print("cancel")} )
        
        p.appear(originView: theCell, baseView: collectionView, baseViewController: self)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    
}

