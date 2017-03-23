//
//  ColumnStringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Ken Torimaru on 2016/09/29.
//  Copyright © 2016 Ken Torimaru.
//
//
/*  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 */

import Foundation
import UIKit

public class ColumnStringPickerPopoverViewController: AbstractPickerPopoverViewController {

    typealias PopoverType = ColumnStringPickerPopover

    var popover:PopoverType?
    
    @IBOutlet weak var picker: UIPickerView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if let selected = popover?.selectedRows_ {
            for x in 0..<selected.count {
                picker.selectRow(selected[x], inComponent: x, animated: true)
            }
        }
    }

    
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        if let popover = popover {
            let selectedRows = popover.selectedRows_
            let selectedChoices = popover.selectedValues()
            popover.doneAction_?(popover, selectedRows, selectedChoices)
            
            dismiss(animated: false, completion: {})
        }
    }
    
    @IBAction open func tappedCancel(_ sender: AnyObject? = nil) {
        popover?.cancelAction_?(popover!)
        dismiss(animated: false, completion: {})
    }
    
    open func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
