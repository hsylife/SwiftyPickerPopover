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

    typealias PopoverType = ColumnStringPickerPopover

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var popover: PopoverType? { return anyPopover as? PopoverType }
    
    @IBOutlet weak var picker: UIPickerView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        
        cancelButton.title = popover?.cancelButton_.title
        cancelButton.tintColor = popover?.cancelButton_.color ?? popover?.tintColor
        navigationItem.leftBarButtonItem = cancelButton
        
        doneButton.title = popover?.doneButton_.title
        doneButton.tintColor = popover?.doneButton_.color ?? popover?.tintColor
        navigationItem.rightBarButtonItem = doneButton

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
            popover.doneButton_.action?(popover, selectedRows, selectedChoices)
            
            dismiss(animated: false, completion: {})
        }
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        if let popover = popover {
            let selectedRows = popover.selectedRows_
            let selectedChoices = popover.selectedValues()
            popover.cancelButton_.action?(popover, selectedRows, selectedChoices)
            
            dismiss(animated: false, completion: {})
        }
    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
