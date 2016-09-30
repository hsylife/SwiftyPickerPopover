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
    /// shared instance
    class var sharedInstance : StringPickerPopover {
        struct Static {
            static let instance : StringPickerPopover = StringPickerPopover()
        }
        return Static.instance
    }
    
    var choices: [String] = []
    var selectedRow: Int = 0
    var displayStringFor: ((String?)->String?)? = nil
    
    /// Popover appears
    /// - parameter originView: origin view of Popover
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title of navigation bar
    /// - parameter choices: Array of String for choices
    /// - parameter displayStringFor: translation rule of choice to display. Omissible.
    /// - parameter initialRow: initial selected row index
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    public class func appearFrom(originView: UIView, baseViewController: UIViewController, title: String?, choices:[String], displayStringFor:((String?)->String?)? = nil, initialRow:Int, doneAction: ((Int, String)->Void)?, cancelAction: (()->Void)?){
        
        // set parameters
        sharedInstance.choices = choices
        sharedInstance.selectedRow = initialRow
        sharedInstance.displayStringFor = displayStringFor
        
        // create navigationController
        guard let navigationController = sharedInstance.configureNavigationController(originView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? StringPickerPopoverViewController {
            
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: nil)
    }
    
    /// storyboardName
    override func storyboardName()->String{
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
