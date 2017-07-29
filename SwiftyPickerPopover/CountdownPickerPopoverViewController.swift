//
//  CountdownPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Ken Torimaru on 2016/09/29.
//  Copyright © 2016 Ken Torimaru.
//
//
/*  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 */

public class CountdownPickerPopoverViewController: AbstractPickerPopoverViewController {
    
    typealias PopoverType = CountdownPickerPopover

    var popover: PopoverType? { return anyPopover as? PopoverType }

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var clearButton: UIButton!

    var hideClearButton: Bool = false
    
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()

        if #available(iOS 11.0, *) { }
        else {
            navigationItem.leftBarButtonItem = nil
        }
        cancelButton.title = popover?.cancelButton_.title
        cancelButton.tintColor = popover?.cancelButton_.color ?? popover?.tintColor
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        
        if #available(iOS 11.0, *) { }
        else {
            navigationItem.rightBarButtonItem = nil
        }
        doneButton.title = popover?.doneButton_.title
        doneButton.tintColor = popover?.doneButton_.color ?? popover?.tintColor
        navigationItem.setRightBarButton(doneButton, animated: false)

        clearButton.setTitle(popover?.clearButton_.title, for: .normal)
        clearButton.tintColor = popover?.clearButton_.color ?? popover?.tintColor
        
        if let pp = popover {
            if let _ = pp.clearButton_.action { }
            else {
                clearButton.removeFromSuperview()
                view.layoutIfNeeded()
            }

            picker.datePickerMode = .countDownTimer
            picker.countDownDuration = pp.selectedTimeInterval_
        }
    }
    
    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        popover?.doneButton_.action?(popover!, picker.countDownDuration)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        popover?.cancelButton_.action?(popover!, picker.countDownDuration)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        popover?.redoDisappearAutomatically()
        popover?.clearButton_.action?(popover!, picker.countDownDuration)
    }
    
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        popover?.redoDisappearAutomatically()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
