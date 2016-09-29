//
//  CountdownPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.countDownDuration = timeInterval
        picker.datePickerMode = dateMode
        clearButton.isHidden = hideClearButton
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
