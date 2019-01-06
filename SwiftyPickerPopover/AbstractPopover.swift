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

    public typealias VoidHandlerType = (() -> Void)

    private let kDimmedViewIdentifer = "DimmedView"

    /// Name of the storyboard on which AbstractPopover is based
    let storyboardName: String

    /// Popover title
    var title: String?
    
    /// Base view controller
    private(set) weak var baseViewController: UIViewController?
    /// Permitted arrow directions
    private(set) var permittedArrowDirections:UIPopoverArrowDirection = .any
    
    /// - Item to be executed after the specified time
    /// - The time
    /// - Process to be executed after performing the DispatchWorkItem
    private(set) var disappearAutomaticallyItems: (dispatchWorkItem: DispatchWorkItem?, seconds: Double?, completion: VoidHandlerType?)
    
    /// ViewController in charge of content in the popover
    private(set) weak var contentViewController: AnyObject?
    /// Background color of contentViewController
    private(set) var backgroundColor: UIColor?
    /// tintColor of contentViewController
    private(set) var tintColor: UIColor?
    
    /// Size of th popover
    private(set) var size:(width: CGFloat?, height: CGFloat?)?
    
    private(set) var cornerRadius: CGFloat?
    
    private(set) var isAllowedOutsideTappingDismissing: Bool?
    
    private(set) var isEnabledDimmedBackgroundView: Bool?
    
    override public init() {
        //Get a string as stroyboard name from this class name.
        storyboardName = String(describing: type(of: self))
    }
    
    // MARK: - Set permitted arr setter
    
    /// Set permitted arrow directions
    ///
    /// - Parameter permittedArrowDirections: Permitted arrow directions
    /// - Returns: Self
    open func setPermittedArrowDirections(_ permittedArrowDirections: UIPopoverArrowDirection) -> Self {
        self.permittedArrowDirections = permittedArrowDirections
        return self
    }
    
    /// Set arrow color
    ///
    /// - Parameter color: Arrow color. Specify the color of viewController.backgroundColor
    /// - Returns: Self
    open func setArrowColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    /// Set popover size
    ///
    /// - Parameters:
    ///   - width: Wanting width. Omissible. If it is nil or not specified, then the default value will be used.
    ///   - height: Wanting height. Omissible. If it is nil or not specified, then the default value will be used.
    /// - Returns: Self
    open func setSize(width: CGFloat? = nil, height: CGFloat? = nil)->Self{
        size = (width: width, height: height)
        return self
    }
    
    open func setCornerRadius(_ radius: CGFloat) -> Self {
        cornerRadius = radius
        return self
    }
    
    open func setOutsideTapDismissing(allowed: Bool = true) -> Self {
        isAllowedOutsideTappingDismissing = allowed
        return self
    }
    
    open func setDimmedBackgroundView(enabled: Bool) -> Self {
        isEnabledDimmedBackgroundView = enabled
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
    
    open func appear(barButtonItem: UIBarButtonItem, baseViewWhenOriginViewHasNoSuperview:  UIView? = nil, baseViewController: UIViewController, completion: VoidHandlerType? = nil) {
        guard let originView = barButtonItem.value(forKey: "view") as? UIView else {
            return
        }
        appear(originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, completion: completion)
    }
    
    /// Display the popover.
    ///
    /// - Parameter
    ///   - originView: View to be the origin point at where the popover appears.
    ///   - baseViewWhenOriginViewHasNoSuperview: SourceView of popoverPresentationController. Omissible. This view will be used instead of originView.superView when it is nil.
    ///   - baseViewController: Base viewController
    ///   - completion: Action to be performed after the popover appeared. Omissible.
    
    open func appear(originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, completion: VoidHandlerType? = nil) {
        // create navigationController
        guard let navigationController = configureNavigationController(storyboardName: storyboardName, originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections ) else {
            return
        }
        self.baseViewController = baseViewController
        
        // configure StringPickerPopoverViewController
        let contentVC = configureContentViewController(navigationController: navigationController)
        navigationController.popoverPresentationController?.delegate = contentVC
        
        let color = backgroundColor ?? baseViewController.navigationController?.navigationBar.barTintColor ?? baseViewController.view.backgroundColor
        navigationController.navigationBar.barTintColor = color
        navigationController.popoverPresentationController?.backgroundColor =  color
        
        tintColor = baseViewController.view.tintColor
        
        // dimmed backgorund view
        addDimmedBackgroundViewIfNeeded(baseViewController)
        
        // show popover
        baseViewController.present(navigationController, animated: true, completion: { [weak self] in
            guard let `self` = self else {
                return
            }
            if let cornerRadius = self.cornerRadius {
                navigationController.view.superview?.layer.cornerRadius = cornerRadius
            }
            completion?()
        })
    }
    
    private func addDimmedBackgroundViewIfNeeded(_ baseViewController: UIViewController) {
        if let isEnabled = isEnabledDimmedBackgroundView, isEnabled {
            let dimmedView = UIView(frame: UIScreen.main.bounds)
            dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmedView.accessibilityIdentifier = kDimmedViewIdentifer
            if let parentView = baseViewController.navigationController?.view ?? baseViewController.view {
                parentView.addSubview(dimmedView)
                parentView.bringSubviewToFront(dimmedView)
            }
        }
    }
    
    /// Configure contentViewController of popover
    ///
    /// - Parameter navigationController: Source navigationController.
    /// - Returns: ContentViewController.
    open func configureContentViewController(navigationController: UINavigationController) -> AbstractPickerPopoverViewController? {
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
    open func disappear(completion: VoidHandlerType? = nil) {
        removeDimmedView()
        baseViewController?.dismiss(animated: false, completion: completion)
    }
    
    public func removeDimmedView() {
        if let parentView = baseViewController?.navigationController?.view ?? baseViewController?.view, let dimmedView = parentView.subviews.filter({$0.accessibilityIdentifier == kDimmedViewIdentifer}).first {
            UIView.animate(withDuration: 0.4, animations: {
                dimmedView.alpha = 0
            }, completion: { _ in
                dimmedView.removeFromSuperview()
            })
        }
    }
    
    /// Close the popover automatically after the specified seconds.
    ///
    /// - Parameters:
    ///   - seconds: Seconds to delay closing
    ///   - completion: Action to be performed after the popover disappeared. Omissible.
    open func disappearAutomatically(after seconds: Double, completion: VoidHandlerType? = nil) {
        // automatically hide the popover
        disappearAutomaticallyItems.seconds = seconds
        disappearAutomaticallyItems.completion = completion
        
        disappearAutomaticallyItems.dispatchWorkItem?.cancel()
        disappearAutomaticallyItems.dispatchWorkItem = DispatchQueue.main.cancelableAsyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let `self` = self else {
                return
            }
            if let _ = self.contentViewController {
                self.disappear(completion: completion)
            }
            self.disappearAutomaticallyItems = (dispatchWorkItem: nil, seconds: nil, completion: nil)
        }
    }
    
    /// Update the started time of disappearAutomatically().
    func redoDisappearAutomatically() {
        //Redo disapperAutomatically()
        if let seconds = disappearAutomaticallyItems.seconds {
            disappearAutomatically(after: seconds, completion: disappearAutomaticallyItems.completion)
        }
    }
    
    
    /// Reload the popover with the latest properties. 
    open func reload() {
        (contentViewController as? AbstractPickerPopoverViewController)?.refrectPopoverProperties()
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
    open func configureNavigationController(storyboardName: String, originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any) -> UINavigationController? {
        var bundle: Bundle
        if let _ = Bundle.main.path(forResource: storyboardName, ofType: "storyboardc"){
            bundle = Bundle.main
        } else {
            bundle = Bundle(for: AbstractPopover.self)
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return nil
        }
        
        return configureNavigationController(navigationController: navigationController, originView: originView, baseViewWhenOriginViewHasNoSuperview: baseViewWhenOriginViewHasNoSuperview, baseViewController: baseViewController, permittedArrowDirections: permittedArrowDirections)
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
	fileprivate func configureNavigationController(navigationController: UINavigationController, originView: UIView, baseViewWhenOriginViewHasNoSuperview: UIView? = nil, baseViewController: UIViewController, permittedArrowDirections:UIPopoverArrowDirection = .any) -> UINavigationController? {
		// define using popover
		navigationController.modalPresentationStyle = .popover
		
		// origin
        let presentationController = navigationController.popoverPresentationController
		presentationController?.sourceView = originView.superview ?? baseViewWhenOriginViewHasNoSuperview ?? baseViewController.view
		presentationController?.sourceRect = originView.frame
		
		// direction of arrow
		presentationController?.permittedArrowDirections = permittedArrowDirections
		return navigationController
	}
}
