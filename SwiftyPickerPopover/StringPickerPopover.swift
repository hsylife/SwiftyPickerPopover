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
    public typealias ActionHandlerType = (PopoverType, Int, ItemType)->Void
    /// Button parameters type
    public typealias ButtonParameterType = (title: String, color:UIColor?, action:ActionHandlerType?)
    /// Type of the rule closure to convert from a raw value to the display string
    public typealias DisplayStringForType = ((ItemType?)->String?)

    // MARK: - Properties
    
    /// Choice array
    var choices: [ItemType] = []
    /// Array of image name to attach to a choice
    var imageNames_: [String?]?
    /// Array of image to attach to a choice
    var images_: [UIImage?]?
    
    /// Convert a raw value to the string for displaying it
    var displayStringFor_:DisplayStringForType?
    
    /// Done button parameters
    var doneButton_: ButtonParameterType = ("Done".localized, nil, nil)
    /// Cancel button parameters
    var cancelButton_: ButtonParameterType = ("Cancel".localized, nil, nil)
    
    /// Selected row
    var selectedRow_: Int = 0

    /// Row height
    var rowHeight_: CGFloat = 44.0
    
    // MARK: - Initializer

    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - title: Title for navigation bar.
    ///   - choices: Options for picker.
    public init(title: String?, choices:[ItemType]){
        super.init()
        
        // Set parameters
        self.title = title
        self.choices = choices
        
    }

    // MARK: - Propery setter

    /// Set image names
    ///
    /// - Parameter imageNames: String Array of image name to attach to a choice
    /// - Returns: Self
    public func setImageNames(_ imageNames:[String?]?)->Self{
        self.imageNames_ = imageNames
        return self
    }

    /// Set images
    ///
    /// - Parameter images: String Array of image to attach to a choice
    /// - Returns: Self
    public func setImages(_ images:[UIImage?]?)->Self{
        self.images_ = images
        return self
    }
    
    /// Set selected row
    ///
    /// - Parameter row: Selected row on picker
    /// - Returns: Self
    public func setSelectedRow(_ row:Int)->Self{
        self.selectedRow_ = row
        return self
    }

    /// Set row height
    ///
    /// - Parameter height: Row height
    /// - Returns: Self
    public func setRowHeight(_ height:CGFloat)->Self{
        self.rowHeight_ = height
        return self
    }
    
    /// Set displayStringFor closure
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
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Done" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared. The popover, Selected row, Selected value. Omissble.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &doneButton_, title:title, color:color, action: action)

    }

    /// Set cancel button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Cancel" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor. 
    ///   - action: Action to be performed before the popover disappeared.The popover, Selected row, Selected value.
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
        else if let images = images_ {
            if let image = images[row] {
                
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
