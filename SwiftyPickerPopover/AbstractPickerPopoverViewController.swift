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
    
    var anyPopover: AnyObject?
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        refrectPopoverProperties()
    }
    
    func refrectPopoverProperties(){
        title = (anyPopover as? AbstractPopover)?.title
    }
    
    /// Popover appears on iPhone
    open func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}
