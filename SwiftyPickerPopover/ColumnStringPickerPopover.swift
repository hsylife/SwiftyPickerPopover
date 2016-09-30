//
//  ColumnStringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Ken Torimaru on 2016/09/29.
//  Copyright © 2016 Ken Torimaru.
//
//
/*  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*/

import Foundation
import UIKit

public class ColumnStringPickerPopover: AbstractPopover, UIPickerViewDelegate, UIPickerViewDataSource {
    /// shared instance
    class var sharedInstance : ColumnStringPickerPopover {
        struct Static {
            static let instance : ColumnStringPickerPopover = ColumnStringPickerPopover()
        }
        return Static.instance
    }
    
    var choices: [[String]] = [[]]
    var selectedRow: [Int] = [Int]()
    var columnPercent: [Float] = [Float]()
    var fontSize: CGFloat = 20.0
    var displayStringFor: ((String?)->String?)? = nil
    
    /// Popover appears
    /// - parameter originView: origin view of Popover
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title of navigation bar
    /// - parameter choices: 2 Dimensional Array of String for choices
    /// - parameter displayStringFor: translation rule of choice to display. Omissible.
    /// - parameter initialRow: initial selected row index array
    /// - parameter columnPercent: percentage width for each column
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    public class func appearFrom(originView: UIView, baseViewController: UIViewController, title: String?, choices:[[String]], displayStringFor:((String?)->String?)? = nil, initialRow:[Int],columnPercent:[Float], fontSize: CGFloat = 12.0, doneAction: (([Int],[String])->Void)?, cancelAction: (()->Void)?){
        
        // set parameters
        sharedInstance.choices = choices
        sharedInstance.selectedRow = initialRow
        sharedInstance.columnPercent = columnPercent
        sharedInstance.displayStringFor = displayStringFor
        sharedInstance.fontSize = fontSize
        
        // create navigationController
        guard let navigationController = sharedInstance.configureNavigationController(originView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? ColumnStringPickerPopoverViewController {
            
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: nil)
    }    
    
    /// storyboardName
    override func storyboardName()->String{
        return "ColumnStringPickerPopover"
    }
    
    /// UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return choices.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                    widthForComponent component: Int) -> CGFloat {
        let width = Float(pickerView.frame.size.width)
        let temp = width * columnPercent[component]
        return CGFloat(temp)
    }

    // get string of choice
    func choice(component: Int, row: Int)->String? {
        if let d = displayStringFor {
            return d(choices[component][row])
        }
        return choices[component][row]
    }
    
    // get array of selected strings
    func selectedStrings()->[String]{
        var result = [String]()
        for (index, content) in selectedRow.enumerated() {
            if let string = choice(component: index, row: content){
                result.append(string)
            }
        }
        return result
    }
    
    /// UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choice(component: component, row: row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = choices[component][row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightRegular)])
        label!.attributedText = title
        label!.textAlignment = .center
        return label!
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int){
        selectedRow[component] = row
        
    }
    
    
}
