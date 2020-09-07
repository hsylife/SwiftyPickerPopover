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
    
    // for keeping selectedRow
    private var selectedRow: Int = 0
    
    @IBAction func tappedStringPickerButton(_ sender: UIButton) {
        /// Replace a string with the string to be display.
        let displayStringFor:((SwiftyModelPicker?)->SwiftyModelPicker?)? = { object in
            if let s = object {
                switch(s.title){
                case "value 1":
                    return SwiftyModelPicker(id: 1, title: "😊")
                case "value 2":
                    return SwiftyModelPicker(id: 2, title: "😏")
                case "value 3":
                    return SwiftyModelPicker(id: 3, title: "😓")
                default:
                    return s
                }
            }
            return nil
        }
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")]
        
        /// Create StringPickerPopover:
        let p = StringPickerPopover(title: "StringPicker", choices: choices)
            .setDisplayStringFor(displayStringFor)
            .setValueChange(action: { _, _, selectedObject in
                print("current string: \(selectedObject.title) & id: \(selectedObject.id)")
            })
            .setFontSize(16)
            .setDoneButton(
                font: UIFont.boldSystemFont(ofSize: 16),
                color: UIColor.orange,
                action: { popover, selectedRow, selectedObject in
                    print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
                    self.selectedRow = selectedRow
                    
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        .setSelectedRow(selectedRow)
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
    }
    
    @IBAction func didTapStringPickerWithImageButton(_ sender: UIButton) {
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: "value 1", imageName: "imageIcon"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "", imageName: "thumbUpIcon")]
        
        /// StringPickerPopover with image:
        let p = StringPickerPopover(title: "with image", choices: choices)
            .setSize(width: 280)
            .setCornerRadius(0)
            .setValueChange(action: { _, _, selectedObject in
                print("current string: \(selectedObject.title) & id: \(selectedObject.id)")
            })
            .setDoneButton(action: {
                popover, selectedRow, selectedObject in
                print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setOutsideTapDismissing(allowed: false)
            .setDimmedBackgroundView(enabled: true)
        p.appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func didTapStringPickerClearableButton(_ sender: UIButton) {
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: "value1"),SwiftyModelPicker(id: 2, title: "value2"),SwiftyModelPicker(id: 3, title: "value3")]
        
        /// StringPickerPopover Clearable:
        let p = StringPickerPopover(title: "Clearable", choices: choices)
            .setFont(UIFont.boldSystemFont(ofSize: 30))
            .setFontColor(.orange)
            .setFontSize(14)
            .setDoneButton(color: UIColor.red, action: {
                popover, selectedRow, selectedObject in
                print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setClearButton(title: "Reset", action: {(popover, row, value) in
                print("clear")
            })
        p.appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func didTapStringPickerWithTextField(_ sender: UITextField) {
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: ""), SwiftyModelPicker(id: 2, title: "Text 1"),SwiftyModelPicker(id: 3, title: "Text 2"),SwiftyModelPicker(id: 4, title: "Text 3")]
        
        StringPickerPopover(title: "TextField", choices: choices)
        .setValueChange(action: { _, _, selectedObject in
            print("current string: \(selectedObject.title) & id: \(selectedObject.id)")
        })
        .setDoneButton(action: { popover, selectedRow, selectedObject in
            sender.text = selectedObject.title
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
           
        //Setup SwiftyModelPicker data
        let column1 = [SwiftyModelPicker(id: 1, title: "Breakfast"),SwiftyModelPicker(id: 2, title: "Lunch"),SwiftyModelPicker(id: 3, title: "Dinner")]
        let column2 = [SwiftyModelPicker(id: 11, title: "Tacos"),SwiftyModelPicker(id: 12, title: "Sushi"),SwiftyModelPicker(id: 13, title: "Steak"),SwiftyModelPicker(id: 14, title: "Waffles", object: nil),SwiftyModelPicker(id: 15, title: "Burgers")]
        
        //ColumnStringPickerPopover appears.
        ColumnStringPickerPopover(title: "Columns Strings",
                                  choices: [column1, column2],
                                  selectedRows: [0,0], columnPercents: [0.5, 0.5])
        .setDoneButton(action: { popover, selectedRows, selectedObjects in
            print("selected rows \(String(describing: selectedRows.first)) id \(selectedObjects.first?.id ?? 0) strings \(selectedObjects.first?.title ?? "")")
            print("selected rows \(String(describing: selectedRows.last)) id \(selectedObjects.last?.id ?? 0) strings \(selectedObjects.last?.title ?? "")")
        })
        .setCancelButton(action: { _,_,_ in print("cancel")})
        .setValueChange(action: { _, _, selectedObjects in
            print("current strings: \(selectedObjects.first?.title ?? "")")
            print("current strings: \(selectedObjects.last?.title ?? "")")
        })
        .setFonts([UIFont.boldSystemFont(ofSize: 14), nil])
        .setFontColors([nil, .red])
        .setFontSizes([20, nil]) // override
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
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")]
        
        //StringPickerPopover appears from the cell of collectionView.
        let p = StringPickerPopover(title: "Cell "+(indexPath as NSIndexPath).row.description, choices: choices)
        .setSelectedRow(1)
        .setValueChange(action: { _, _, selectedObject in
            print("current string: \(selectedObject.title) & id: \(selectedObject.id)")
        })
        .setDoneButton(title:"👌", action: { (popover, selectedRow, selectedObject) in
            print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
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

