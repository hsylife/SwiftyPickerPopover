//
//  StringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

/// StringPickerPopover has an UIPickerView that allows user to choose a String type choice.
public class StringPickerPopover: AbstractPopover {

    // MARK: Types
    
    /// Type of choice value
    public typealias ItemType = String
    /// Popover type
    public typealias PopoverType = StringPickerPopover
    /// Action type for buttons
    public typealias ActionHandlerType = (PopoverType, Int, ItemType) -> ()
    /// Button parameters type
    public typealias ButtonParameterType = (title: String, font: UIFont?, color: UIColor?, action: ActionHandlerType?)
    /// Type of the rule closure to convert from a raw value to the display string
    public typealias DisplayStringForType = ((ItemType?)->String?)

    // MARK: Constants
    let kValueForCleared: ItemType = ""

    // MARK: - Properties
    
    /// Choice array
    private(set) var choices: [ItemType] = []
    /// Array of image to attach to a choice
    private(set) var images: [UIImage?]?
    
    /// Font
    private(set) var font: UIFont?
    private(set) var fontColor: UIColor = .black
    private(set) var fontSize: CGFloat?
    let kDefaultFontSize: CGFloat = 14
    
    /// Convert a raw value to the string for displaying it
    private(set) var displayStringFor: DisplayStringForType?
    
    /// Done button parameters
    private(set) var doneButton: ButtonParameterType = (title: "Done".localized, font: nil, color: nil, action: nil)
    /// Cancel button parameters
    private(set) var cancelButton: ButtonParameterType = (title: "Cancel".localized, font: nil, color: nil, action: nil)
    /// Clear button parameters
    private(set) var clearButton: ButtonParameterType = (title: "Clear".localized, font: nil, color: nil, action: nil)

    /// Action for picker value change
    private(set) var valueChangeAction: ActionHandlerType?
    
    /// Selected row
    private(set) var selectedRow: Int = 0

    /// Row height
    private(set) var rowHeight: CGFloat = 44
    
    // MARK: - Initializer

    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - title: Title for navigation bar.
    ///   - choices: Options for picker.
    public init(title: String?, choices: [ItemType]) {
        super.init()
        
        // Set parameters
        self.title = title
        self.choices = choices
    }

    /// Set font
    ///
    /// - Parameter fontName: UIFont to change picker font
    /// - Returns: Self
    public func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    public func setFontSize(_ size: CGFloat) -> Self {
        self.fontSize = size
        return self
    }
    
    /// Set pickerFontColor
    ///
    /// - Parameter colorName: UIColor to change picker ArrayColor
    /// - Returns: Self
    public func setFontColor(_ color:UIColor) ->Self {
        self.fontColor = color
        return self
    }
    
    // MARK: - Propery setter

    /// Set image names
    ///
    /// - Parameter imageNames: String Array of image name to attach to a choice
    /// - Returns: Self
    public func setImageNames(_ imageNames: [String?]?) -> Self {
        self.images = imageNames?.map {
            guard let imageName = $0 else {
                return nil
            }
            return UIImage(named: imageName)
        }
        return self
    }

    /// Set images
    ///
    /// - Parameter images: String Array of image to attach to a choice
    /// - Returns: Self
    public func setImages(_ images: [UIImage?]?) -> Self {
        self.images = images
        return self
    }
    
    /// Set selected row
    ///
    /// - Parameter row: Selected row on picker
    /// - Returns: Self
    public func setSelectedRow(_ row: Int) -> Self {
        self.selectedRow = row
        return self
    }

    /// Set row height
    ///
    /// - Parameter height: Row height
    /// - Returns: Self
    public func setRowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }
    
    /// Set displayStringFor closure
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: Self
    public func setDisplayStringFor(_ displayStringFor: DisplayStringForType?) -> Self {
        self.displayStringFor = displayStringFor
        return self
    }
    
    /// Set done button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissible. If it is nil or not specified, then localized "Done" will be used.
    ///   - font: Button title font for .normal. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared. The popover, Selected row, Selected value. Omissible.
    /// - Returns: Self
    public func setDoneButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self {
        return setButton(button: &doneButton, title: title, font: font, color: color, action: action)

    }

    /// Set cancel button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissible. If it is nil or not specified, then localized "Cancel" will be used.
    ///   - font: Button title font for .normal. Omissible.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor. 
    ///   - action: Action to be performed before the popover disappeared.The popover, Selected row, Selected value.
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
    public func setClearButton(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self {
        // Insert the value like "" if needed
        if let item = choices.first, item != kValueForCleared {
            choices.insert(kValueForCleared, at: 0)
        }
        return setButton(button: &clearButton, title:title, font: font, color: color, action: action)
    }
    
    /// Set button arguments to the targeted button properties
    ///
    /// - Parameters:
    ///   - button: Target button properties
    ///   - title: Button title
    ///   - font: Button title font
    ///   - color: Button tintcolor
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    func setButton(button: inout ButtonParameterType, title: String? = nil, font: UIFont? = nil, color: UIColor? = nil, action: ActionHandlerType?) -> Self {
        if let title = title {
            button.title = title
        }
        if let font = font {
            button.font = font
        }
        if let color = color {
            button.color = color
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
