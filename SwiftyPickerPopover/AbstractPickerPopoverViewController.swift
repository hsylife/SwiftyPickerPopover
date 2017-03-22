//
//  AbstractPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/03/22.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

open class AbstractPickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    open var cancleAction: (()->Void)?

    @IBAction open func tappedCancel(_ sender: AnyObject? = nil) {
        cancleAction?()
        dismiss(animated: false, completion: {})
    }
    
    open func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

    /// Popover appears on iPhone
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
