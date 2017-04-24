//
//  StringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class StringPickerPopover: AbstractPopover {

    // MARK: Types
    
    public typealias ItemType = String
    public typealias PopoverType = StringPickerPopover
    public typealias PickerPopoverViewControllerType = StringPickerPopoverViewController
    
    // MARK: - Properties
    
    var choices: [ItemType] = []
    
    var displayStringFor_:((ItemType?)->String?)?
    var doneButton_: (title: String, completion:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var cancelButton_: (title: String, completion:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    
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
    
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, completion:((PopoverType, Int, ItemType)->Void)?)->Self{
        if let t = title{
            self.doneButton_.title = t
        }
        self.doneButton_.completion = completion
        return self
    }

    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, completion:((PopoverType, Int, ItemType)->Void)?)->Self{
        if let t = title{
            self.cancelButton_.title = t
        }
        self.cancelButton_.completion = completion
        return self
    }
}

// MARK: - UIPickerViewDataSource
extension StringPickerPopover: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
}

// MARK: - UIPickerViewDelegate
extension StringPickerPopover: UIPickerViewDelegate {
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
