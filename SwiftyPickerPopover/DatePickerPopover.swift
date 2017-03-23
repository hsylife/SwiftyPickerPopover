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
    
    // MARK: - Properties
//    let storyboardName = "DatePickerPopover"
    public typealias ItemType = Date

//    var title: String?
//    var originView: UIView = UIView()
//    var baseView: UIView?
//    var baseViewController: UIViewController = UIViewController()
//
//    private var dateMode:UIDatePickerMode = .date
//    private var minimumDate:Date?
//    private var maximumDate:Date?
//    private var minuteInterval:Int = 0
//    private var permittedArrowDirections:UIPopoverArrowDirection = .any
//    private var displayStringFor:((ItemType?)->String?)?
//    private var doneAction: ((Int, ItemType)->Void)?
//    private var cancelAction: (()->Void)?
//    private var clearAction: (()->Void)?
    
    var selectedDate: Date = Date()

    // MARK: - Initializer
    
    /// Initialize a Popover with the following argument.
    ///
    /// - Parameter title: Title for navigation bar.
//    public init(title: String?){
//        super.init()
//        
//        // set parameters
//        self.title = title
//    }
    
    // MARK: - Propery setter

    /// Set property
    ///
    /// - Parameter permittedArrowDirections: Permitted arrow directions
    /// - Returns: self
//    public func setPermittedArrowDirections(_ permittedArrowDirections:UIPopoverArrowDirection)->Self{
//        self.permittedArrowDirections = permittedArrowDirections
//        return self
//    }

    
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
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView:originView, baseView: baseView, baseViewController: baseViewController, title: title, permittedArrowDirections: permittedArrowDirections) else {
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
}
