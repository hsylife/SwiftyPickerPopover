//
//  DatePickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class DatePickerPopover: AbstractPopover {
    
    // MARK: Types
    
    public typealias ItemType = Date
    public typealias PopoverType = DatePickerPopover
    public typealias PickerPopoverViewControllerType = DatePickerPopoverViewController

    // MARK: - Properties

    var doneButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var cancelButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var clearButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Clear", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    
    var dateMode_:UIDatePickerMode = .date
    var minimumDate_: ItemType?
    var maximumDate_: ItemType?
    var minuteInterval_: Int = 0
    var selectedDate_: ItemType = ItemType()

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
    /// - Parameter row: The default value of picker.
    /// - Returns: self
    public func setSelectedDate(_ date:ItemType)->Self{
        self.selectedDate_ = date
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
    
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, action:((PopoverType, ItemType)->Void)?)->Self{
        if let t = title{
            self.doneButton_.title = t
        }
        self.doneButton_.action = action
        return self
    }
    
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, action:((PopoverType, ItemType)->Void)?)->Self{
        if let t = title{
            self.cancelButton_.title = t
        }
        self.cancelButton_.action = action
        return self
    }
    
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setClearButton(title:String? = nil, action:((PopoverType, ItemType)->Void)?)->Self{
        if let t = title{
            self.clearButton_.title = t
        }
        self.clearButton_.action = action
        return self
    }
    
    // MARK: - Popover display
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Redo disapperAutomatically()
        if let seconds = disappearAutomaticallyItems.seconds {
            disappearAutomatically(after: seconds, completion: disappearAutomaticallyItems.completion)
        }
    }
}
