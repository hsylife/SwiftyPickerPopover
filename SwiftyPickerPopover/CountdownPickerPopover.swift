//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

import Foundation
import UIKit

public class CountdownPickerPopover: AbstractPopover {
    
    // MARK: Types
    public typealias ItemType = TimeInterval
    public typealias PopoverType = CountdownPickerPopover
    public typealias PickerPopoverViewControllerType = CountdownPickerPopoverViewController

    // MARK: - Properties

    var doneAction_: ((PopoverType, ItemType)->Void)?
    var clearAction_: ((PopoverType)->Void)?
    var cancelAction_: ((PopoverType)->Void)?

    // selected value
    var selectedTimeInterval:ItemType = ItemType()

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
    /// - Parameter defaultInterval: The default value of picker.
    /// - Returns: self
    public func setInitialTimeInterval(_ defaultInterval:ItemType)->Self{
        self.selectedTimeInterval = defaultInterval
        return self
    }

    /// Set property
    ///
    /// - Parameter completion: Action when you press done.
    /// - Returns: self
    public func setDoneAction(_ completion:((PopoverType, ItemType)->Void)?)->Self{
        self.doneAction_ = completion
        return self
    }

    /// Set property
    ///
    /// - Parameter completion: Action when you cancel done.
    /// - Returns: self
    public func setCancelAction(_ completion: ((PopoverType)->Void)?)->Self{
        self.cancelAction_ = completion
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you press done.
    /// - Returns: self
    public func setClearAction(_ completion:((PopoverType)->Void)?)->Self{
        self.clearAction_ = completion
        return self
    }
    
    // MARK: - Popover display
    
    /// Describe the difference from the abstract class.
    ///
    /// - Parameter navigationController
    /// - Returns: The type of PickerPopoverViewController that supports this class.
    override public func configureContentViewController(navigationController: UINavigationController) -> PickerPopoverViewControllerType? {
        let contentVC = super.configureContentViewController(navigationController: navigationController)
        
        if let vc = contentVC as? PickerPopoverViewControllerType {
            vc.popover = self
            return vc
        }
        
        return contentVC as! PickerPopoverViewControllerType?
    }
}
