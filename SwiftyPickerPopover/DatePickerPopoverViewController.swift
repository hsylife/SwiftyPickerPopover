//
//  DatePickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

class DatePickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var doneAction: ((Date)->Void)?
    var cancleAction: (()->Void)?
    var clearAction: (()->Void)?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var selectedDate = Date()
    var minimumDate:Date? = nil;
    var maximumDate:Date? = nil;
    var dateMode: UIDatePickerMode = .date
    var minuteInterval: Int = 0
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
    
    @IBAction func tappedCancel(_ sender: UIButton? = nil) {
        cancleAction?()
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedClear(_ sender: UIButton? = nil) {
        clearAction?()
        dismiss(animated: false, completion: {})
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
