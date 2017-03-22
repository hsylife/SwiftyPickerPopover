//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

import Foundation
import UIKit

public class CountdownPickerPopover: AbstractPopover {
    
    // selected date
    var timeInterval = TimeInterval()
    
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
    ///   - initialInterval: The value of the picker selected at first.
    ///   - doneAction: Action when you press done.
    ///   - cancelAction: Action when you press cancel.
    ///   - clearAction: Action When you press clear. Omissible.
    public func appearFrom(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any, secondsToAutomaticallyHide: Double? = nil, afterHiddenAction: (()->Void)? = nil, dateMode:UIDatePickerMode, initialInterval: TimeInterval, doneAction: ((TimeInterval)->Void)?, cancelAction: (()->Void)?, clearAction: (()->Void)? = nil){
        
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: "CountdownPickerPopover", originView:originView, baseView: baseView, baseViewController: baseViewController, title: title) else {
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
}
