//
//  CountdownPickerPopover.swift
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

class CountdownPickerPopover: AbstractPopover {
    // singleton
    class var sharedInstance : CountdownPickerPopover {
        struct Static {
            static let instance : CountdownPickerPopover = CountdownPickerPopover()
        }
        return Static.instance
    }
    
    // selected date
    var timeInterval = TimeInterval()
    
    /// Popover appears
    /// - parameter view: origin view of popover
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title for navigation bar
    /// - parameter dateMode: UIDatePickerMode
    /// - parameter initialInterval: initial selecte time interval
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    /// - parameter clearAction: action in which user tappend clear action. Omissible.
    class func appearFrom(_ originView: UIView, baseViewController: UIViewController, title: String?, dateMode:UIDatePickerMode, initialInterval: TimeInterval, doneAction: ((TimeInterval)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
        // create navigationController
        guard let navigationController = sharedInstance.configureNavigationController(originView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? CountdownPickerPopoverViewController {
            
            // UIPickerView
            contentViewController.timeInterval = initialInterval
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
        return "CountdownPickerPopover"
    }
        
}
