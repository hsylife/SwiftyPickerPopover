//
//  TextFieldCell.swift
//  SwiftyPickerPopoverDemo
//
//  Created by Y.T. Hoshino on 2018/06/20.
//  Copyright © 2018年 Yuta Hoshino. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class TextFieldCell: UITableViewCell {
    @IBOutlet private weak var textField: UITextField!
    weak var delegate: UITableViewController!

    func updateView(text: String) {
        textLabel?.text = "TextFieldCell"
        textField?.text = text
    }
    
    @IBAction func onEditingDidBegin(_ sender: UITextField) {
        DatePickerPopover(title: "From Cell")
        .appear(originView: sender, baseViewController: delegate)
    }
}
