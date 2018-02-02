//
//  DatePickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class DatePickerPopoverViewController: AbstractPickerPopoverViewController {
    
    typealias PopoverType = DatePickerPopover
    
    private var popover: PopoverType? { return anyPopover as? PopoverType }
    
    @IBOutlet weak private var picker: UIDatePicker!
    @IBOutlet weak private var cancelButton: UIBarButtonItem!
    @IBOutlet weak private var doneButton: UIBarButtonItem!
    @IBOutlet weak private var clearButton: UIButton!
    
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        
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
        
        clearButton.setTitle(popover?.clearButton.title, for: .normal)
        clearButton.tintColor = popover?.clearButton.color ?? popover?.tintColor

        if popover?.clearButton.action == nil {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }

        guard let popover = popover else { return }
        picker.date = popover.selectedDate
        picker.minimumDate = popover.minimumDate
        picker.maximumDate = popover.maximumDate
        picker.datePickerMode = popover.dateMode_
        picker.locale = popover.locale
        if picker.datePickerMode != .date {
            picker.minuteInterval = popover.minuteInterval
        }
    }

    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        tapped(button: popover?.doneButton)
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        tapped(button: popover?.cancelButton)
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        popover?.clearButton.action?(popover!, picker.date)
        popover?.redoDisappearAutomatically()
    }
    
    private func tapped(button: DatePickerPopover.ButtonParameterType?) {
        button?.action?(popover!, picker.date)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        popover?.redoDisappearAutomatically()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
}
