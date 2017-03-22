//
//  AbstractPopover.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

open class AbstractPopover:NSObject {
    
    override public init(){}
    
    /// Configure navigationController.
    ///
    /// - Parameters:
    ///   - storyboardName: Storyboard name
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    ///   - title: Navigation bar title
    ///   - permittedArrowDirections: The default value is .any. Omissible.
    /// - Returns: The configured navigationController.
    open func configureNavigationController(storyboardName: String, originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, title: String?, permittedArrowDirections:UIPopoverArrowDirection = .any)->UINavigationController?{
        // create ViewController for content
        let bundle = Bundle(for: AbstractPopover.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return nil
        }
        
        // define using popover
        navigationController.modalPresentationStyle = .popover
        
        // origin
        navigationController.popoverPresentationController?.sourceView = baseView ?? baseViewController.view
        navigationController.popoverPresentationController?.sourceRect = originView.frame
        
        // direction of arrow
        navigationController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        
        // navigationItem's title
        navigationController.topViewController!.navigationItem.title = title
        
        return navigationController
    }
}
