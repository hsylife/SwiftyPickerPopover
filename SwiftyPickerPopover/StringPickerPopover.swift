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
    var doneButton_: (title: String, action:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Done", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    var cancelButton_: (title: String, action:((PopoverType, Int, ItemType)->Void)?) =
        (NSLocalizedString("Cancel", tableName: nil, bundle: Bundle(for: PopoverType.self), value: "", comment: ""), nil)
    
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
    
    /// Set property
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: self
    public func setDisplayStringFor(_ displayStringFor:((ItemType?)->String?)?)->Self{
        self.displayStringFor_ = displayStringFor
        return self
    }
    
    /// - Parameters:
    ///   - title: Title for the bar button item
    ///   - action: Action to be performed before the popover disappeared.
    /// - Returns: Self
    public func setDoneButton(title:String? = nil, action:((PopoverType, Int, ItemType)->Void)?)->Self{
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
    public func setCancelButton(title:String? = nil, action:((PopoverType, Int, ItemType)->Void)?)->Self{
        if let t = title{
            self.cancelButton_.title = t
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
            if let name = imageNames[row]{
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: name)
                let imageAtt = NSAttributedString(attachment: imageAttachment)
                baseAtt.append(imageAtt)
                
                let marginAtt = NSAttributedString(string: " ")
                baseAtt.append(marginAtt)
            }
        }
        
        var str = ""
        if let d = displayStringFor_ {
            str = d(choices[row]) ?? choices[row]
        }
        else {
            str = choices[row]
        }
        
        let stringAtt = NSAttributedString(string: str)
        baseAtt.append(stringAtt)
        
        return baseAtt
    }
    
//    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let width = pickerView.frame.size.width
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.rowHeight_))
//        
//        if let imageNames = imageNames_{
//            let margin:CGFloat = 5.0
//
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.rowHeight_ - margin , height: self.rowHeight_ - margin))
//            if let name = imageNames[row]{
//                imageView.image = UIImage(named: name)
//            }
//            view.addSubview(imageView)
//
//            let labelX = imageView.frame.origin.x + imageView.frame.size.width + margin
//            let label = UILabel(frame: CGRect(x: labelX , y: 0, width: width - labelX, height: self.rowHeight_))
//            label.textAlignment = .left
//            if let d = displayStringFor_ {
//                label.text = d(choices[row])
//            } else {
//                label.text = choices[row]
//            }
//            view.addSubview(label)
//        } else {
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width , height: self.rowHeight_))
//            label.textAlignment = .center
//            if let d = displayStringFor_ {
//                label.text = d(choices[row])
//            } else {
//                label.text = choices[row]
//            }
//            view.addSubview(label)
//        }
//        
//        return view
//    }

    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight_
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        redoDisappearAutomatically()
    }
}
