//
//  DatePickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class DatePickerPopoverViewController: AbstractPickerPopoverViewController {
    
    typealias PopoverType = DatePickerPopover
    
    var popover: PopoverType? { return anyPopover as? PopoverType }
    
    @IBOutlet weak public var picker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
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

        if let _ = popover?.clearButton_.action { }
        else {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }

        if let pp = popover {
            picker.date = pp.selectedDate_
            picker.minimumDate = pp.minimumDate_
            picker.maximumDate = pp.maximumDate_
            picker.datePickerMode = pp.dateMode_
            picker.locale = pp.locale_
            if picker.datePickerMode != .date {
                picker.minuteInterval = pp.minuteInterval_
            }
        }
        

    }

    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        popover?.doneButton_.action?(popover!, picker.date)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        popover?.cancelButton_.action?(popover!, picker.date)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        popover?.clearButton_.action?(popover!, picker.date)
        popover?.redoDisappearAutomatically()
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        popover?.redoDisappearAutomatically()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
}
