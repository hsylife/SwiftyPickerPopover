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
    var anyPopover: AbstractPopover!
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refrectPopoverProperties()
    }
    
    /// Make the popover property reflect on the popover
    func refrectPopoverProperties() {
        title = anyPopover.title
        
        // Change size if needed
        if let width = anyPopover.size?.width {
            navigationController?.preferredContentSize.width = width
        }
        if let height = anyPopover.size?.height {
            navigationController?.preferredContentSize.height = height
        }
    }
}

extension AbstractPickerPopoverViewController: UIPopoverPresentationControllerDelegate {
    /// Popover appears on iPhone
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    open func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        guard let allowed = anyPopover.isAllowedOutsideTappingDismissing else {
            return true
        }
        return allowed
    }
}
