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

class ColumnStringPickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var doneAction: (([Int],[String])->Void)?
    var cancleAction: (()->Void)?
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = ColumnStringPickerPopover.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let select = ColumnStringPickerPopover.sharedInstance.selectedRow
        for x in 0..<select.count {
            picker.selectRow(select[x], inComponent: x, animated: true)
        }
    }

    
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        let selectedRow = ColumnStringPickerPopover.sharedInstance.selectedRow
        let selectedChoices = ColumnStringPickerPopover.sharedInstance.selectedStrings()
        doneAction?(selectedRow, selectedChoices)
        
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        cancleAction?()
        dismiss(animated: true, completion: {})
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
