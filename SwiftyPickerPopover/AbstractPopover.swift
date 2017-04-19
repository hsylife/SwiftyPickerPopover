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
    
    var disappearAutomaticallyItems: (dispatchWorkItem:DispatchWorkItem?, seconds: Double?, completion: (()->Void)?)
    
    var contentViewController: AnyObject?
    
    override public init(){
        //Get a string as stroyboard name from this class name.
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
    

    // MARK: - Popover display
    
    /// The popover appears.
    ///
    /// - Parameter
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    ///   - completion: Action to be performed after the popover appeared. Omissible.
    
    open func appear(originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, completion:(()->Void)? = nil){

        self.baseViewController = baseViewController
        
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView: originView, baseView: baseView, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections_ ) else { return }
        
        // configure StringPickerPopoverViewController
        let contentVC = configureContentViewController(navigationController: navigationController)
        navigationController.popoverPresentationController?.delegate = contentVC
        
        // presnet popover
        baseViewController.present(navigationController, animated: true, completion: completion)
    }
    
    /// Configure contentViewController of popover
    ///
    /// - Parameter navigationController: Source navigationController.
    /// - Returns: ContentViewController.
    open func configureContentViewController(navigationController: UINavigationController)->AbstractPickerPopoverViewController?{
        if let contentViewController = navigationController.topViewController as? AbstractPickerPopoverViewController {
            contentViewController.anyPopover = self
            self.contentViewController = contentViewController
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
        
        disappearAutomaticallyItems.seconds = seconds
        disappearAutomaticallyItems.completion = completion
        
        disappearAutomaticallyItems.dispatchWorkItem?.cancel()
        disappearAutomaticallyItems.dispatchWorkItem = DispatchQueue.main.cancelableAsyncAfter(deadline: .now() + seconds) {
            self.baseViewController.dismiss(animated: false, completion: completion)
            self.disappearAutomaticallyItems = (nil,nil,nil)
        }
    }
    
    /// Update the started time of disappearAutomatically().
    func redoDisappearAutomatically(){
        //Redo disapperAutomatically()
        if let seconds = disappearAutomaticallyItems.seconds {
            disappearAutomatically(after: seconds, completion: disappearAutomaticallyItems.completion)
        }
    }
    
    
    /// Reload the popover with the latest properties. 
    open func reload(){
        (self.contentViewController as? AbstractPickerPopoverViewController)?.refrectPopoverProperties()
    }
    
    /// Configure navigationController.
    ///
    /// - Parameters:
    ///   - storyboardName: Storyboard name
    ///   - originView: The view to be the origin point where the popover appears.
    ///   - baseView: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: The base viewController
    ///   - permittedArrowDirections: The default value is .any. Omissible.
    /// - Returns: The configured navigationController.
    open func configureNavigationController(storyboardName: String, originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any)->UINavigationController?{
        var bundle:Bundle
        if let _ = Bundle.main.path(forResource: storyboardName, ofType: "storyboardc"){
            bundle = Bundle.main
        } else {
            bundle = Bundle(for: AbstractPopover.self)
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return nil
        }
        
        return self.configureNavigationController(navigationController: navigationController, originView: originView, baseView: baseView, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections)
    }
	
	fileprivate func configureNavigationController(navigationController: UINavigationController, originView: UIView, baseView: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any)->UINavigationController? {
		// define using popover
		navigationController.modalPresentationStyle = .popover
		
		// origin
		navigationController.popoverPresentationController?.sourceView = baseView ?? baseViewController.view
		navigationController.popoverPresentationController?.sourceRect = originView.frame
		
		// direction of arrow
		navigationController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
		
		return navigationController
	}
}
