//
//  AbstractPickerViewPopover.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/08/04.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

/// AbstractPickerViewPopover is the generic abstract popover for a popover which has a pickerView
///  ValueElementType: The type for value element
///  ValueType: The type for value
///  IndexRowType: The type for index row
open class AbstractPickerViewPopover<ValueElementType: Initializable, ValueType: Initializable, IndexRowType: Initializable>: AbstractPopover {

    // MARK: - Types

    /// Type of the rule closure to convert from a raw value to the display string
    public typealias DisplayStringForType = ((ValueElementType?)->String?)

    // MARK: - Properties
    
    /// Choice array
    var choices = [ValueType]()
    
    /// Array of image name to attach to a choice
    var imageNames_: [String?]?
    
    /// Convert a raw value to the string for displaying it
    var displayStringFor_:DisplayStringForType?
    
    /// Selected row
    var selectedRows_ = IndexRowType()

    /// Row height
    var rowHeight_: CGFloat = 44.0

    // MARK: - Propery setter
    
    /// Set image names
    ///
    /// - Parameter imageNames: String Array of image name to attach to a choice
    /// - Returns: Self
    public func setImageNames(_ imageNames:[String?]?)->Self{
        self.imageNames_ = imageNames
        return self
    }
    
    /// Set selected row
    ///
    /// - Parameter row: Selected row on picker
    /// - Returns: Self
    public func setSelectedRow(_ row:IndexRowType)->Self{
        self.selectedRows_ = row
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
    
    
    

}

