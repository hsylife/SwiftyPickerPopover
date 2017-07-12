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

public class ColumnStringPickerPopover: AbstractPopover {
    
    // MARK: Types
    
    public typealias ItemType = String
    public typealias PopoverType = ColumnStringPickerPopover
    public typealias PickerPopoverViewControllerType = ColumnStringPickerPopoverViewController
    
    // MARK: - Properties

    var choices: [[ItemType]] = [[]]
    var selectedRows_: [Int] = [Int]()
    var columnPercents_: [Float] = [Float]()
    
    var fontSize_: CGFloat = 12.0
    var displayStringFor_: ((ItemType?)->String?)?
    
    var doneButton_: (title: String, color:UIColor?, action:((PopoverType, [Int], [ItemType])->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil,nil)
    var cancelButton_: (title: String, color:UIColor?, action:((PopoverType, [Int], [ItemType])->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil,nil)

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
        
        // set parameters
        self.title = title
        self.choices = choices
        self.selectedRows_ = selectedRows
        self.columnPercents_ = columnPercents
    }

    // MARK: - Propery setter
    
    /// Set property
    ///
    /// - Parameter row: Selected rows of picker.
    /// - Returns: self
    public func setSelectedRows(_ rows:[Int])->Self{
        self.selectedRows_ = rows
        return self
    }
    
    /// Set DisplayString
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: self
    public func setDisplayStringFor(_ displayStringFor:((ItemType?)->String?)?)->Self{
        self.displayStringFor_ = displayStringFor
        return self
    }

    /// Set Done button properties.
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:((PopoverType, [Int], [ItemType])->Void)?)->Self{
        if let t = title{
            self.doneButton_.title = t
        }
        if let c = color{
            self.doneButton_.color = c
        }
        self.doneButton_.action = action
        return self
    }
    
    /// Set Cancel button properties.
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, color:UIColor? = nil, action:((PopoverType, [Int], [ItemType])->Void)?)->Self{
        if let t = title{
            self.cancelButton_.title = t
        }
        if let c = color{
            self.cancelButton_.color = c
        }
        self.cancelButton_.action = action
        return self
    }

    
    /// Set property
    ///
    /// - Parameter fontSize: Font size of picker
    /// - Returns: self
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
