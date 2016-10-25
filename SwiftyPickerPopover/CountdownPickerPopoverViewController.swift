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

class CountdownPickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var doneAction: ((TimeInterval)->Void)?
    var cancleAction: (()->Void)?
    var clearAction: (()->Void)?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var timeInterval = TimeInterval()
    var dateMode: UIDatePickerMode = .countDownTimer
    var hideClearButton: Bool = false

    @IBOutlet weak var clearButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if hideClearButton {
            clearButton.removeFromSuperview()
            view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.countDownDuration = timeInterval
        picker.datePickerMode = dateMode
    }
    
    
    @IBAction func tappedDone(_ sender: UIButton? = nil) {
        doneAction?(picker.countDownDuration)
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: UIButton? = nil) {
        cancleAction?()
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        clearAction?()
        dismiss(animated: true, completion: {})
    }
    
    /// popover dismissed
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
