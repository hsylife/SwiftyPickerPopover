//
//  CountdownPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by ktorimaru on 2016/09.
//

public class CountdownPickerPopover: AbstractPopover {
    
    // MARK: Types
    public typealias ItemType = TimeInterval
    public typealias PopoverType = CountdownPickerPopover
    public typealias PickerPopoverViewControllerType = CountdownPickerPopoverViewController

    // MARK: - Properties

    var doneButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var cancelButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var clearButton_: (title: String, action:((PopoverType, ItemType)->Void)?) =
        (NSLocalizedString("Clear", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)

    // selected value
    var selectedTimeInterval_:ItemType = ItemType()

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
    /// - Parameter interval: Value for picker.
    /// - Returns: self
    public func setSelectedTimeInterval(_ interval:ItemType)->Self{
        self.selectedTimeInterval_ = interval
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
    ///   - completion: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setClearButton(title:String? = nil, action:((PopoverType, ItemType)->Void)?)->Self{
        if let t = title{
            self.clearButton_.title = t
        }
        self.clearButton_.action = action
        return self
    }

}
