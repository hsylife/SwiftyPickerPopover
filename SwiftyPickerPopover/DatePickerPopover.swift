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
    public typealias ActionHandlerType = (PopoverType, ItemType) -> Void
    /// Button parameters type
    public typealias ButtonParameterType = (title: String, font: UIFont?, color: UIColor?, action: ActionHandlerType?)

    // MARK: - Properties

    /// Done button parameters
    private(set) var doneButton: ButtonParameterType = (title: "Done".localized, font: nil, color: nil, action: nil)
    /// Cancel button parameters
    private(set) var cancelButton: ButtonParameterType = (title: "Cancel".localized, font: nil, color: nil, action: nil)
    /// Clear button parameters
    private(set) var clearButton: ButtonParameterType = (title: "Clear".localized, font: nil, color: nil, action: nil)
    /// Action for picker value change
    private(set) var valueChangeAction: ActionHandlerType?

    /// Date mode
    private(set) var dateMode_: UIDatePicker.Mode = .date
    /// Limit of range
    private(set) var minimumDate: ItemType?
    private(set) var maximumDate: ItemType?
    /// Date picker interval. Mins
    private(set) var minuteInterval: Int = 0
    /// Selected date
    private(set) var selectedDate: ItemType = ItemType()
    private(set) var locale: Locale = Locale.current
    
    // MARK: - Initializer
    
    /// Initialize a Popover with the following argument.
    ///
    /// - Parameter title: Title for navigation bar.
    public init(title: String?){
        super.init()
        self.title = title
    }
    
    // MARK: - Propery setter

    /// Set selected date
    ///
    /// - Parameter row: The default value of picker.
    /// - Returns: self
    public func setSelectedDate(_ date:ItemType)->Self{
        self.selectedDate = date
        return self
    }
    
    /// Set date mode of picker
    ///
    /// - Parameter dateMode: UIDatePickerMode of picker.
    /// - Returns: self
    public func setDateMode(_ dateMode: UIDatePicker.Mode)->Self{
        self.dateMode_ = dateMode
        return self
    }
    
    /// Set minimum date
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinimumDate(_ minimumDate:Date)->Self{
        self.minimumDate = minimumDate
        return self
    }

    /// Set maximun date
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMaximumDate(_ maximumDate:Date)->Self{
        self.maximumDate = maximumDate
        return self
    }
    
    /// Set minute interval
    ///
    /// - Parameter minimumDate: Minimum value
    /// - Returns: self
    public func setMinuteInterval(_ minuteInterval:Int)->Self{
        self.minuteInterval = minuteInterval
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
        self.locale = locale
        return self
    }

    /// Set Done button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissible. If it is nil or not specified, then localized "Done" will be used. Omissible.
    ///   - font: Button title font. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self{
        return setButton(button: &doneButton, title: title, font: font, color: color, action: action)
    }
    
    /// Set Cancel button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissible. If it is nil or not specified, then localized "Cancel" will be used. Omissible.
    ///   - font: Button title font. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self{
        return setButton(button: &cancelButton, title: title, font: font, color: color, action: action)
    }
    
    /// Set Clear button properties
    ///
    /// - Parameters:
    ///   - title: Title for the button. Omissible.
    ///   - font: Button title font. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setClearButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self{
        return setButton(button: &clearButton, title: title, font: font, color: color, action: action)
    }
    
    /// Set button arguments to the targeted button propertoes
    ///
    /// - Parameters:
    ///   - button: Target button properties
    ///   - title: Button title
    ///   - font. Button title font
    ///   - color: Button tintcolor
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    func setButton( button: inout ButtonParameterType, title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self{
        if let t = title {
            button.title = t
        }
        if let font = font {
            button.font = font
        }
        if let c = color {
            button.color = c
        }
        button.action = action
        return self
    }
    
    /// Set an action for each value change done by user
    ///
    /// - Parameters:
    ///   -action: Action to be performed each time the picker is moved to a new value.
    /// - Returns: Self
    public func setValueChange(action: ActionHandlerType?)->Self{
        valueChangeAction = action
        return self
    }    
}
