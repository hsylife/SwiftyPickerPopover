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

import Foundation
import UIKit

open class CountdownPickerPopoverViewController: AbstractPickerPopoverViewController {
    
    @IBOutlet weak var picker: UIDatePicker!

    var popover:CountdownPickerPopover = CountdownPickerPopover()
    var doneAction: ((TimeInterval)->Void)?
    var clearAction: (()->Void)?
    
    var timeInterval = TimeInterval()
    var dateMode: UIDatePickerMode = .countDownTimer
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
        picker.countDownDuration = timeInterval
        picker.datePickerMode = dateMode
    }
    
    
    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        doneAction?(picker.countDownDuration)
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        clearAction?()
        dismiss(animated: false, completion: {})
    }    
}
