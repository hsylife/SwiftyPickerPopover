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
    
    var doneAction: ((NSDate)->Void)?
    var cancleAction: (()->Void)?
    var clearAction: (()->Void)?
    
    @IBOutlet weak var picker: UIDatePicker!
    
    var selectedDate = NSDate()
    var dateMode: UIDatePickerMode = .Date
    var hideClearButton: Bool = false

    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.date = selectedDate
        picker.datePickerMode = dateMode
        clearButton.hidden = hideClearButton
    }
    
    
    @IBAction func tappedDone(sender: UIButton? = nil) {
        doneAction?(picker.date)
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func tappedCancel(sender: UIButton? = nil) {
        cancleAction?()
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func tappedClear(sender: UIButton? = nil) {
        clearAction?()
        dismissViewControllerAnimated(true, completion: {})
    }
    
    /// popover dismissed
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}
