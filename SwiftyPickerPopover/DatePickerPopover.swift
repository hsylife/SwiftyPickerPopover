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
    
    // selected date
    var selectedDate: Date = Date()
    
    /// Popover appears
    /// - parameter view: origin view of popover
    /// - parameter baseView: popoverPresentationController's sourceView
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title for navigation bar
    /// - parameter permittedArrowDirections the default value is .any. Omissible.
    /// - parameter secondsToAutomaticallyHide: seconds to automatically hide the popover. Omissible.
    /// - parameter afterHiddenAction: action to be performed after the popover became hidden. Omissible.
    /// - parameter dateMode: UIDatePickerMode
    /// - parameter initialDate: initial selected date
    /// - parameter minimumDate:Date? The default is nil. Omissible.
    /// - parameter maximumDate:Date? The default is nil. Omissible.
    /// - parameter minuteInterval: Int minute interval for datePicker. The default is 0. Omissible.
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    /// - parameter clearAction: action in which user tappend clear action. Omissible.
    public func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any, secondsToAutomaticallyHide: Double? = nil, afterHiddenAction: (()->Void)? = nil, dateMode:UIDatePickerMode, initialDate:Date, minimumDate:Date? = nil,  maximumDate:Date? = nil, minuteInterval:Int = 0 ,doneAction: ((Date)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
        // create navigationController
        guard let navigationController = configureNavigationController(originView, baseView: baseView, baseViewController: baseViewController, title: title, permittedArrowDirections: permittedArrowDirections) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? DatePickerPopoverViewController {
            
            // UIPickerView
            contentViewController.selectedDate = initialDate
            contentViewController.minimumDate = minimumDate
            contentViewController.maximumDate = maximumDate
            
            contentViewController.dateMode = dateMode
            contentViewController.minuteInterval = minuteInterval
            
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
        
        // automatically hide the popover
        if let seconds = secondsToAutomaticallyHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                baseViewController.dismiss(animated: false, completion: afterHiddenAction)
            }
        }
    }
    
    /// storyboardName
    override public func storyboardName()->String{
        return "DatePickerPopover"
    }
        
}
