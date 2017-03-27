//
//  StringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

public class StringPickerPopover: AbstractPopover, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Types
    
    public typealias ItemType = String
    public typealias PopoverType = StringPickerPopover
    public typealias PickerPopoverViewControllerType = StringPickerPopoverViewController
    
    // MARK: - Properties
    
    var choices: [ItemType] = []
    
    var displayStringFor_:((ItemType?)->String?)?
    var doneAction_: ((PopoverType, Int, ItemType)->Void)?
    var cancelAction_: ((PopoverType)->Void)?

    var selectedRow_: Int = 0

    // MARK: - Initializer

    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - title: Title for navigation bar.
    ///   - choices: Options for picker.
    public init(title: String?, choices:[ItemType]){
        
        super.init()
        
        // set parameters
        self.title = title
        self.choices = choices
        
    }

    // MARK: - Propery setter

    /// Set property
    ///
    /// - Parameter row: Selected row of picker.
    /// - Returns: self
    public func setSelectedRow(_ row:Int)->Self{
        self.selectedRow_ = row
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
    public func setDoneAction(_ completion:((PopoverType, Int, ItemType)->Void)?)->Self{
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

    // MARK: - Popover display
    
    func reload(){
        
    }
    
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
    
    // MARK: - UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    // MARK: - UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let d = displayStringFor_ {
            return d(choices[row])
        }
        return choices[row]
    }
    

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        redoDisappearAutomatically()
    }
}
