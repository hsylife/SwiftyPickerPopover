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

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var clearButton: UIButton!

    var hideClearButton: Bool = false
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pp = popover {
            if let _ = pp.clearAction_ { }
            else {
                clearButton.removeFromSuperview()
                view.layoutIfNeeded()
            }
        }
    }
    
    override func refrectPopoverProperties(){
        title = popover?.title
        
        if let pp = popover {
            picker.datePickerMode = .countDownTimer
            picker.countDownDuration = pp.selectedTimeInterval_
        }
    }
    
    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        popover?.doneAction_?(popover!, picker.countDownDuration)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        popover?.cancelAction_?(popover!)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        popover?.redoDisappearAutomatically()
        popover?.clearAction_?(popover!)
    }
    
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        popover?.redoDisappearAutomatically()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }

}
