//
//  SwiftyModelPicker.swift
//  SwiftyPickerPopover
//
//  Created by Rahul Mayani on 07/09/20.
//  Copyright © 2020 Yuta Hoshino. All rights reserved.
//

import Foundation

public struct SwiftyModelPicker {
    
    /// Object unique identification number.
    public var id: Int = 0
    
    /// Display picker title of row.
    public var title: String = ""
    
    /// UIImage to attach to a choice
    public var image: UIImage? = nil
    
    /// Custome data object<String: Any>.
    public var object: Any? = nil
    
    // MARK: - Initializer
    
    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - id: Unique identification.
    ///   - title: Title for navigation bar.
    ///   - imageName:  String of image name to attach to a choice.
    ///   - image: UIImage to attach to a choice.
    ///   - object: Custom data object.
    public init(id: Int = 0, title: String = "", imageName: String = "", image: UIImage? = nil, object: Any? = nil) {
        
        // Set parameters
        self.id = id
        self.title = title
        self.image = image
        self.object = object
        
        if !imageName.isEmpty {
            self.image = UIImage(named: imageName)
        }
    }
}
