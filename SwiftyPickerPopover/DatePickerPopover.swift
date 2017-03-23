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
    
    // MARK: Types
    
    public typealias ItemType = Date
    public typealias PickerPopoverViewController = DatePickerPopoverViewController

    // MARK: - Properties

    var displayStringFor_:((ItemType?)->String?)?
    var doneAction_: ((ItemType)->Void)?
    var clearAction_: (()->Void)?
    var dateMode_:UIDatePickerMode = .date
    var minimumDate_: Date?
    var maximumDate_: Date?
    var minuteInterval_: Int = 0
    
    var selectedDate: Date = Date()

    // MARK: - Initializer
    
    /// Initialize a Popover with the following argument.
    ///
    /// - Parameter title: Title for navigation bar.
    public init(title: String?){
        super.init()
        
        // set parameters
        self.title = title
    }
    
    // MARK: - Propery setter

    /// Set property
    ///
    /// - Parameter initialRow: Initial row of picker.
    /// - Returns: self
    public func setInitialDate(_ initialDate:Date)->Self{
        self.selectedDate = initialDate
        return self
    }
    
    /// Set property
    ///
    /// - Parameter dateMode: UIDatePickerMode of picker.
    /// - Returns: self
    public func setDateMode(_ dateMode:UIDatePickerMode)->Self{
        self.dateMode_ = dateMode
        return self
    }
    
    /// Set property
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinimumDate(_ minimumDate:Date)->Self{
        self.minimumDate_ = minimumDate
        return self
    }

    /// Set property
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMaximumDate(_ maximumDate:Date)->Self{
        self.maximumDate_ = maximumDate
        return self
    }
    
    /// Set property
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinuteInterval(_ minuteInterval:Int)->Self{
        self.minuteInterval_ = minuteInterval
        return self
    }
    
    /// Set property
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: self
    public func setDisplayStringFor(_ displayStringFor:((ItemType?)->String?)?)->Self{
        self.displayStringFor_ = displayStringFor
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you press done.
    /// - Returns: self
    public func setDoneAction(_ completion:((ItemType)->Void)?)->Self{
        self.doneAction_ = completion
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you press done.
    /// - Returns: self
    public func setClearAction(_ completion:(()->Void)?)->Self{
        self.clearAction_ = completion
        return self
    }
    
    // MARK: - Popover display
    
    /// Describe the difference to abstract class.
    ///
    /// - Parameter navigationController
    /// - Returns: The type of PickerPopoverViewController that supports this class.
    override public func configureContentViewController(navigationController: UINavigationController) -> PickerPopoverViewController? {
        let contentVC = super.configureContentViewController(navigationController: navigationController)
        
        if let vc = contentVC as? PickerPopoverViewController {
            vc.popover = self
            return vc
        }
        
        return contentVC as! PickerPopoverViewController?
    }
}
