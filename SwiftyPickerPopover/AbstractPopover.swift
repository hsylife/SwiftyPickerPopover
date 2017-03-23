//
//  AbstractPopover.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

open class AbstractPopover: NSObject {

    let storyboardName: String

    var title: String?
    
    var baseViewController: UIViewController = UIViewController()

    var permittedArrowDirections_:UIPopoverArrowDirection = .any

    var cancelAction_: (()->Void)?

    override public init(){
        storyboardName = String(describing: type(of:self))
    }
    
    // MARK: - Propery setter
    
    /// Set property
    ///
    /// - Parameter permittedArrowDirections: Permitted arrow directions
    /// - Returns: self
    open func setPermittedArrowDirections(_ permittedArrowDirections:UIPopoverArrowDirection)->Self{
        self.permittedArrowDirections_ = permittedArrowDirections
        return self
    }
    
    /// Set property
    ///
    /// - Parameter completion: Action when you cancel done.
    /// - Returns: self
    public func setCancelAction(_ completion: (()->Void)?)->Self{
        self.cancelAction_ = completion
        return self
    }

    // MARK: - Popover display
    
    /// The popover appears.
    ///
    /// - Parameter
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    ///   - completion: Action to be performed after the popover appeared. Omissible.
    
    open func appear(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, completion:(()->Void)? = nil){
        
        print(storyboardName)

        self.baseViewController = baseViewController
        
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView: originView, baseView: baseView, baseViewController: baseViewController, title: title, permittedArrowDirections: permittedArrowDirections_ ) else { return }
        
        // configure StringPickerPopoverViewController
        let contentViewController = configureContentViewController(navigationController: navigationController)
        
        navigationController.popoverPresentationController?.delegate = contentViewController
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: completion)
    }
    
    open func configureContentViewController(navigationController: UINavigationController)->AbstractPickerPopoverViewController?{
        if let contentViewController = navigationController.topViewController as? AbstractPickerPopoverViewController {
            
            contentViewController.cancleAction = cancelAction_
            return contentViewController
        }
        
        return nil
    }
    
    /// The popover disappears.
    ///
    /// - Parameter completion: Action to be performed after the popover disappeared. Omissible.
    open func disappear(completion:(()->Void)? = nil){
        self.baseViewController.dismiss(animated: false, completion: completion)
    }
    
    /// The popover automatically disappears after the arbitrary number of seconds.
    ///
    /// - Parameters:
    ///   - seconds: Number of seconds to hide.
    ///   - completion: Action to be performed after the popover disappeared. Omissible.
    open func disappearAutomatically(after seconds: Double, completion: (()->Void)? = nil){
        // automatically hide the popover
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.baseViewController.dismiss(animated: false, completion: completion)
        }
        
    }

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
