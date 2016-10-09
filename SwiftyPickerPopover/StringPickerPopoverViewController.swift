//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

class StringPickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var doneAction: ((Int, String)->Void)?
    var cancleAction: (()->Void)?
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = StringPickerPopover.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        let select = StringPickerPopover.sharedInstance.selectedRow
        picker.selectRow(select, inComponent: 0, animated: true)
    }

    @IBAction func tappedDone(sender: AnyObject? = nil) {
        let selectedRow = picker.selectedRowInComponent(0)
        let selectedString = StringPickerPopover.sharedInstance.choices[selectedRow]
        doneAction?(selectedRow, selectedString)
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func tappedCancel(sender: AnyObject? = nil) {
        cancleAction?()
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
    
    /// Popover appears on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}
