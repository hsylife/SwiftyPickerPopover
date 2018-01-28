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
    private(set) var choices: [ItemType] = []
    /// Array of image name to attach to a choice
    private(set) var imageNames: [String?]?
    /// Array of image to attach to a choice
    private(set) var images: [UIImage?]?
    
    /// Font
    private(set)  var font: UIFont?
    private(set)  var fontColor: UIColor = .black
    
    /// Convert a raw value to the string for displaying it
    private(set) var displayStringFor: DisplayStringForType?
    
    /// Done button parameters
    private(set) var doneButton: ButtonParameterType = ("Done".localized, nil, nil)
    /// Cancel button parameters
    private(set) var cancelButton: ButtonParameterType = ("Cancel".localized, nil, nil)
    
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
    public init(title: String?, choices:[ItemType]){
        super.init()
        
        // Set parameters
        self.title = title
        self.choices = choices
        
    }

    /// Set font
    ///
    /// - Parameter fontName: UIFont to change picker font
    /// - Returns: Self
    public func setFont(_ font:UIFont) ->Self {
        self.font = font
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
    public func setImageNames(_ imageNames:[String?]?)->Self{
        self.imageNames = imageNames
        return self
    }

    /// Set images
    ///
    /// - Parameter images: String Array of image to attach to a choice
    /// - Returns: Self
    public func setImages(_ images:[UIImage?]?)->Self{
        self.images = images
        return self
    }
    
    /// Set selected row
    ///
    /// - Parameter row: Selected row on picker
    /// - Returns: Self
    public func setSelectedRow(_ row:Int)->Self{
        self.selectedRow = row
        return self
    }

    /// Set row height
    ///
    /// - Parameter height: Row height
    /// - Returns: Self
    public func setRowHeight(_ height:CGFloat)->Self{
        self.rowHeight = height
        return self
    }
    
    /// Set displayStringFor closure
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
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Done" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor.
    ///   - action: Action to be performed before the popover disappeared. The popover, Selected row, Selected value. Omissble.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, color:UIColor? = nil, action:ActionHandlerType?)->Self{
        return setButton(button: &doneButton, title:title, color:color, action: action)

    }

    /// Set cancel button properties
    ///
    /// - Parameters:
    ///   - title: Title for the bar button item. Omissble. If it is nil or not specified, then localized "Cancel" will be used.
    ///   - color: Button tint color. Omissible. If this is nil or not specified, then the button tintColor inherits appear()'s baseViewController.view.tintColor. 
    ///   - action: Action to be performed before the popover disappeared.The popover, Selected row, Selected value.
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
        if let d = displayStringFor {
            return d(choices[row])
        }
        return choices[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let baseAtt = NSMutableAttributedString()
        
        if let imageNames = imageNames{
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
        else if let images = images {
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
        if let d = displayStringFor {
            str = d(choices[row])
        }
        
        let stringAtt = NSAttributedString(string: str ?? choices[row])
        baseAtt.append(stringAtt)
        
        return baseAtt
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = (view as? UILabel) ?? UILabel()
        pickerLabel.textColor = fontColor
        pickerLabel.textAlignment = .center
        pickerLabel.font = self.font ?? UIFont.systemFont(ofSize: 15)
        pickerLabel.text = choices[row]
        return pickerLabel
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        redoDisappearAutomatically()
    }
}
