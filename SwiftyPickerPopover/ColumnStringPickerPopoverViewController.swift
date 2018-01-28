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
    private var popover: PopoverType? { return anyPopover as? PopoverType }

    @IBOutlet weak private var cancelButton: UIBarButtonItem!
    @IBOutlet weak private var doneButton: UIBarButtonItem!
    @IBOutlet weak private var picker: UIPickerView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    /// Make the popover properties reflect on this view controller
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        
        // Set up cancel button
        if #available(iOS 11.0, *) {}
        else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
        
        cancelButton.title = popover?.cancelButton.title
        cancelButton.tintColor = popover?.cancelButton.color ?? popover?.tintColor
        navigationItem.setLeftBarButton(cancelButton, animated: false)

        doneButton.title = popover?.doneButton.title
        doneButton.tintColor = popover?.doneButton.color ?? popover?.tintColor
        navigationItem.setRightBarButton(doneButton, animated: false)

        // Select row if needed
        popover?.selectedRows.enumerated().forEach {
            picker.selectRow($0.1, inComponent: $0.0, animated: true)
        }
    }
    
    /// Action when tapping done button
    ///
    /// - Parameter sender: Done button
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        tapped(button: popover?.doneButton)
    }
    
    /// Action when tapping cancel button
    ///
    /// - Parameter sender: Cancel button
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        tapped(button: popover?.cancelButton)
    }
    
    private func tapped(button: ColumnStringPickerPopover.ButtonParameterType?) {
        guard let popover = popover else { return }
        let selectedRows = popover.selectedRows
        let selectedChoices = popover.selectedValues()
        button?.action?(popover, selectedRows, selectedChoices)
        dismiss(animated: false, completion: {})
    }
    
    /// Action to be executed after the popover disappears
    ///
    /// - Parameter popoverPresentationController: UIPopoverPresentationController
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
