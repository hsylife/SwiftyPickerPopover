//
//  DatePickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

open class DatePickerPopoverViewController: AbstractPickerPopoverViewController {
    
    var popover:DatePickerPopover = DatePickerPopover()
    var doneAction: ((Date)->Void)?
    var clearAction: (()->Void)?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var selectedDate = Date()
    var minimumDate:Date? = nil;
    var maximumDate:Date? = nil;
    var dateMode: UIDatePickerMode = .date
    var minuteInterval: Int = 0
    var hideClearButton: Bool = false

    @IBOutlet weak var clearButton: UIButton!
    
    override open func viewWillAppear(_ animated: Bool) {
        if hideClearButton {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        picker.date = selectedDate
        picker.minimumDate = minimumDate
        picker.maximumDate = maximumDate
        picker.datePickerMode = dateMode
        picker.minuteInterval = minuteInterval
    }
    
    
    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        doneAction?(picker.date)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        clearAction?()
        dismiss(animated: false, completion: {})
    }    
}
