//
//  AbstractPopover.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2016/09/14.
//  Copyright © 2016 Yuta Hoshino. All rights reserved.
//

import Foundation
import UIKit

/// The original popover for all
open class AbstractPopover: NSObject {

    /// Name of the storyboard on which AbstractPopover is based
    let storyboardName: String

    /// Popover title
    var title: String?
    
    /// Base view controller
    weak var baseViewController: UIViewController? = UIViewController()
    /// Permitted arrow directions
    var permittedArrowDirections_:UIPopoverArrowDirection = .any
    
    /// - Item to be executed after the specified time
    /// - The time
    /// - Process to be executed after performing the DispatchWorkItem
    var disappearAutomaticallyItems: (dispatchWorkItem:DispatchWorkItem?, seconds: Double?, completion: (()->Void)?)
    
    /// ViewController in charge of content in the popover
    weak var contentViewController: AnyObject?
    /// Background color of contentViewController
    var backgroundColor: UIColor?
    /// tintColor of contentViewController
    var tintColor: UIColor?
    
    /// Size of th popover
    var size:(width: CGFloat?, height: CGFloat?)?
    
    override public init(){
        //Get a string as stroyboard name from this class name.
        storyboardName = String(describing: type(of:self))
    }
    
    // MARK: - Set permitted arr setter
    
    /// Set permitted arrow directions
    ///
    /// - Parameter permittedArrowDirections: Permitted arrow directions
    /// - Returns: Self
    open func setPermittedArrowDirections(_ permittedArrowDirections:UIPopoverArrowDirection)->Self{
        self.permittedArrowDirections_ = permittedArrowDirections
        return self
    }
    
    /// Set arrow color
    ///
    /// - Parameter color: Arrow color. Specify the color of viewController.backgroundColor
    /// - Returns: Self
    open func setArrowColor(_ color:UIColor)->Self{
        self.backgroundColor = color
        return self
    }

    /// Set popover size
    ///
    /// - Parameters:
    ///   - width: Wanting width. Omissible. If it is nil or not specified, then the default value will be used.
    ///   - height: Wanting height. Omissible. If it is nil or not specified, then the default value will be used.
    /// - Returns: Self
    open func setSize(width: CGFloat? = nil, height: CGFloat? = nil)->Self{
        self.size = (width: width, height: height)
        return self
    }
    
    // MARK: - Popover display
    
    /// Display the popover.
    ///
    /// - Parameter
    ///   - barButtonItem: Bar button item to be the origin point at where the popover appears.
    ///   - baseViewWhenOriginViewHasNoSuperview: SourceView of popoverPresentationController. Omissible. This view will be used instead of originView.superView when it is nil.
    ///   - baseViewController: Base viewController
    ///   - completion: Action to be performed after the popover appeared. Omissible.
    
    open func appear(barButtonItem: UIBarButtonItem, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, completion:(()->Void)? = nil) {
        guard let originView = barButtonItem.value(forKey: "view") as? UIView else { return }
        appear(originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, completion: completion)
    }
    
    /// Display the popover.
    ///
    /// - Parameter
    ///   - originView: View to be the origin point at where the popover appears.
    ///   - baseViewWhenOriginViewHasNoSuperview: SourceView of popoverPresentationController. Omissible. This view will be used instead of originView.superView when it is nil.
    ///   - baseViewController: Base viewController
    ///   - completion: Action to be performed after the popover appeared. Omissible.
    
    open func appear(originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, completion:(()->Void)? = nil){

        self.baseViewController = baseViewController
        
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections_ ) else { return }
        
        // configure StringPickerPopoverViewController
        let contentVC = configureContentViewController(navigationController: navigationController)
        navigationController.popoverPresentationController?.delegate = contentVC
        
        navigationController.popoverPresentationController?.backgroundColor = self.backgroundColor ?? self.baseViewController?.view.backgroundColor
        
        tintColor = baseViewController.view.tintColor
        
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
    
    /// Close the popover
    ///
    /// - Parameter completion: Action to be performed after the popover disappeared. Omissible.
    open func disappear(completion:(()->Void)? = nil){
        self.baseViewController?.dismiss(animated: false, completion: completion)
    }
    
    /// Close the popover automatically after the specified seconds.
    ///
    /// - Parameters:
    ///   - seconds: Seconds to delay closing
    ///   - completion: Action to be performed after the popover disappeared. Omissible.
    open func disappearAutomatically(after seconds: Double, completion: (()->Void)? = nil){
        // automatically hide the popover
        
        disappearAutomaticallyItems.seconds = seconds
        disappearAutomaticallyItems.completion = completion
        
        disappearAutomaticallyItems.dispatchWorkItem?.cancel()
        disappearAutomaticallyItems.dispatchWorkItem = DispatchQueue.main.cancelableAsyncAfter(deadline: .now() + seconds) {
            if let _ = self.contentViewController {
                self.baseViewController?.dismiss(animated: false, completion: completion)
            }
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
    
    /// Configure navigationController
    ///
    /// - Parameters:
    ///   - storyboardName: Storyboard name
    ///   - originView: View to be the origin point at where the popover appears.
    ///   - baseViewWhenOriginViewHasNoSuperview: SourceView of popoverPresentationController. Omissible.
    ///   - baseViewController: Base viewController
    ///   - permittedArrowDirections: The default value is '.any'. Omissible.
    /// - Returns: The configured navigationController
    open func configureNavigationController(storyboardName: String, originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any)->UINavigationController?{
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
        
        return self.configureNavigationController(navigationController: navigationController, originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections)
    }
	
	/// Configure navigationController
	///
	/// - Parameters:
	///   - navigationController: Navigation controller
	///   - originView: View to be the origin point at where the popover appears.
	///   - baseViewWhenOriginViewHasNoSuperview: SourceView of popoverPresentationController. Omissible.
	///   - baseViewController: Base viewController
	///   - permittedArrowDirections: The default value is '.any'. Omissible.
	/// - Returns: The configured navigationController
	fileprivate func configureNavigationController(navigationController: UINavigationController, originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any)->UINavigationController? {
		// define using popover
		navigationController.modalPresentationStyle = .popover
		
		// origin
		navigationController.popoverPresentationController?.sourceView = originView.superview ?? baseViewWhenOriginViewHasNoSuperview ?? baseViewController.view
		navigationController.popoverPresentationController?.sourceRect = originView.frame
		
		// direction of arrow
		navigationController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
		
		return navigationController
	}
}
