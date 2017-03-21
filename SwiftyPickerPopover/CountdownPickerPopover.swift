//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

import Foundation
import UIKit

public class CountdownPickerPopover: AbstractPopover {

    override public init(){}
    
    // selected date
    var timeInterval = TimeInterval()
    
    /// Popover appears
    /// - parameter view: origin view of popover
    /// - parameter baseView: popoverPresentationController's sourceView
    /// - parameter baseViewController: viewController to become the base
    /// - parameter title: title for navigation bar
    /// - parameter permittedArrowDirections the default value is .any. Omissible.
    /// - parameter secondsToAutomaticallyHide: seconds to automatically hide the popover. Omissible.
    /// - parameter afterHiddenAction: action to be performed after the popover became hidden. Omissible.
    /// - parameter dateMode: UIDatePickerMode
    /// - parameter initialInterval: initial selecte time interval
    /// - parameter doneAction: action in which user tappend done button
    /// - parameter cancelAction: action in which user tappend cancel button
    /// - parameter clearAction: action in which user tappend clear action. Omissible.
    public func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any, secondsToAutomaticallyHide: Double? = nil, afterHiddenAction: (()->Void)? = nil, dateMode:UIDatePickerMode, initialInterval: TimeInterval, doneAction: ((TimeInterval)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
        // create navigationController
        guard let navigationController = configureNavigationController(originView, baseView: baseView, baseViewController: baseViewController, title: title) else {
            return
        }
        
        // StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? CountdownPickerPopoverViewController {
            
            // UIPickerView
            contentViewController.popover = self
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
        
        // automatically hide the popover
        if let seconds = secondsToAutomaticallyHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                baseViewController.dismiss(animated: false, completion: afterHiddenAction)
            }
        }
    }
    
    /// storyboardName
    override public func storyboardName()->String{
        return "CountdownPickerPopover"
    }
        
}
