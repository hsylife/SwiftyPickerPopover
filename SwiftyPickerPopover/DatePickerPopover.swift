//
//  DatePickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class DatePickerPopover: AbstractPopover {
    
    // MARK: Types
    
    /// Type of choice value
    public typealias ItemType = Date
    /// Popover type
    public typealias PopoverType = DatePickerPopover
    /// Action type for buttons
    public typealias ActionHandlerType = (PopoverType, ItemType)->Void
    /// Button parameters type
    public typealias ButtonParameterType = (title: String, color:UIColor?, action:ActionHandlerType?)

    // MARK: - Properties

    /// Done button parameters
    var doneButton_: ButtonParameterType = ("Done".localized, nil, nil)
    /// Cancel button parameters
    var cancelButton_: ButtonParameterType = ("Cancel".localized, nil, nil)
    /// Clear button parameters
    var clearButton_: ButtonParameterType = ("Clear".localized, nil, nil)
    
    /// Date mode
    var dateMode_:UIDatePickerMode = .date
    /// Limit of range
    var minimumDate_: ItemType?
    var maximumDate_: ItemType?
    /// Date picker interval. Mins
    var minuteInterval_: Int = 0
    /// Selected date
    var selectedDate_: ItemType = ItemType()

    var locale_: Locale = Locale.current
    
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

    /// Set selected date
    ///
    /// - Parameter row: The default value of picker.
    /// - Returns: self
    public func setSelectedDate(_ date:ItemType)->Self{
        self.selectedDate_ = date
        return self
    }
    
    /// Set date mode of picker
    ///
    /// - Parameter dateMode: UIDatePickerMode of picker.
    /// - Returns: self
    public func setDateMode(_ dateMode:UIDatePickerMode)->Self{
        self.dateMode_ = dateMode
        return self
    }
    
    /// Set minimum date
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinimumDate(_ minimumDate:Date)->Self{
        self.minimumDate_ = minimumDate
        return self
    }

    /// Set maximun date
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMaximumDate(_ maximumDate:Date)->Self{
        self.maximumDate_ = maximumDate
        return self
    }
    
    /// Set minute interval
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinuteInterval(_ minuteInterval:Int)->Self{
        self.minuteInterval_ = minuteInterval
        return self
    }
    
    /// Set locale
    ///
    /// - Parameter localeIdentifier: The locale identifier which is used for display date picker
    /// - Returns: Self
    public func setLocale(identifier localeIdentifier:String)->Self{
        let locale = Locale(identifier: localeIdentifier)
        return setLocale(locale)
    }
    
    /// Set locale
    ///
    /// - Parameter locale: Locale which is used for display date picker
    /// - Returns: Self
    public func setLocale(_ locale:Locale)->Self{
        self.locale_ = locale
        return self
    }

    /// Set Done button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Done" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &doneButton_, title:title, color:color, action: action)
    }
    
    /// Set Cancel button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Cancel" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &cancelButton_, title:title, color:color, action: action)
    }
    
    /// Set Clear button properties
    ///
    /// - Parameters:
    ///   - title: Title for the button
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setClearButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &clearButton_, title:title, color:color, action: action)
    }
    
    /// Set button arguments to the targeted button propertoes
    ///
    /// - Parameters:
    ///   - button: Target button properties
    ///   - title: Button title
    ///   - color: Button tintcolor
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    func setButton( button: inout ButtonParameterType, title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        if let t = title{
            button.title = t
        }
        if let c = color{
            button.color = c
        }
        button.action = action
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
