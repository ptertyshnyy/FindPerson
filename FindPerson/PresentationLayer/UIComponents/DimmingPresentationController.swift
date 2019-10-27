//
//  DimmingPresentationController.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 25/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class DimmingPresentationController: UIPresentationController {
    
    // MARK: - Properties
    
    var dimColor: UIColor = UIColor(white: 0.0, alpha: 0.7) {
        didSet {
            backgroundView.backgroundColor = dimColor
        }
    }
    
    var contentCornerRadius: CGFloat = 0.0
    
    var dismissOnBackgroundTap: Bool = true
    
    private let backgroundView: UIView
    
    private var keyboardInsettedPresentedViewFrame: CGRect?
    
    // MARK: - Init
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backgroundView = UIView()
        backgroundView.backgroundColor = dimColor
        backgroundView.alpha = 0.0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        startObservingKeyboardNotifications()
    }
    
    deinit {
        stopObservingKeyboardNotifications()
    }
    
    // MARK: - UIContentContainer methods
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        if preferredContentSize == .zero {
            return parentSize
        } else {
            return presentedViewController.preferredContentSize
        }
    }
    
    // MARK: - UIPresentationController methods
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let contentViewBounds = containerView?.bounds ?? .zero
        let preferredContentRect: CGRect
        
        if presentedViewController.preferredContentSize == .zero {
            preferredContentRect = contentViewBounds
        } else {
            let size: CGSize = presentedViewController.preferredContentSize
            preferredContentRect = CGRect(
                x: (contentViewBounds.width - size.width) / 2,
                y: (contentViewBounds.height - size.height) / 2,
                width: size.width,
                height: size.height
            )
        }
        return preferredContentRect
    }
    
    override func presentationTransitionWillBegin() {
        backgroundView.frame = containerView?.bounds ?? .zero
        backgroundView.alpha = 0.0
        backgroundView.isUserInteractionEnabled = true
        containerView?.insertSubview(backgroundView, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        presentedViewController.view.layer.cornerRadius = contentCornerRadius
        presentedViewController.view.layer.masksToBounds = true
        
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 1.0
            }, completion: nil)
        } else {
            backgroundView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 0.0
            }, completion: nil)
        } else {
            backgroundView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        backgroundView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override var presentedView: UIView? {
        let pv = super.presentedView
        // workaround for bug with incorrect frame after dismissing vc modally over full screen
        // e.g. then present sharing in iMessage view controller
        pv?.frame = keyboardInsettedPresentedViewFrame ?? frameOfPresentedViewInContainerView
        return pv
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    // MARK: - Gesture
    
    @objc
    private func tapGesture(_ gesture: UITapGestureRecognizer) {
        if dismissOnBackgroundTap {
            presentingViewController.dismiss(animated: true)
        }
    }
    
    // MARK: - Keyboard
    
    private func startObservingKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardNotification(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardNotification(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardNotification(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
    }
    
    private func stopObservingKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidChangeFrameNotification,
                                                  object: nil)
    }
    
    @objc
    // swiftlint:disable:next function_body_length
    private func keyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let containerView = containerView,
            let presentedView = presentedViewController.viewIfLoaded,
            let inputView = findNonZeroInputAreaFrame(presentedView),
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, !keyboardFrame.isNull
            else {
                keyboardInsettedPresentedViewFrame = nil
                return
        }
        
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        let options: UIView.AnimationOptions
        if let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            options = UIView.AnimationOptions(rawValue: animationCurve << 16)
        } else {
            options = []
        }
        
        func animatePresentedView(frame: CGRect) {
            UIView.animate(
                withDuration: animationDuration,
                delay: 0.0,
                options: options,
                animations: { presentedView.frame = frame },
                completion: nil
            )
        }
        
        let keyboardFrameConverted = containerView.convert(keyboardFrame, from: nil)
        let contentViewIntersection = containerView.bounds.intersection(keyboardFrameConverted)
        if contentViewIntersection.isNull || contentViewIntersection.height == 0.0 {
            let finalFrame = frameOfPresentedViewInContainerView
            keyboardInsettedPresentedViewFrame = finalFrame
            animatePresentedView(frame: finalFrame)
            return
        }
        
        let defaultPresentedViewFrame = frameOfPresentedViewInContainerView
        
        let inputArea = inputView.inputAreaFrame
        let inputAreaConverted = containerView.convert(inputArea, from: inputView)
        let inputAreaInContainerView: CGRect = {
            var frame = inputAreaConverted
            frame.origin.y += defaultPresentedViewFrame.origin.y - presentedView.frame.origin.y
            return frame
        }()
        
        let intersected = inputAreaInContainerView.intersection(keyboardFrameConverted)
        
        let finalFrame: CGRect
        if intersected.isNull || intersected.height == 0.0 {
            finalFrame = defaultPresentedViewFrame
        } else {
            var frame = defaultPresentedViewFrame
            frame.origin.y -= intersected.height
            finalFrame = frame
        }
        
        keyboardInsettedPresentedViewFrame = finalFrame
        animatePresentedView(frame: finalFrame)
    }
    
}

private func findNonZeroInputAreaFrame(_ view: UIView) -> UIView? {
    guard view.inputAreaFrame == .zero else {
        return view
    }
    for sub in view.subviews {
        if let v = findNonZeroInputAreaFrame(sub) {
            return v
        }
    }
    return nil
}

