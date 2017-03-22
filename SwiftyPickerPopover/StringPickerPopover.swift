//
//  StringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

public class StringPickerPopover: AbstractPopover, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var choices: [String] = []
    var selectedRow: Int = 0
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
    ///   - doneAction: Action when you press done.
    ///   - cancelAction: Action when you press cancel.
    public func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any, secondsToAutomaticallyHide: Double? = nil, afterHiddenAction: (()->Void)? = nil, choices:[String], displayStringFor:((String?)->String?)? = nil, initialRow:Int, doneAction: ((Int, String)->Void)?, cancelAction: (()->Void)?){
        
        // set parameters
        self.choices = choices
        self.selectedRow = initialRow
        self.displayStringFor = displayStringFor
        
        // create navigationController
        guard let navigationController = configureNavigationController(originView, baseView: baseView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? StringPickerPopoverViewController {
            
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
    
    /// storyboardName
    override public func storyboardName()->String{
        return "StringPickerPopover"
    }
    
    /// UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    /// UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let d = displayStringFor {
            return d(choices[row])
        }
        return choices[row]
    }
    
    
}
