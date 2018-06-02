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
            .setFont(UIFont.boldSystemFont(ofSize: 14))
            .setFontColor(.blue)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            .setDoneButton(
                font: UIFont.boldSystemFont(ofSize: 16),
                color: UIColor.orange,
                action: { popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
    }
    
    @IBAction func didTapStringPickerWithImageButton(_ sender: UIButton) {
        /// StringPickerPopover with image:
        let p = StringPickerPopover(title: "with image", choices: ["value 1","value 2",""])
            .setImageNames(["imageIcon",nil,"thumbUpIcon"])
            .setSize(width: 280)
            .setCornerRadius(0)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            .setDoneButton(color: UIColor.red, action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setOutsideTapDismissing(allowed: false)
            .setDimmedBackgroundView(enabled: true)
        p.appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func didTapStringPickerClearableButton(_ sender: UIButton) {
        /// StringPickerPopover Clearable:
        let p = StringPickerPopover(title: "Clearable", choices: ["value 1","value 2","value3"])
            .setDoneButton(color: UIColor.red, action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setClearButton(title: "Reset", action: {(popover, row, value) in
                print("clear")
            })
        p.appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func didTapStringPickerWithTextField(_ sender: UITextField) {
        StringPickerPopover(title: "TextField", choices: ["","Text 1", "Text 2", "Text 3"])
        .setValueChange(action: { _, _, selectedString in
            print("current string: \(selectedString)")
        })
        .setDoneButton(action: { popover, selectedRow, selectedString in
            sender.text = selectedString
        })
        .appear(originView: sender, baseViewController: self)        
    }
    
    @IBAction func tappendDatePickerButton(_ sender: UIButton) {
        /// DatePickerPopover appears:
        DatePickerPopover(title: "DatePicker")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setValueChange(action: { _, selectedDate in
                print("current date \(selectedDate)")
            })
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")})
            .setCancelButton(action: { _, _ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func tappendDatePickerCanClearButton(_ sender: UIButton) {
        /// DatePickerPopover appears:
        let p = DatePickerPopover(title: "Clearable DatePicker")
            .setLocale(identifier: "en_GB") //en_GB is dd-MM-YYYY. en_US is MM-dd-YYYY. They are both in English.
            .setValueChange(action: { _, selectedDate in
                print("current date \(selectedDate)")
            })
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .setClearButton(action: { popover, selectedDate in
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
            .setValueChange(action: { _, selectedDate in
                print("current date \(selectedDate)")
            })
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
    }

    @IBAction func countdownButton(_ sender: UIButton) {
        // CountdownPickerPopover appears:
        CountdownPickerPopover(title: "CountdownPicker")
            .setSelectedTimeInterval(TimeInterval())
            .setValueChange(action: { _, timeInterval in
                print("current interval \(timeInterval)")
            })
            .setDoneButton(action: { popover, timeInterval in print("timeInterval \(timeInterval)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .setClearButton(action: { popover, timeInterval in print("Clear")
                popover.setSelectedTimeInterval(TimeInterval()).reload()
            })
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func columnsString(_ sender: UIButton) {
        //ColumnStringPickerPopover appears.
        ColumnStringPickerPopover(title: "Columns Strings",
                                  choices: [["Breakfast", "Lunch", "Dinner"], ["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
                                  selectedRows: [0,0], columnPercents: [0.5, 0.5])
        .setDoneButton(action: { popover, selectedRows, selectedStrings in
            print("selected rows \(selectedRows) strings \(selectedStrings)")
        })
        .setCancelButton(action: { _,_,_ in print("cancel")})
        .setValueChange(action: { _, _, selectedStrings in
            print("current strings: \(selectedStrings)")
        })
        .setFonts([UIFont.boldSystemFont(ofSize: 14), nil])
        .setFontColors([nil, .red])
        .setSelectedRows([0,2])
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
        let p = StringPickerPopover(title: "Cell "+(indexPath as NSIndexPath).row.description, choices: ["value 1","value 2","value 3"])
        .setSelectedRow(1)
        .setValueChange(action: { _, _, selectedString in
            print("current string: \(selectedString)")
        })
        .setDoneButton(title:"👌", action: { (popover, selectedRow, selectedString) in
            print("done row \(selectedRow) \(selectedString)")
        })
        .setCancelButton(title:"👎", action: { _,_,_ in print("cancel")} )
        
        p.appear(originView: theCell, baseViewWhenOriginViewHasNoSuperview: collectionView, baseViewController: self)
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

