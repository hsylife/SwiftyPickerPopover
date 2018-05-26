//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

public class CountdownPickerPopover: AbstractPopover {
    
    // MARK: Types
    /// Type of choice value
    public typealias ItemType = TimeInterval
    /// Popover type
    public typealias PopoverType = CountdownPickerPopover
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

    // Selected value
    private(set) var selectedTimeInterval:ItemType = ItemType()

    // MARK: - Initializer
    
    /// Initialize a Popover with the following argument.
    ///
    /// - Parameter title: Title for navigation bar.
    public init(title: String?){
        super.init()
        self.title = title
    }

    // MARK: - Propery setter
    
    /// Set selected time interval
    ///
    /// - Parameter interval: Value for picker.
    /// - Returns: self
    public func setSelectedTimeInterval(_ interval:ItemType)->Self{
        self.selectedTimeInterval = interval
        return self
    }

    /// Set Done button properties.
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
    
    /// Set Cancel button properties.
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
    
    /// - Parameters:
    ///   - title: Title for the button. Omissible.
    ///   - font: Button title font. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setClearButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self{
        return setButton(button: &clearButton, title:title, font: font, color: color, action: action)
    }

    /// Set button arguments to the targeted button propertoes
    ///
    /// - Parameters:
    ///   - button: Target button properties
    ///   - title: Button title
    ///   - font: Button title font
    ///   - color: Button tintcolor
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    func setButton(button: inout ButtonParameterType, title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self {
        if let t = title{
            button.title = t
        }
        if let font = font {
            button.font = font
        }
        if let c = color{
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
    public func setValueChange(action: ActionHandlerType?) -> Self{
        valueChangeAction = action
        return self
    }
}
