//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class StringPickerPopoverViewController: AbstractPickerPopoverViewController {

    // MARK: Types
    
    /// Popover type
    typealias PopoverType = StringPickerPopover
    
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
        if #available(iOS 11.0, *) { }
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
        if let select = popover?.selectedRow {
            picker?.selectRow(select, inComponent: 0, animated: true)
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
    
    private func tapped(button: StringPickerPopover.ButtonParameterType?) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if let selectedString = popover?.choices[selectedRow] {
            button?.action?(popover!, selectedRow, selectedString)
        }
        dismiss(animated: false, completion: {})
    }
    
    /// Action to be executed after the popover disappears
    ///
    /// - Parameter popoverPresentationController: UIPopoverPresentationController
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }


}
