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
    @IBOutlet weak var clearButton: UIButton!

    var hideClearButton: Bool = false
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = popover?.clearAction_ { }
        else {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }
    }

    override func refrectPopoverProperties(){
        title = popover?.title
        
        if let pp = popover {
            picker.date = pp.selectedDate_
            picker.minimumDate = pp.minimumDate_
            picker.maximumDate = pp.maximumDate_
            picker.datePickerMode = pp.dateMode_
            picker.minuteInterval = pp.minuteInterval_
        }
        

    }

    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        popover?.doneAction_?(popover!, picker.date)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        popover?.cancelAction_?(popover!)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        popover?.clearAction_?(popover!)
        popover?.redoDisappearAutomatically()
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        popover?.redoDisappearAutomatically()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
}
