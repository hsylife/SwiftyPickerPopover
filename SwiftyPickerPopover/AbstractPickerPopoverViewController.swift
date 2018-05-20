//
//  AbstractPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/03/22.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

/// AbstractPopover's view controller
open class AbstractPickerPopoverViewController: UIViewController {
    
    /// AbstractPopover
    var anyPopover: AnyObject?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        refrectPopoverProperties()
    }
    
    /// Make the popover property reflect on the popover
    func refrectPopoverProperties(){
        guard let popover = anyPopover as? AbstractPopover else {
            return
        }
        title = popover.title
        
        // Change size if needed
        if let width = popover.size?.width {
            navigationController?.preferredContentSize.width = width
        }
        if let height = popover.size?.height {
            navigationController?.preferredContentSize.height = height
        }
    }
}

extension AbstractPickerPopoverViewController: UIPopoverPresentationControllerDelegate {
    /// Popover appears on iPhone
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
