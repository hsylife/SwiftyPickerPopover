//
//  ColumnStringPickerPopoverViewController.swift
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

class ColumnStringPickerPopoverViewController: AbstractPickerPopoverViewController {

    @IBOutlet weak var picker: UIPickerView!

    var popover:ColumnStringPickerPopover = ColumnStringPickerPopover()
    var doneAction: (([Int],[String])->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = popover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let select = popover.selectedRow
        for x in 0..<select.count {
            picker.selectRow(select[x], inComponent: x, animated: true)
        }
    }

    
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        let selectedRow = popover.selectedRow
        let selectedChoices = popover.selectedStrings()
        doneAction?(selectedRow, selectedChoices)
        
        dismiss(animated: false, completion: {})
    }
    
}
