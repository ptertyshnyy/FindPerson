//
//  DismissInteractor.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 25/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import UIKit

internal class DismissInteractor: UIPercentDrivenInteractiveTransition {
    
    private(set) var hasStarted: Bool = false
    
    private(set) var shouldFinish: Bool = false
    
    private let treshold: CGFloat = 0.4
    
    private let accelerationThreshold: CGFloat = 500.0
    
    private let direction: DismissAnimator.AnimationDirection
    
    weak var viewController: UIViewController? {
        didSet {
            oldValue?.view.removeGestureRecognizer(gestureRecognizer)
            viewController?.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    private var gestureRecognizer: UIPanGestureRecognizer!
    
    init(allowedDirection: DismissAnimator.AnimationDirection = .down) {
        self.direction = allowedDirection
        super.init()
        completionSpeed = 0.4
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gestureRecognizer.delegate = self
    }
    
    deinit {
        viewController?.view.removeGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = viewController?.view else {
            return
        }
        switch gestureRecognizer.state {
        case .began:
            if !hasStarted {
                hasStarted = true
                viewController?.dismiss(animated: true)
            }
        case .changed:
            let translation = gestureRecognizer.translation(in: view)
            let acceleration = gestureRecognizer.velocity(in: view).y
            let verticalMovement: CGFloat = translation.y / view.bounds.height
            let accelerationProgress: CGFloat
            let progress: CGFloat
            switch direction {
            case .down:
                progress = verticalMovement >= 0.0 ? verticalMovement : 0.0
                accelerationProgress = acceleration >= 0.0 ? acceleration : 0.0
            case .up:
                progress = verticalMovement < 0.0 ? abs(verticalMovement) : 0.0
                accelerationProgress = acceleration < 0.0 ? abs(acceleration) : 0.0
            }
            shouldFinish = progress > treshold || accelerationProgress > accelerationThreshold
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
    
}

extension DismissInteractor: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }
        return scrollView.contentOffset.y <= 0.0
    }
}

internal class DismissAnimator: NSObject {
    let direction: AnimationDirection
    
    init(direction: AnimationDirection) {
        self.direction = direction
        super.init()
    }
}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    
    enum AnimationDirection: Int {
        case up
        case down
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        let screenBounds = UIScreen.main.bounds
        
        let finalFrame: CGRect
        
        switch direction {
        case .up:
            let topLeftCorner = CGPoint(x: 0, y: -screenBounds.size.height)
            finalFrame = CGRect(origin: topLeftCorner, size: screenBounds.size)
        case .down:
            let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
            finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
                fromVC.view.frame = finalFrame
            }, completion: { _ in
                if !transitionContext.transitionWasCancelled {
                    fromVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

