//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

import Foundation
import UIKit

public class CountdownPickerPopover: AbstractPopover {
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
    public class func appearFrom(originView: UIView, baseViewController: UIViewController, title: String?, dateMode:UIDatePickerMode, initialInterval: TimeInterval, doneAction: ((TimeInterval)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
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
