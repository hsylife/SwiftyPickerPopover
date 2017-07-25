//
//  ColumnStringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Ken Torimaru on 2016/09/29.
//  Copyright © 2016 Ken Torimaru.
//
//
/*  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*/
//  Modified by Yuta Hoshino on 2017/07/24. 

/// ColumnStringPickerPopover has an UIPickerView of multiple columns.
public class ColumnStringPickerPopover: AbstractPopover {
    
    // MARK: Types
    
    /// Type of choice value
    public typealias ItemType = String
    /// Popover type
    public typealias PopoverType = ColumnStringPickerPopover
    /// Action type for buttons
    public typealias ActionHandlerType = (PopoverType, [Int], [ItemType])->Void
    /// Button parameters type
    public typealias ButtonParameterType = (title: String, color:UIColor?, action:ActionHandlerType?)
    /// Type of the rule closure to convert from a raw value to the display string
    public typealias DisplayStringForType = ((ItemType?)->String?)

    // MARK: - Properties

    /// Choice array. Nest.
    var choices: [[ItemType]] = [[]]
    /// Selected rows
    var selectedRows_: [Int] = [Int]()
    /// Column ratio
    var columnPercents_: [Float] = [Float]()
    /// Font size
    var fontSize_: CGFloat = 12.0
    
    /// Convert a raw value to the string for displaying it
    var displayStringFor_: DisplayStringForType?
    
    /// Done button parameters
    var doneButton_: ButtonParameterType = ("Done".localized, nil, nil)
    /// Cancel button parameters
    var cancelButton_: ButtonParameterType = ("Cancel".localized, nil, nil)

    // MARK: - Initializer
    
    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - title: Title for navigation bar.
    ///   - choices: Options for picker.
    ///   - selectedRow: Selected rows of picker.
    ///   - columnPercent: Rate of each column of picker
    public init(title: String?, choices:[[ItemType]], selectedRows:[Int], columnPercents:[Float]){
        super.init()
        
        // Set parameters
        self.title = title
        self.choices = choices
        self.selectedRows_ = selectedRows
        self.columnPercents_ = columnPercents
    }

    // MARK: - Propery setter
    
    /// Set selected rows
    ///
    /// - Parameter row: Selected rows of picker
    /// - Returns: Self
    public func setSelectedRows(_ rows:[Int])->Self{
        self.selectedRows_ = rows
        return self
    }
    
    /// Set displayStringFor closures
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: Self
    public func setDisplayStringFor(_ displayStringFor:DisplayStringForType?)->Self{
        self.displayStringFor_ = displayStringFor
        return self
    }

    /// Set done button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &doneButton_, title:title, color:color, action: action)
    }
    
    /// Set cancel button properties.
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &cancelButton_, title:title, color:color, action: action)
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
    
    /// Set font size
    ///
    /// - Parameter fontSize: Font size on picker
    /// - Returns: Self
    public func setFontSize(_ fontSize:CGFloat)->Self{
        self.fontSize_ = fontSize
        return self
    }

    

}

// MARK: - UIPickerViewDelegate
extension ColumnStringPickerPopover: UIPickerViewDelegate{
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choice(component: component, row: row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = choices[component][row]
        let title = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize_, weight: UIFont.Weight.regular)])
        label!.attributedText = title
        label!.textAlignment = .center
        return label!
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int){
        
        selectedRows_[component] = row
        
        redoDisappearAutomatically()
    }

}

// MARK: - UIPickerViewDataSource
extension ColumnStringPickerPopover: UIPickerViewDataSource{
    
    /// UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return choices.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           widthForComponent component: Int) -> CGFloat {
        let width = Float(pickerView.frame.size.width)
        let temp = width * columnPercents_[component]
        return CGFloat(temp)
    }
    
    // get string of choice
    func choice(component: Int, row: Int)->ItemType? {
        if let d = displayStringFor_ {
            return d(choices[component][row])
        }
        return choices[component][row]
    }
    
    // get array of selected values
    func selectedValues()->[ItemType]{
        var result = [ItemType]()
        for (index, content) in selectedRows_.enumerated() {
            if let string = choice(component: index, row: content){
                result.append(string)
            }
        }
        return result
    }
 
}
