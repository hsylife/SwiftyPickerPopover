//
//  StringPickerPopover.swift
//  SwiftyPickerPopover
//
//  Created by Yuta Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

public class StringPickerPopover: AbstractPopover, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    let storyboardName = "StringPickerPopover"
    
    var title: String?
    var choices: [String] = []
    var originView: UIView = UIView()
    var baseView: UIView?
    var baseViewController: UIViewController = UIViewController()
    private var permittedArrowDirections:UIPopoverArrowDirection = .any
    
    private var displayStringFor:((String?)->String?)?
    private var  doneAction: ((Int, String)->Void)?
    private var cancelAction: (()->Void)?
    
    var selectedRow: Int = 0

    // MARK: - Initializer

    /// Initialize a Popover with the following arguments.
    ///
    /// - Parameters:
    ///   - title: Navigation bar title
    ///   - choices: Options for the picker.
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    public init(title: String?, choices:[String], originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController){
        
        super.init()
        
        // set parameters
        self.title = title
        self.choices = choices
        self.originView = originView
        self.baseView = baseView
        self.baseViewController = baseViewController
        self.choices = choices
        
    }

    // MARK: - Propery setter

    /// Set property
    ///
    /// - Parameter permittedArrowDirections: Permitted arrow directions
    /// - Returns: self
    public func setPermittedArrowDirections(_ permittedArrowDirections:UIPopoverArrowDirection)->Self{
        self.permittedArrowDirections = permittedArrowDirections
        return self
    }
    
    /// Set property
    ///
    /// - Parameter initialRow: Initial row of picker.
    /// - Returns: self
    public func setInitialRow(_ initialRow:Int)->Self{
        self.selectedRow = initialRow
        return self
    }

    /// Set property
    ///
    /// - Parameter displayStringFor: Rules for converting choice values to display strings.
    /// - Returns: self
    public func setDisplayStringFor(_ displayStringFor:((String?)->String?)?)->Self{
        self.displayStringFor = displayStringFor
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you press done.
    /// - Returns: self
    public func setDoneAction(_ completion:((Int, String)->Void)?)->Self{
        self.doneAction = completion
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you cancel done.
    /// - Returns: self
    public func setCancelAction(_ completion: (()->Void)?)->Self{
        self.cancelAction = completion
        return self
    }

    // MARK: - Popover display

    /// The popover appears.
    ///
    /// - Parameter completion: Action to be performed after the popover appeared. Omissible.
    public func appear(completion:(()->Void)? = nil){
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView: originView, baseView: baseView, baseViewController: baseViewController, title: title, permittedArrowDirections: permittedArrowDirections ) else {
            return
        }
        
        // configure StringPickerPopoverViewController
        if let contentViewController = navigationController.topViewController as? StringPickerPopoverViewController {
            
            contentViewController.popover = self
            contentViewController.doneAction = doneAction
            contentViewController.cancleAction = cancelAction
            
            navigationController.popoverPresentationController?.delegate = contentViewController
        }
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: completion)
    }
    
    /// Hide the popover.
    ///
    /// - Parameter completion: Action to be performed after the popover disappeared. Omissible.
    public func hide(completion:(()->Void)? = nil){
        self.baseViewController.dismiss(animated: false, completion: completion)
    }
    
    /// Hide the popover automatically after the arbitrary number of seconds.
    ///
    /// - Parameters:
    ///   - seconds: Number of seconds to hide.
    ///   - completion: Action to be performed after the popover disappeared. Omissible.
    public func hideAutomatically(after seconds: Double, completion: (()->Void)? = nil){
        // automatically hide the popover
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.baseViewController.dismiss(animated: false, completion: completion)
        }

    }
    
    // MARK: - UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    // MARK: - UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let d = displayStringFor {
            return d(choices[row])
        }
        return choices[row]
    }
    
    
}
