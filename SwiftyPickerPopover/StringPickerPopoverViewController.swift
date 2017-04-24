//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class StringPickerPopoverViewController: AbstractPickerPopoverViewController {

    typealias PopoverType = StringPickerPopover
    
    var popover: PopoverType? { return anyPopover as? PopoverType }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }

    override func refrectPopoverProperties(){
        title = popover?.title
        
        if let action = popover?.cancelButton_ {
            navigationItem.leftBarButtonItem = nil
            cancelButton.title = action.title
            navigationItem.leftBarButtonItem = cancelButton
        }
        
        if let action = popover?.doneButton_ {
            navigationItem.rightBarButtonItem = nil
            doneButton.title = action.title
            navigationItem.rightBarButtonItem = doneButton
        }
        
        if let select = popover?.selectedRow_ {
            picker?.selectRow(select, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if let selectedString = popover?.choices[selectedRow]{
            popover?.doneButton_.completion?(popover!, selectedRow, selectedString)
        }
        dismiss(animated: false, completion: {})
    }
    
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if let selectedString = popover?.choices[selectedRow]{
            popover?.cancelButton_.completion?(popover!, selectedRow, selectedString)
        }
        dismiss(animated: false, completion: {})
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }


}
