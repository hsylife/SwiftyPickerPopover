//
//  DatePickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

public class DatePickerPopover: AbstractPopover {
    // singleton
    class var sharedInstance : DatePickerPopover {
        struct Static {
            static let instance : DatePickerPopover = DatePickerPopover()
        }
        return Static.instance
    }
    
    // selected date
    var selectedDate: Date = Date()
    
    /// Popover appears
    /// - parameter view: origin view of popover
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title for navigation bar
    /// - parameter dateMode: UIDatePickerMode
    /// - parameter initialDate: initial selected date
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    /// - parameter clearAction: action in which user tappend clear action. Omissible.
    public class func appearFrom(originView: UIView, baseViewController: UIViewController, title: String?, dateMode:UIDatePickerMode, initialDate:Date, doneAction: ((Date)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
        // create navigationController
        guard let navigationController = sharedInstance.configureNavigationController(originView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? DatePickerPopoverViewController {
            
            // UIPickerView
            contentViewController.selectedDate = initialDate
            contentViewController.dateMode = dateMode
            
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            if let action = clearAction {
                contentViewController.clearAction = action
            }
            else {
                contentViewController.hideClearButton = true
            }
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: nil)
        
    }
    
    /// storyboardName
    override func storyboardName()->String{
        return "DatePickerPopover"
    }
        
}
