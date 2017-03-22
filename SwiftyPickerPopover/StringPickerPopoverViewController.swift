//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

open class StringPickerPopoverViewController: AbstractPickerPopoverViewController {

    @IBOutlet weak var picker: UIPickerView!

    var popover:StringPickerPopover?
    var doneAction: ((Int, String)->Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    override open func viewWillAppear(_ animated: Bool) {
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
