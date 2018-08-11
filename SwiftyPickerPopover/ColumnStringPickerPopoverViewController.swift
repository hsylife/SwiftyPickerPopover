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

public class ColumnStringPickerPopoverViewController: AbstractPickerPopoverViewController {

    // MARK: Types
    
    /// Popover type
    typealias PopoverType = ColumnStringPickerPopover

    // MARK: Properties
    
    /// Popover
    private var popover: PopoverType! { return anyPopover as? PopoverType }

    @IBOutlet weak private var cancelButton: UIBarButtonItem!
    @IBOutlet weak private var doneButton: UIBarButtonItem!
    @IBOutlet weak private var picker: UIPickerView!
    @IBOutlet weak private var clearButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
    }
    
    /// Make the popover properties reflect on this view controller
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        
        // Set up cancel button
        if #available(iOS 11.0, *) {}
        else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
        
        // Select rows if needed
        popover.selectedRows.enumerated().forEach {
            picker.selectRow($0.element, inComponent: $0.offset, animated: true)
        }

        cancelButton.title = popover.cancelButton.title
        cancelButton.tintColor = popover.cancelButton.color ?? popover.tintColor
        navigationItem.setLeftBarButton(cancelButton, animated: false)

        doneButton.title = popover.doneButton.title
        doneButton.tintColor = popover.doneButton.color ?? popover.tintColor
        navigationItem.setRightBarButton(doneButton, animated: false)

        clearButton.setTitle(popover.clearButton.title, for: .normal)
        if let font = popover.clearButton.font {
            clearButton.titleLabel?.font = font
        }
        clearButton.tintColor = popover.clearButton.color ?? popover.tintColor
        clearButton.isHidden = popover.clearButton.action == nil
        enableClearButtonIfNeeded()
    }
    
    /// Action when tapping done button
    ///
    /// - Parameter sender: Done button
    @IBAction func tappedDone(_ sender: AnyObject? = nil) {
        tapped(button: popover.doneButton)
    }
    
    /// Action when tapping cancel button
    ///
    /// - Parameter sender: Cancel button
    @IBAction func tappedCancel(_ sender: AnyObject? = nil) {
        tapped(button: popover.cancelButton)
    }
    
    private func tapped(button: ColumnStringPickerPopover.ButtonParameterType?) {
        let selectedRows = popover.selectedRows
        let selectedChoices = selectedValues()
        button?.action?(popover, selectedRows, selectedChoices)
        popover.removeDimmedView()
        dismiss(animated: false)
    }
    
    @IBAction func tappedClear(_ sender: AnyObject? = nil) {
        // Select row 0 in each componet
        for componet in 0..<picker.numberOfComponents {
            picker.selectRow(0, inComponent: componet, animated: true)
        }
        enableClearButtonIfNeeded()
        popover.clearButton.action?(popover, popover.selectedRows, selectedValues())
        popover.redoDisappearAutomatically()
    }
    
    private func enableClearButtonIfNeeded() {
        guard !clearButton.isHidden else {
            return
        }
        clearButton.isEnabled = selectedValues().filter({ $0 != popover.kValueForCleared}).count > 0
    }
    
    /// Action to be executed after the popover disappears
    ///
    /// - Parameter popoverPresentationController: UIPopoverPresentationController
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
}

// MARK: - UIPickerViewDataSource
extension ColumnStringPickerPopoverViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return popover.choices.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return popover.choices[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width * CGFloat(popover.columnPercents[component])
    }
    
    private func selectedValue(component: Int, row: Int) -> ColumnStringPickerPopover.ItemType? {
        guard let items = popover.choices[safe: component],
            let selectedValue = items[safe: row] else {
                return nil
        }
        return popover.displayStringFor?(selectedValue) ?? selectedValue
    }
    
    private func selectedValues() -> [ColumnStringPickerPopover.ItemType] {
        var result = [ColumnStringPickerPopover.ItemType]()
        popover.selectedRows.enumerated().forEach {
            if let value = selectedValue(component: $0.offset, row: $0.element){
                result.append(value)
            }
        }
        return result
    }
}

extension ColumnStringPickerPopoverViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let value: String = popover.choices[component][row]
        let adjustedValue: String = popover.displayStringFor?(value) ?? value
        let label: UILabel = view as? UILabel ?? UILabel()
        label.text = adjustedValue
        label.attributedText = getAttributedText(adjustedValue, component: component)
        label.textAlignment = .center
        return label
    }
    
    private func getAttributedText(_ text: String?, component: Int) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }
        let font: UIFont = {
            if let f = popover.fonts?[component] {
                if let size = popover.fontSizes?[component] {
                    return UIFont(name: f.fontName, size: size)!
                }
                return UIFont(name: f.fontName, size: f.pointSize)!
            }
            let size = popover.fontSizes?[component] ?? popover.kDefaultFontSize
            return UIFont.systemFont(ofSize: size)
        }()
        let color: UIColor = popover.fontColors?[component] ?? popover.kDefaultFontColor
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int){
        popover.selectedRows[component] = row
        enableClearButtonIfNeeded()
        popover.valueChangeAction?(popover, popover.selectedRows, selectedValues())
        popover.redoDisappearAutomatically()
    }
}
