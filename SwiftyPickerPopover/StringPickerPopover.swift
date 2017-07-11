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
    var imageNames_: [String?]?
    
    var displayStringFor_:((ItemType?)->String?)?
    var doneButton_: (title: String, color:UIColor?, action:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil, nil)
    var cancelButton_: (title: String, color:UIColor?, action:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil ,nil)
    
    var selectedRow_: Int = 0

    var rowHeight_: CGFloat = 44.0
    
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

    public func setImageNames(_ imageNames:[String?]?)->Self{
        self.imageNames_ = imageNames
        return self
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

    /// Set row height
    ///
    /// - Parameter height: Row height
    /// - Returns: self
    public func setRowHeight(_ height:CGFloat)->Self{
        self.rowHeight_ = height
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
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Done" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:((PopoverType, Int, ItemType)->Void)?)->Self{
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
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Cancel" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor. 
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setCancelButton(title:String? = nil, color:UIColor? = nil, action:((PopoverType, Int, ItemType)->Void)?)->Self{
        if let t = title{
            self.cancelButton_.title = t
        }
        if let c = color{
            self.cancelButton_.color = c
        }
        self.cancelButton_.action = action
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
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let baseAtt = NSMutableAttributedString()
        
        if let imageNames = imageNames_{
            if let name = imageNames[row], let image = UIImage(named: name){
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageAtt = NSAttributedString(attachment: imageAttachment)
                baseAtt.append(imageAtt)
                
                let marginAtt = NSAttributedString(string: " ")
                baseAtt.append(marginAtt)
            }
            else {
                return nil
            }
        }
        
        var str:String?
        if let d = displayStringFor_ {
            str = d(choices[row])
        }
        
        let stringAtt = NSAttributedString(string: str ?? choices[row])
        baseAtt.append(stringAtt)
        
        return baseAtt
    }

    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight_
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        redoDisappearAutomatically()
    }
}
