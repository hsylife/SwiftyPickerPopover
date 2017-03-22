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

    var choices: [[String]] = [[]]
    var selectedRow: [Int] = [Int]()
    var columnPercent: [Float] = [Float]()
    var fontSize: CGFloat = 20.0
    var displayStringFor: ((String?)->String?)? = nil
    
    /// Popover appears with the following arguments.
    ///
    /// - Parameters:
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    ///   - title: Navigation bar title
    ///   - permittedArrowDirections: The default value is .any. Omissible.
    ///   - secondsToAutomaticallyHide: Number of seconds until the popover disappears automatically. Omissible.
    ///   - afterHiddenAction: Action to be performed after the popover disappears automatically. Omissible.
    ///   - choices: Options in the picker.
    ///   - displayStringFor: Rules for converting choice values to display strings. Omissible.
    ///   - initialRow: Initial row of picker.
    ///   - columnPercent: Ratio of each column.
    ///   - fontSize: Font size of picker.
    ///   - doneAction: Action when you press done.
    ///   - cancelAction: Action when you press cancel.
    public func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any, secondsToAutomaticallyHide: Double? = nil, afterHiddenAction: (()->Void)? = nil, choices:[[String]], displayStringFor:((String?)->String?)? = nil, initialRow:[Int],columnPercent:[Float], fontSize: CGFloat = 12.0, doneAction: (([Int],[String])->Void)?, cancelAction: (()->Void)?){
        
        // set parameters
        self.choices = choices
        self.selectedRow = initialRow
        self.columnPercent = columnPercent
        self.displayStringFor = displayStringFor
        self.fontSize = fontSize
        
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: "ColumnStringPickerPopover", originView:originView, baseView: baseView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? ColumnStringPickerPopoverViewController {
            
            contentViewController.popover = self
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: nil)
        
        // automatically hide the popover
        if let seconds = secondsToAutomaticallyHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                baseViewController.dismiss(animated: false, completion: afterHiddenAction)
            }
        }
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
