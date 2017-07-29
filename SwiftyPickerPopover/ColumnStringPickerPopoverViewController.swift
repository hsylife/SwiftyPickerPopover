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

public class ColumnStringPickerPopoverViewController: AbstractPickerPopoverViewController {

    // MARK: Types
    
    /// Popover type
    typealias PopoverType = ColumnStringPickerPopover

    // MARK: Properties
    
    /// Popover
    var popover: PopoverType? { return anyPopover as? PopoverType }

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    /// Make the popover properties reflect on this view controller
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        
        // Set up cancel button
        if #available(iOS 11.0, *) { }
        else {
            navigationItem.leftBarButtonItem = nil
        }
        cancelButton.title = popover?.cancelButton_.title
        cancelButton.tintColor = popover?.cancelButton_.color ?? popover?.tintColor
        navigationItem.setLeftBarButton(cancelButton, animated: false)

        // Set up done button
        if #available(iOS 11.0, *) { }
        else {
            navigationItem.rightBarButtonItem = nil
        }
        doneButton.title = popover?.doneButton_.title
        doneButton.tintColor = popover?.doneButton_.color ?? popover?.tintColor
        navigationItem.setRightBarButton(doneButton, animated: false)

        // Select row if needed
        if let selected = popover?.selectedRows_ {
            for x in 0..<selected.count {
                picker.selectRow(selected[x], inComponent: x, animated: true)
            }
        }
    }
    
    /// Action when tapping done button
    ///
    /// - Parameter sender: Done button
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        if let popover = popover {
            let selectedRows = popover.selectedRows_
            let selectedChoices = popover.selectedValues()
            popover.doneButton_.action?(popover, selectedRows, selectedChoices)
            
            dismiss(animated: false, completion: {})
        }
    }
    
    /// Action when tapping cancel button
    ///
    /// - Parameter sender: Cancel button
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        if let popover = popover {
            let selectedRows = popover.selectedRows_
            let selectedChoices = popover.selectedValues()
            popover.cancelButton_.action?(popover, selectedRows, selectedChoices)
            
            dismiss(animated: false, completion: {})
        }
    }
    
    /// Action to be executed after the popover disappears
    ///
    /// - Parameter popoverPresentationController: UIPopoverPresentationController
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
