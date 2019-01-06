//
//  StringPickerPopoverViewController.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

public class StringPickerPopoverViewController: AbstractPickerPopoverViewController {

    // MARK: Types
    
    /// Popover type
    typealias PopoverType = StringPickerPopover
    
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
    }

    /// Make the popover properties reflect on this view controller
    override func refrectPopoverProperties(){
        super.refrectPopoverProperties()
        // Select row if needed
        picker?.selectRow(popover.selectedRow, inComponent: 0, animated: true)

        // Set up cancel button
        if #available(iOS 11.0, *) { }
        else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }

        cancelButton.title = popover.cancelButton.title
        if let font = popover.cancelButton.font {
            cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        cancelButton.tintColor = popover.cancelButton.color ?? popover.tintColor
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        
        doneButton.title = popover.doneButton.title
        if let font = popover.doneButton.font {
            doneButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
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
    
    private func enableClearButtonIfNeeded() {
        guard !clearButton.isHidden else {
            return
        }
        clearButton.isEnabled = false
        if let selectedRow = picker?.selectedRow(inComponent: 0),
            let selectedValue = popover.choices[safe: selectedRow] {
            clearButton.isEnabled = selectedValue != popover.kValueForCleared
        }
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
    
    private func tapped(button: StringPickerPopover.ButtonParameterType?) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if let selectedValue = popover.choices[safe: selectedRow] {
            button?.action?(popover, selectedRow, selectedValue)
        }
        popover.removeDimmedView()
        dismiss(animated: false)
    }

    /// Action when tapping clear button
    ///
    /// - Parameter sender: Clear button
    @IBAction func tappedClear(_ sender: AnyObject? = nil) {
        let kTargetRow = 0
        picker.selectRow(kTargetRow, inComponent: 0, animated: true)
        enableClearButtonIfNeeded()
        if let selectedValue = popover.choices[safe: kTargetRow] {
            popover.clearButton.action?(popover, kTargetRow, selectedValue)
        }
        popover.redoDisappearAutomatically()
    }
    
    /// Action to be executed after the popover disappears
    ///
    /// - Parameter popoverPresentationController: UIPopoverPresentationController
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tappedCancel()
    }
}

// MARK: - UIPickerViewDataSource
extension StringPickerPopoverViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return popover.choices.count
    }
}

// MARK: - UIPickerViewDelegate
extension StringPickerPopoverViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let value: String = popover.choices[row]
        return popover.displayStringFor?(value) ?? value
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let value: String = popover.choices[row]
        let adjustedValue: String = popover.displayStringFor?(value) ?? value
        let label: UILabel = view as? UILabel ?? UILabel()
        label.text = adjustedValue
        label.attributedText = getAttributedText(image: popover.images?[row], text: adjustedValue)
        label.textAlignment = .center
        return label
    }
    
    private func getAttributedText(image: UIImage?, text: String?) -> NSAttributedString? {
        let result: NSMutableAttributedString = NSMutableAttributedString()
        if let attributedImage = getAttributedImage(image), let space = getAttributedText(" ") {
            result.append(attributedImage)
            result.append(space)
        }
        if let attributedText = getAttributedText(text) {
            result.append(attributedText)
        }
        return result
    }
    
    private func getAttributedText(_ text: String?) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }
        let font: UIFont = {
            if let f = popover.font {
                if let size = popover.fontSize {
                    return UIFont(name: f.fontName, size: size)!
                }
                return UIFont(name: f.fontName, size: f.pointSize)!
            }
            let size = popover.fontSize ?? popover.kDefaultFontSize
            return UIFont.systemFont(ofSize: size)
        }()
        let color: UIColor = popover.fontColor
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func getAttributedImage(_ image: UIImage?) -> NSAttributedString? {
        guard let image = image else {
            return nil
        }
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        return NSAttributedString(attachment: imageAttachment)
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedResult = NSMutableAttributedString()
        
        if let image = popover.images?[row] {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            let attributedImage = NSAttributedString(attachment: imageAttachment)
            attributedResult.append(attributedImage)
            
            let AttributedMargin = NSAttributedString(string: " ")
            attributedResult.append(AttributedMargin)
        }
        
        let value: String = popover.choices[row]
        let title: String = popover.displayStringFor?(value) ?? value
        let font: UIFont = {
            if let f = popover.font {
                if let fontSize = popover.fontSize {
                    return UIFont(name: f.fontName, size: fontSize)!
                }
                return UIFont(name: f.fontName, size: f.pointSize)!
            }
            let fontSize = popover.fontSize ?? popover.kDefaultFontSize
            return UIFont.systemFont(ofSize: fontSize)
        }()
        let attributedTitle: NSAttributedString = NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: popover.fontColor])
        
        attributedResult.append(attributedTitle)
        return attributedResult
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat {
        return popover.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        enableClearButtonIfNeeded()
        popover.valueChangeAction?(popover, row, popover.choices[row])
        popover.redoDisappearAutomatically()
    }
}

