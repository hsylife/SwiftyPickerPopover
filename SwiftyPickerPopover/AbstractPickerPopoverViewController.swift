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
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refrectPopoverProperties()
    }
    
    /// Make the popover property reflect on the popover
    func refrectPopoverProperties(){
        title = (anyPopover as? AbstractPopover)?.title
        
        // Change size if needed
        if let w = (anyPopover as? AbstractPopover)?.size?.width {
            navigationController?.preferredContentSize.width = w
        }

        if let h = (anyPopover as? AbstractPopover)?.size?.height {
            navigationController?.preferredContentSize.height = h
        }
    }
}

extension AbstractPickerPopoverViewController: UIPopoverPresentationControllerDelegate {
    /// Popover appears on iPhone
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
