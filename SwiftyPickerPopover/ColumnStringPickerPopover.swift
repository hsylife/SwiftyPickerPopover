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
    private(set) var choices: [[ItemType]] = [[]]
    /// Selected rows
    private(set) var selectedRows: [Int] = [Int]()
    /// Column ratio
    private(set) var columnPercents: [Float] = [Float]()
    ///Font
    private(set) var fonts: [UIFont?]?
    private(set) var fontSizes: [CGFloat?]?
    private let kDefaultFontSize:CGFloat = 12
    private(set) var fontColors: [UIColor?]?
    private let kDefaultFontColor: UIColor = .black

    /// Convert a raw value to the string for displaying it
    private var displayStringFor: DisplayStringForType?
    
    /// Done button parameters
    private(set) var doneButton: ButtonParameterType = (title:"Done".localized, color: nil, action: nil)
    /// Cancel button parameters
    private(set) var cancelButton: ButtonParameterType = (title:"Cancel".localized, color: nil, action: nil)

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
        self.selectedRows = selectedRows
        self.columnPercents = columnPercents
    }

    // MARK: - Propery setter
    
    /// Set selected rows
    ///
    /// - Parameter row: Selected rows of picker
    /// - Returns: Self
    public func setSelectedRows(_ rows:[Int])->Self{
        self.selectedRows = rows
        return self
    }
    
    /// Set displayStringFor closures
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: Self
    public func setDisplayStringFor(_ displayStringFor:DisplayStringForType?)->Self{
        self.displayStringFor = displayStringFor
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
        return setButton(button: &doneButton, title:title, color:color, action: action)
    }
    
    /// Set cancel button properties.
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &cancelButton, title:title, color:color, action: action)
    }

    /// Set button arguments to the targeted button propertoes
    ///
    /// - Parameters:
    ///   - button: Target button properties
    ///   - title: Button title
    ///   - color: Button tintcolor
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    func setButton(button: inout ButtonParameterType, title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        if let t = title{
            button.title = t
        }
        if let c = color{
            button.color = c
        }
        button.action = action
        return self
    }
    
    /// Set fonts
    public func setFonts(_ fonts:[UIFont?]) ->Self {
        self.fonts = fonts
        return self
    }
    
    /// Set pickerFontColors
    public func setFontColors(_ colors:[UIColor?]) ->Self {
        self.fontColors = colors
        return self
    }
    
    /// Set font sizes
    public func setFontSizes(_ fontSizes:[CGFloat?])->Self{
        self.fontSizes = fontSizes
        return self
    }
}

// MARK: - UIPickerViewDelegate
extension ColumnStringPickerPopover: UIPickerViewDelegate{
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label:UILabel = view as? UILabel ?? UILabel()
        
        let title = choices[component][row]
        label.text = choice(component: component, row: row)
        
        let fontSize: CGFloat = fontSizes?[component] ?? kDefaultFontSize
        let font: UIFont = fonts?[component] ?? UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        let fontColor: UIColor = fontColors?[component] ?? kDefaultFontColor
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: fontColor])
        label.attributedText = attributedTitle
        
        label.textAlignment = .center
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int){
        
        selectedRows[component] = row
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
        let temp = width * columnPercents[component]
        return CGFloat(temp)
    }
    
    // get string of choice
    func choice(component: Int, row: Int)->ItemType? {
       return displayStringFor?(choices[component][row]) ?? choices[component][row]
    }
    
    // get array of selected values
    func selectedValues()->[ItemType]{
        var result = [ItemType]()
        for (index, content) in selectedRows.enumerated() {
            if let string = choice(component: index, row: content){
                result.append(string)
            }
        }
        return result
    }
 
}
