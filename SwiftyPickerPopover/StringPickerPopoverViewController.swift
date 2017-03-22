//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

public class StringPickerPopoverViewController: AbstractPickerPopoverViewController {

    public typealias PopoverType = StringPickerPopover
    public typealias ItemType = String
    
    var popover:PopoverType?

    var doneAction: ((Int, ItemType)->Void)?

    @IBOutlet weak var picker: UIPickerView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if let select = popover?.selectedRow {
            picker?.selectRow(select, inComponent: 0, animated: true)
        }
    }

    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if let selectedString = popover?.choices[selectedRow]{
            doneAction?(selectedRow, selectedString)
        }
        
        dismiss(animated: false, completion: {})
    }
}
