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
    ///   - dateMode: Specify UIDatePickerMode.
    ///   - initialDate: The value of the picker selected at first.
    ///   - minimumDate: Minimum value. Omissible.
    ///   - maximumDate: Maximum value. Omissible.
    ///   - minuteInterval: Specify the interval between steps in minutes. Omissible.
    ///   - doneAction: Action when you press done.
    ///   - cancelAction: Action when you press cancel.
    ///   - clearAction: Action When you press clear. Omissible.
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
